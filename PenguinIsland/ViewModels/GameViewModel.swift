//
//  GameViewModel.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 28/05/2025.
//

import Foundation
import AVKit

class GameViewModel {
    
    var level: Level!
    var numRows: Int 
    var numColumns: Int
    var numMines: Int
    
    let gameEndAlpha: CGFloat = 0.6
    
    var musicLevel: Float
    var fxLevel: Float
    
    private var flagsPlanted = 0 {
        didSet {
            didUpdateFlagsPlanted?(numMines-flagsPlanted)
        }
    }
    
    var didUpdateFlagsPlanted: ((Int) -> ())?
    
    var haveVictory: (() -> ())?
    
    lazy var backgroundMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "RoundShapes", withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.volume = playMusic ? musicLevel : 0.0
            return player
        } catch {
            return nil
        }
    }()
    
    lazy var victoryMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "VictoryTheme", withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume =  playMusic ? musicLevel : 0.0
            return player
        } catch {
            return nil
        }
    }()
    
    
    lazy var plantFlagSound: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "FlagTap", withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume = playMusic ? fxLevel : 0.0
            return player
        } catch {
            return nil
        }
    }()
    
    lazy var removeFlagSound: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "UnflagTap", withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume = playMusic ? fxLevel : 0.0
            return player
        } catch {
            return nil
        }
    }()
    
     lazy var gameOverMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "GameOver", withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume = playMusic ? fxLevel : 0.0
            return player
        } catch {
            return nil
        }
    }()
    
    var playMusic: Bool {
        didSet {
            if playMusic {
                if !level.gameOver {
                    backgroundMusic?.play()
                }
            }
            else {
                backgroundMusic?.pause()
            }
            setSoundImageForPlayMusic(playMusic)
            UserDefaults.standard.set(!playMusic, forKey: SettingsKeys.muted.rawValue)
        }
    }
    
    var soundImage: UIImage? = UIImage(named: "win95_sound")
 
    init() {
        playMusic = !UserDefaults.standard.bool(forKey: SettingsKeys.muted.rawValue)
        fxLevel = UserDefaults.standard.float(forKey: SettingsKeys.fxVolume.rawValue)
        musicLevel = UserDefaults.standard.float(forKey: SettingsKeys.musicVolume.rawValue)
        numMines = UserDefaults.standard.integer(forKey: SettingsKeys.eggs.rawValue)
        
        let gameSizeRawValue = UserDefaults.standard.integer(forKey: SettingsKeys.gameSize.rawValue)
        let gameSize = GameSize(rawValue: gameSizeRawValue) ?? .iphoneDefault
        let difficultySettings = DifficultySettings(gameSize)
        numRows = difficultySettings.numRows
        numColumns = difficultySettings.numColumns
        
        level = Level(numColumns: numColumns, numRows: numRows, mines: numMines)
        setSoundImageForPlayMusic(playMusic)
    }
    
    private func setSoundImageForPlayMusic(_ playMusic: Bool) {
        if playMusic {
            soundImage = UIImage(named: "win95_sound")
        }
        else {
            soundImage = UIImage(named: "win95_sound_muted")
        }
    }
    
    func gameOver() {
        level.gameOver = true
    }
    
    func playGameOverMusic() {
        if playMusic {
            gameOverMusic?.play()
        }
    }
    
    func playBackgroundMusic() {
        if playMusic {
            backgroundMusic?.play()
        }
    }
    
    func playVictoryMusic() {
        if playMusic {
            victoryMusic?.play()
        }
    }
    
    func checkVictory() {
        let isVictory = (numRows * numColumns - level.visibleTiles) == level.mines
        level.victory = isVictory
        if isVictory {
            haveVictory?()
        }
    }
    
    func getNewLevel() -> Level {
        level = Level(numColumns: numColumns, numRows: numRows, mines: numMines)
        return level
    }
    
    func layMines(_ safeIndex: Int? = nil) ->  Array2D<Tile> {
        return level.layMines(safeIndex)
    }
    
    func resetFlags() {
        flagsPlanted = 0
    }
    
    private func removeFlagFromTile(_ tile: Tile) {
        if playMusic {
            removeFlagSound?.play()
        }
        flagsPlanted-=1
        if tile.mine {
            level.correctFlags-=1
        }
    }
    
    private func plantFlagOnTile(_ tile: Tile) {
        if playMusic {
            plantFlagSound?.play()
        }
        flagsPlanted+=1
        if tile.mine {
            level.correctFlags+=1
        }
    }
    
    func handleFlagToggled(tile: Tile) -> Bool {
        if flagsPlanted >= numMines {
            //remove flag if already there otherwise do nothing
            if tile.flagged {
                removeFlagFromTile(tile)
                return true
            }
            return false
        }
        else {
            tile.flagged.toggle()
            plantFlagSound?.stop()
            removeFlagSound?.stop()
            
            let flag = tile.flagged
            
            if flag {
                plantFlagOnTile(tile)
            }
            else {
                removeFlagFromTile(tile)
            }
        
            if level.correctFlags == level.mines {
                level.victory = true
                haveVictory?()
            }
            return true
        }
        
    }
    
}


enum GameSize: Int {
    case ipadSmall = 1
    case ipadMedium = 2
    case ipadLarge = 3
    case iphoneDefault = 4
}

//get rid of difficulty enum defined here - instead have 3 ipad only options in the settings
//with the default parameters below.
//the mines can still be edited with the slider
//set the slider ranges based on the selected difficulty

struct DifficultySettings {
    
    let numRows: Int
    let numColumns: Int
    let numMines: Int
    
    init(_ size: GameSize) {
        switch size {
        case .ipadSmall:
            numRows = 9
            numColumns = 9
            numMines = 10
        case .ipadMedium:
            numRows = 16
            numColumns = 16
            numMines = 40
        case .ipadLarge:
            numRows = 16
            numColumns = 30
            numMines = 99
        case .iphoneDefault:
            numRows = 16
            numColumns = 9
            numMines = 15
        }
    }
}
