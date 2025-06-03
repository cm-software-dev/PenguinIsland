//
//  SettingsViewModel.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 28/05/2025.
//

import Foundation

class SettingsViewModel {
    
    var fxVolume: Float = 0.0
    
    var musicVolume: Float = 0.0
    
    var eggs: Int = 15 {
        didSet {
            eggsWereUpdated?(eggs)
        }
    }
    
    let minEggs: Float = 5.0
    let maxEggs: Float = 35.0
    
    let maxVolume: Float = 1.0
    
    var eggsWereUpdated: ((Int) -> Void)?
    
    init() {
        fxVolume = UserDefaults.standard.float(forKey: SettingsKeys.fxVolume.rawValue)
        musicVolume = UserDefaults.standard.float(forKey: SettingsKeys.musicVolume.rawValue)
        let eggsFromDefaults = UserDefaults.standard.integer(forKey: SettingsKeys.eggs.rawValue)
        eggs = eggsFromDefaults >= Int(minEggs) ? eggsFromDefaults : 15
    }
    
    func updateEggs(_ eggsFloat: Float) {
        eggs = Int(eggsFloat)
    }
    
    func saveChanges() {
        if musicVolume <= maxVolume {
            UserDefaults.standard.set(musicVolume, forKey: SettingsKeys.musicVolume.rawValue)
        }
        
        if fxVolume <= maxVolume {
            UserDefaults.standard.set(fxVolume, forKey: SettingsKeys.fxVolume.rawValue)
        }
        
        if eggs <= Int(maxEggs) && eggs >= Int(minEggs) {
            UserDefaults.standard.set(eggs, forKey: SettingsKeys.eggs.rawValue)
        }
    }
}


enum SettingsKeys: String {
    case musicVolume = "musicVolume"
    case fxVolume = "fxVolume"
    case eggs = "eggs"
    case muted = "muted"
}
