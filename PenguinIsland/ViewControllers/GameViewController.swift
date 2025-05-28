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
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        tryAgainButton.isHidden = true
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        
        scene.level = viewModel.level
        
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
            viewModel.gameOver()
            scene.gameOver()
            showGameOver()
        }
        viewModel.checkVictory()
    }
    
    func handleFlagToggled(tile: Tile) {
        viewModel.handleFlagToggled(tile: tile)
    }
    
    
    private func showVictory() {
        backgroundMusic?.stop()
        gameOverImage.image = UIImage(named: "VictoryWindowEgg")
        gameOverImage.isHidden = false
        scene.isUserInteractionEnabled = false
        tryAgainButton.isHidden = false
        addFlagButton.isHidden = true
        scene.alpha = viewModel.gameEndAlpha
        //do something
    }
    
    private func showGameOver() {
        scene.isUserInteractionEnabled = false
        tryAgainButton.isHidden = false
        gameOverImage.isHidden = false
        addFlagButton.isHidden = true
        backgroundMusic?.stop()
        gameOverImage.image = UIImage(named: "GameOverEgg")
        scene.alpha = viewModel.gameEndAlpha
    }
    
    func beginGame() {
        scene.isUserInteractionEnabled = true
        resetValues()
        layMines()
    }
    
    private func resetValues() {
        viewModel.resetFlags()
        plantingFlag = false
        scene.plantingFlag = plantingFlag
    }
    
    private func layMines() {
        let newTiles = viewModel.layMines()
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
        
        scene.level = viewModel.getNewLevel()
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
