//
//  GameOverView.swift
//  projet-ppm
//
//  Created by jihane on 30/01/2021.
//

import Foundation

import Foundation
import UIKit


class PauseViewController: UIViewController {

    @IBOutlet weak var mainMenuButton: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var scoreView: UIView!
    

    var  gameViewController : GameViewController?
    
 

    @IBAction func mainMenuSelector(_ sender: Any) {
        
        let alert = UIAlertController(title: "Voulez vous revenir au menu principal?", message: "Votre partie sera perdue", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Oui", style: .default, handler:{ action in
            self.dismiss(animated: false, completion: nil)
            self.gameViewController?.reset()
            self.gameViewController!.dismiss(animated: false, completion: nil)
        }))
            
       
        
        self.present(alert, animated: true)
    }
    
    
    @IBAction func resumeSelector(_ sender: Any) {
        //revenir au jeu
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restartSelector(_ sender: Any) {
        //revenir au jeu et faire un reset
        
        dismiss(animated: true, completion: {
            self.gameViewController!.reset()
            self.gameViewController!.startTheGame()})
    }
    
  
    func showResumeButton(){
        resumeButton.isHidden = false
    }

    func hideResumeButton(){
        resumeButton.isHidden = true
    }
    
}

