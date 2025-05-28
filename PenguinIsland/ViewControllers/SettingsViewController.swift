//
//  SettingsViewControler.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 28/05/2025.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var musicVolumeSlider: UISlider!
    
    @IBOutlet weak var fxVolumeSlider: UISlider!
    
    @IBOutlet weak var eggSlider: UISlider!
    
    @IBOutlet weak var eggCounter: UILabel!
    
    
    private let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.eggsWereUpdated = updateEggCounterLabel(eggs:)
        
        fxVolumeSlider.value = viewModel.fxVolume
        musicVolumeSlider.value = viewModel.musicVolume
        eggSlider.minimumValue = viewModel.minEggs
        eggSlider.maximumValue = viewModel.maxEggs
        eggSlider.value = Float(viewModel.eggs)
        
        eggCounter.text = "\(viewModel.eggs)"
    }
    
    private func updateEggCounterLabel(eggs: Int) {
        eggCounter.text = "\(eggs)"
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //save the changes
        viewModel.saveChanges()
    }
    
    @IBAction func musicVolumeChanged(_ sender: UISlider) {
        viewModel.musicVolume = sender.value
        
    }
    
    @IBAction func fxVolumeChanged(_ sender: UISlider) {
        viewModel.fxVolume = sender.value
    }
    
    @IBAction func eggsValueChanged(_ sender: UISlider) {
        viewModel.updateEggs(sender.value)
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
}


