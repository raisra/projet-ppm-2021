//
//  ViewController.swift
//  projet-ppm
//
//  Description : lancement du jeu et choix du niveau (vitesse du jeu)
//

import UIKit

let settingView = SettingsView(frame : UIScreen.main.bounds)
let welcomView = WelcomeView(frame : UIScreen.main.bounds)


class WelcomeViewController: UIViewController{
    
    static let sharedInstance = WelcomeViewController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      //  self.isModalInPresentation = true
       // self.view = WelcomeView(frame: UIScreen.main.bounds)
        
        self.view.addSubview(welcomView)
        self.view.addSubview(settingView)
        settingView.isHidden = true
    }
    
    
    
    @objc func startGame() {
        print("Start Game")
        let gvc = GameViewController.sharedInstance
        gvc.modalTransitionStyle = .flipHorizontal
        gvc.modalPresentationStyle = .fullScreen
        self.present(gvc , animated: true, completion: nil)
        gOvView.isHidden = true

    }
    
    
    
    @objc func RestartGame() {
        print("ReStart Game")
        let gvc = GameViewController.sharedInstance
        gvc.modalTransitionStyle = .flipHorizontal
        gvc.modalPresentationStyle = .fullScreen
        self.present(gvc , animated: true, completion: nil)
        gOvView.isHidden = true
    }
    
    
    @objc func settingsButtonSelector() {
        print( "trying" )
        settingView.isHidden = false
        welcomView.isHidden = true
        gOvView.isHidden = true
        view.bringSubviewToFront(settingView)
    }
    
    
    
    @objc func scoreButtonSelector () {
        let scoreController = ScoreViewController.sharedInstance
        scoreController.modalTransitionStyle = .coverVertical
        scoreController.modalPresentationStyle = .fullScreen
        self.present(scoreController, animated: true, completion: nil)
    }
    
    
    

    @objc func chatButtonSelector() {
        ChatViewController.sharedInstance.modalPresentationStyle = .fullScreen
        self.present(ChatViewController.sharedInstance, animated: true, completion: nil)
    }
        
    
    
}
