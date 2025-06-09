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
  
    var scene: GameScene!
    
    private let viewModel = GameViewModel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        viewModel.didUpdateFlagsPlanted = {
            (flagValue: Int) in
            self.flagsLabel.text = "\(flagValue)"
        }
        
        viewModel.haveVictory = showVictory
        
        flagsLabel.text = "\(viewModel.numMines)"
        
        gameOverImage.isHidden = true
        tryAgainButton.setBackgroundImage(UIImage(named: "PlayAgainButton"), for: .selected)
        addFlagButton.setBackgroundImage(UIImage(named: "FlagButtonWithIconPressed"), for: .selected)
        
       // setGameScene()
        
        addFlagButton.isEnabled = false
        beginGame()
        
        viewModel.playBackgroundMusic()
        
        soundImage.image = viewModel.soundImage
        
    }
    
    private func setGameScene() {
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        tryAgainButton.isHidden = true
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size, rows: viewModel.numRows, columns: viewModel.numColumns)
        scene.scaleMode = .aspectFit
        
        scene.level = viewModel.getNewLevel()
        scene.layMines = layMinesWithSafeIndex
        scene.tapHandler = handleTap(tile:)
        scene.flagPlantedHandler = handleFlagToggled(tile:)
        
        // Present the scene.
        skView.presentScene(scene)
    }
      
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.backgroundMusic?.stop()
    }
    
    private func layMinesWithSafeIndex(_ safeIndex: Int) {
        self.layMines(safeIndex)
    }
    
    func handleTap(tile: Tile) {
        if tile.mine {
            tile.broken = true
            viewModel.gameOver()
            scene.gameOver()
            showGameOver()
        }
        viewModel.checkVictory()
    }
    
    func handleFlagToggled(tile: Tile) -> Bool {
        return viewModel.handleFlagToggled(tile: tile)
    }
    
    
    private func showVictory() {
        viewModel.backgroundMusic?.stop()
        gameOverImage.image = UIImage(named: "VictoryWindowEgg")
        gameOverImage.isHidden = false
        scene.isUserInteractionEnabled = false
        tryAgainButton.isHidden = false
        addFlagButton.isHidden = true
        scene.alpha = viewModel.gameEndAlpha
        viewModel.playVictoryMusic()
        scene.showAllMines()
    }
    
    private func showGameOver() {
        scene.isUserInteractionEnabled = false
        tryAgainButton.isHidden = false
        gameOverImage.isHidden = false
        addFlagButton.isHidden = true
        viewModel.backgroundMusic?.stop()
        viewModel.playGameOverMusic()
        gameOverImage.image = UIImage(named: "GameOverEgg")
        scene.alpha = viewModel.gameEndAlpha
    }
    
    func beginGame() {
        setGameScene()
        
        // prevent planting of flags until the first tile has been tapped and the mines layed
        addFlagButton.isEnabled = false
        scene.firstTap = true
        scene.isUserInteractionEnabled = true
        resetValues()
        scene.setBlankTileSprites()
        
    }
    
    private func resetValues() {
        viewModel.resetFlags()
        plantingFlag = false
        scene.plantingFlag = plantingFlag
    }
    
    private func layMines(_ safeIndex: Int? = nil) {
        addFlagButton.isEnabled = true
        let newTiles = viewModel.layMines(safeIndex)
        scene.addSprites(for: newTiles)
    }
    
    @IBAction func tryAgainPressed(_ sender: Any) {
        tryAgainButton.isHidden = true
        addFlagButton.isHidden = false
        gameOverImage.isHidden = true
        viewModel.playBackgroundMusic()
    
        scene.alpha = 1
        beginGame()
    }
    
    @IBAction func addFlagPressed(_ sender: UIButton) {
        if sender.isEnabled {
            plantingFlag.toggle()
            scene.plantingFlag = plantingFlag
        }
    }
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @IBAction func didTapSoundImageView(_ sender: UITapGestureRecognizer) {
        viewModel.playMusic.toggle()
        soundImage.image = viewModel.soundImage
    }
    
    @IBAction func tapGameOverImage(_ sender: Any) {
        gameOverImage.isHidden = true
    }
    
    
    
    @IBAction func tapExitImage(_ sender: Any) {
        exitButton.alpha = 0.7
        self.navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
