//
//  GameViewController.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 25/05/2025.
//

import UIKit
import SpriteKit
import GameplayKit
import AVKit

class GameViewController: UIViewController {
        
    var level: Level!
    var scene: GameScene!
    
    private var tapFromColumn: Int?
    private var tapFromRow: Int?
    
    let numRows: Int = 16
    let numColumns: Int = 9
    let numMines = 15
    
    private var flagsPlanted = 0 {
        didSet {
            flagsLabel.text = "\(numMines-flagsPlanted)"
        }
    }
    
    @IBOutlet weak var flagsLabel: UILabel!
    @IBOutlet weak var gameOverImage: UIImageView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var addFlagButton: UIButton!
    
    @IBOutlet weak var exitButton: UIImageView!
    
    @IBOutlet weak var soundImage: UIImageView! {
        didSet {
            soundImage.isUserInteractionEnabled = true
            soundImage.image = UIImage(named: "win95_sound")
        }
    }
    
    private var playMusic = true {
        didSet {
            if playMusic {
                backgroundMusic?.play()
                soundImage.image = UIImage(named: "win95_sound")
            }
            else {
                backgroundMusic?.pause()
                soundImage.image = UIImage(named: "win95_sound_muted")
            }
        }
    }
    
    private var plantingFlag: Bool = false {
        didSet {
            if plantingFlag {
                addFlagButton.setImage(UIImage(named: "FlagButtonWithIconPressed"), for: .normal)
            }
            else {
                addFlagButton.setImage(UIImage(named: "FlagButtonWithIcon"), for: .normal)
            }
        }
    }
    
    lazy var backgroundMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "RoundShapes", withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            return player
        } catch {
            return nil
        }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOverImage.isHidden = true
        tryAgainButton.setBackgroundImage(UIImage(named: "PlayAgainButton"), for: .selected)
        addFlagButton.setBackgroundImage(UIImage(named: "FlagButtonWithIconPressed"), for: .selected)
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        tryAgainButton.isHidden = true
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        level = Level(numColumns: numColumns, numRows: numRows, mines: numMines)
        scene.level = level
        
        scene.tapHandler = handleTap(tile:)
        scene.flagPlantedHandler = handleFlagToggled(tile:)
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
        
        if playMusic {
            backgroundMusic?.play()
        }
    }
    
    func handleTap(tile: Tile) {
        if tile.mine {
            level.gameOver = true
            scene.gameOver()
            showGameOver()
        }
        checkVictory()
    }
    
    private func checkVictory() {
        
        if (numRows * numColumns - level.visibleTiles) == level.mines {
            level.victory = true
            showVictory()
        }
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
            showVictory()
        }
    }
    
    
    private func showVictory() {
        backgroundMusic?.stop()
        gameOverImage.image = UIImage(named: "VictoryWindow")
        gameOverImage.isHidden = false
        scene.isUserInteractionEnabled = false
        tryAgainButton.isHidden = false
        addFlagButton.isHidden = true
        scene.alpha = 0.6
        //do something
    }
    
    private func showGameOver() {
        scene.isUserInteractionEnabled = false
        tryAgainButton.isHidden = false
        gameOverImage.isHidden = false
        addFlagButton.isHidden = true
        backgroundMusic?.stop()
    }
    
    func beginGame() {
        scene.isUserInteractionEnabled = true
        resetValues()
        layMines()
    }
    
    private func resetValues() {
        flagsPlanted = 0
        plantingFlag = false
        scene.plantingFlag = plantingFlag
    }
    
    private func layMines() {
        let newTiles = level.layMines()
        scene.addSprites(for: newTiles)
    }
    
    @IBAction func tryAgainPressed(_ sender: Any) {
        tryAgainButton.isHidden = true
        addFlagButton.isHidden = false
        gameOverImage.isHidden = true
        if playMusic {
            backgroundMusic?.play()
        }
        scene.alpha = 1
        level = Level(numColumns: numColumns, numRows: numRows, mines: numMines)
        scene.level = level
        beginGame()
    }
    
    @IBAction func addFlagPressed(_ sender: Any) {
        plantingFlag.toggle()
        scene.plantingFlag = plantingFlag
    }
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @IBAction func didTapSoundImageView(_ sender: UITapGestureRecognizer) {
        playMusic.toggle()
    }
    
    
    @IBAction func tapExitImage(_ sender: Any) {
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
