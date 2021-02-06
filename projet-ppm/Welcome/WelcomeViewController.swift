//
//  ViewController.swift
//  projet-ppm
//
//  Description : lancement du jeu et choix du niveau (vitesse du jeu)
//

import UIKit

let sView = SettingsView(frame : UIScreen.main.bounds)
let wView = WelcomeView(frame : UIScreen.main.bounds)
let chatViewController = ChatViewController()

class WelcomeViewController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      //  self.isModalInPresentation = true
       // self.view = WelcomeView(frame: UIScreen.main.bounds)
        
        self.view.addSubview(wView)
        self.view.addSubview(sView)
        sView.isHidden = true
    }
    
    
    
    @objc func startGame() {
        print("Start Game")
        let gvc = GameViewController()
        gvc.modalTransitionStyle = .flipHorizontal
        gvc.modalPresentationStyle = .fullScreen
        self.present(gvc , animated: true, completion: nil)
        gOvView.isHidden = true

    }
    
    
    
    @objc func RestartGame() {
        print("ReStart Game")
        let gvc = GameViewController()
        gvc.modalTransitionStyle = .flipHorizontal
        gvc.modalPresentationStyle = .fullScreen
        self.present(gvc , animated: true, completion: nil)
        gOvView.isHidden = true
    }
    
    
    @objc func settingsButtonSelector() {
        print( "trying" )
        sView.isHidden = false
        wView.isHidden = true
        gOvView.isHidden = true
        view.bringSubviewToFront(sView)
    }
    
    
    
    @objc func scoreButtonSelector () {
        let scoreController = ScoreViewController()
        scoreController.modalTransitionStyle = .coverVertical
        scoreController.modalPresentationStyle = .fullScreen
        self.present(scoreController, animated: true, completion: nil)
    }
    
    
    

    @objc func chatButtonSelector() {
        chatViewController.modalPresentationStyle = .fullScreen
        self.present(chatViewController, animated: true, completion: nil)
    }
        
    
    
}
