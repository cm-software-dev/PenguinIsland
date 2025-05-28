//
//  GameViewModel.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 28/05/2025.
//

import Foundation

class GameViewModel {
    
    var level: Level!
    let numRows: Int = 16
    let numColumns: Int = 9
    var numMines = 15
    let gameEndAlpha: CGFloat = 0.6
    
    private var flagsPlanted = 0 {
        didSet {
            didUpdateFlagsPlanted?(numMines-flagsPlanted)
        }
    }
    
    var didUpdateFlagsPlanted: ((Int) -> ())?
    
    var haveVictory: (() -> ())?
 
    init() {
        numMines = UserDefaults.standard.integer(forKey: SettingsKeys.eggs.rawValue)
        level = Level(numColumns: numColumns, numRows: numRows, mines: numMines)
    }
    
    func gameOver() {
        level.gameOver = true
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
    
    func layMines() ->  Array2D<Tile> {
        return level.layMines()
    }
    
    func resetFlags() {
        flagsPlanted = 0
    }
    
    func handleFlagToggled(tile: Tile) {
        let flag = tile.flagged
        if flag {
            flagsPlanted+=1
        }
        else {
            flagsPlanted-=1
        }
        if tile.mine && flag {
            level.correctFlags+=1
        }
        else if tile.mine && !flag {
            level.correctFlags-=1
        }
        if level.correctFlags == level.mines {
            level.victory = true
            haveVictory?()
        }
    }
    
}
