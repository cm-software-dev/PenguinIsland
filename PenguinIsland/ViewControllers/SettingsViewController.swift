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
    
    @IBOutlet weak var largeButton: UIButton!
    
    @IBOutlet weak var mediumButton: UIButton!
    
    @IBOutlet weak var smallButton: UIButton!
    
    private let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.eggsWereUpdated = updateEggCounterLabel(eggs:)
        
        fxVolumeSlider.value = viewModel.fxVolume
        musicVolumeSlider.value = viewModel.musicVolume
        setEggSliderRanges()
        eggSlider.value = Float(viewModel.eggs)
        
        eggCounter.text = "\(viewModel.eggs)"
        
        largeButton.isHidden = viewModel.sizeButtonsAreHidden
        mediumButton.isHidden = viewModel.sizeButtonsAreHidden
        smallButton.isHidden = viewModel.sizeButtonsAreHidden
        
        determineSelectedSizeButton()
        viewModel.eggRangesWereUpdated = setEggSliderRanges
    }
    
    private func setEggSliderRanges() {
        eggSlider.minimumValue = viewModel.minEggs
        eggSlider.maximumValue = viewModel.maxEggs
    }
    
    private func determineSelectedSizeButton() {
        switch viewModel.gameSize {
        case .ipadSmall:
            smallButton.isSelected = true
        case .ipadMedium:
            mediumButton.isSelected = true
        case .ipadLarge:
            largeButton.isSelected = true
        case .iphoneDefault:
            return
        }
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
    
    
    @IBAction func largeButtonTapped(_ sender: UIButton) {
        largeButton.isSelected.toggle()
        if largeButton.isSelected {
            mediumButton.isSelected = false
            smallButton.isSelected = false
        }
        viewModel.setGameSizeSet(.ipadLarge)
        setEggSliderValue(viewModel.eggs)
    }
    
    @IBAction func mediumButtonPressed(_ sender: Any) {
        mediumButton.isSelected.toggle()
        if mediumButton.isSelected {
            largeButton.isSelected = false
            smallButton.isSelected = false
        }
        viewModel.setGameSizeSet(.ipadMedium)
        setEggSliderValue(viewModel.eggs)
    }
    
    
    @IBAction func smallButtonPressed(_ sender: Any) {
        smallButton.isSelected.toggle()
        if smallButton.isSelected {
            mediumButton.isSelected = false
            largeButton.isSelected = false
        }
        viewModel.setGameSizeSet(.ipadSmall)
        setEggSliderValue(viewModel.eggs)
    }
    
    private func setEggSliderValue(_ eggs: Int) {
        eggSlider.value = Float(eggs)
    }
}


