//
//  GameViewController.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 25/05/2025.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    //var tapGestureRecognizer: UITapGestureRecognizer!
    
    var level: Level!
    var scene: GameScene!
    
    private var tapFromColumn: Int?
    private var tapFromRow: Int?
    
    let numRows: Int = 16
    let numColumns: Int = 9
    let numMines = 15
    
    @IBOutlet weak var gameOverImage: UIImageView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var addFlagButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOverImage.isHidden = true
        tryAgainButton.setBackgroundImage(UIImage(named: "TryAgainButtonPressed"), for: .selected)
        
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
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
    }
    
    func handleTap(tile: Tile) {
        if tile.mine {
            level.gameOver = true
            scene.gameOver()
            showGameOver()
        }
    }
    
    func handleFlagToggled(tile: Tile, flag: Bool) {
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
        //do something
    }
    
    private func showGameOver() {
        scene.isUserInteractionEnabled = false
        tryAgainButton.isHidden = false
        gameOverImage.isHidden = false
        addFlagButton.isHidden = true
    }
    
    func beginGame() {
        scene.isUserInteractionEnabled = true
        layMines()
    }
    
    func layMines() {
        let newTiles = level.layMines()
        scene.addSprites(for: newTiles)
    }
    
    @IBAction func tryAgainPressed(_ sender: Any) {
        tryAgainButton.isHidden = true
        addFlagButton.isHidden = false
        gameOverImage.isHidden = true
        beginGame()
    }
    
    @IBAction func addFlagPressed(_ sender: Any) {
        scene.plantingFlag.toggle()
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
