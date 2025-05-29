//
//  HomeViewController.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 28/05/2025.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var playButton: UIImageView!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func playButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showGame", sender: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentSettings", sender: self)
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentInfo", sender: self)
    }
    
    private func presentSettingsViewController() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .overCurrentContext
        self.present(settingsVC, animated: true)
    }
}
