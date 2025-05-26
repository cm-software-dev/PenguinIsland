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
    
    var level: Level!
    var scene: GameScene!
    
    private var tapFromColumn: Int?
    private var tapFromRow: Int?
    
    let numRows: Int = 16
    let numColumns: Int = 9
    let numMines = 15
    
    @IBOutlet weak var tryAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        tryAgainButton.isHidden = true
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size, numRows: numRows, numColumns: numColumns)
        scene.scaleMode = .aspectFill
        
        level = Level(numColumns: numColumns, numRows: numRows, mines: numMines)
        scene.level = level
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
    }
    
    func beginGame() {
        layMines()
    }
    
    func layMines() {
        let newTiles = level.layMines()
        scene.addSprites(for: newTiles)
    }
    
    @IBAction func tryAgainPressed(_ sender: Any) {
        beginGame()
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
