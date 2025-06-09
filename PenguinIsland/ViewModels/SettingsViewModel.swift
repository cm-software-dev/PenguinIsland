//
//  SettingsViewModel.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 28/05/2025.
//

import Foundation
import UIKit

class SettingsViewModel {
    
    var fxVolume: Float = 0.0
    
    var musicVolume: Float = 0.0
    
    var eggs: Int = 15 {
        didSet {
            eggsWereUpdated?(eggs)
        }
    }
    
    var minEggs: Float = 0.0
    var maxEggs: Float = 0.0 {
        didSet {
            eggRangesWereUpdated?()
        }
    }
    
    let maxVolume: Float = 1.0
    
    var eggsWereUpdated: ((Int) -> Void)?
    
    var eggRangesWereUpdated: (() -> ())?
    
    let sizeButtonsAreHidden: Bool
    
    var gameSize: GameSize
    
    init() {
        fxVolume = UserDefaults.standard.float(forKey: SettingsKeys.fxVolume.rawValue)
        musicVolume = UserDefaults.standard.float(forKey: SettingsKeys.musicVolume.rawValue)
        let eggsFromDefaults = UserDefaults.standard.integer(forKey: SettingsKeys.eggs.rawValue)
        eggs = eggsFromDefaults >= Int(minEggs) ? eggsFromDefaults : 15
        sizeButtonsAreHidden =  UIDevice.current.model != "iPad"
        let gameSizeRawValue = UserDefaults.standard.integer(forKey: SettingsKeys.gameSize.rawValue)
        gameSize =  GameSize(rawValue: gameSizeRawValue) ?? .iphoneDefault
        self.setEggRangesForGameSize(gameSize)
    }
    
    private func setEggRangesForGameSize(_ gameSize: GameSize) {
        switch gameSize {
        case .ipadSmall:
            minEggs = 5.0
            maxEggs = 15.0
        case .ipadMedium:
            minEggs = 10.0
            maxEggs = 60.0
        case .ipadLarge:
            minEggs = 30.0
            maxEggs = 130.0
        case .iphoneDefault:
            minEggs = 5.0
            maxEggs = 35.0
        }
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
        
        UserDefaults.standard.set(gameSize.rawValue, forKey: SettingsKeys.gameSize.rawValue)
    }
    
    func setGameSizeSet(_ gameSize: GameSize) {
        self.gameSize = gameSize
        setEggRangesForGameSize(gameSize)
        setEggsForGameSize(gameSize)
    }
    
    private func setEggsForGameSize(_ gameSize: GameSize) {
        let difficultySettings = DifficultySettings(gameSize)
        eggs = difficultySettings.numMines
        eggsWereUpdated?(eggs)
    }
    
}


enum SettingsKeys: String {
    case musicVolume = "musicVolume"
    case fxVolume = "fxVolume"
    case eggs = "eggs"
    case muted = "muted"
    case gameSize = "gameSize"
    case numRows = "numRows"
    case numColumns = "numColumns"
}
