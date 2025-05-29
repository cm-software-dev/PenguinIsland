//
//  InfoViewControlller.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 29/05/2025.
//
import UIKit
import Foundation

class InfoViewController: UIViewController {
    
    @IBOutlet weak var infoTitleLabel: UILabel!
    
    @IBOutlet weak var infoParagraphOneLabel: UILabel!
    
    @IBOutlet weak var infoParagraphTwoLabel: UILabel!
    
    
    @IBOutlet weak var infoParagraphThreeLabel: UILabel!
    
    override func viewDidLoad() {
        infoTitleLabel.text = "Info"
        
        infoParagraphOneLabel.text = "Welcome to Penguin Island! The penguins want to get to the other side but someone has hidden all of their eggs."
        
        infoParagraphTwoLabel.text = "Help them find their eggs but be careful not to break any! Tap on tiles to reveal the number of nearby eggs and plant flags to mark where you think they are."
        
        infoParagraphThreeLabel.text = "You win if you can correctly mark where all the eggs are with flags or if the remaining undisturbed tiles contain only eggs."
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
