//
//  ViewController.swift
//  projet-ppm
//
//  Description : lancement du jeu et choix du niveau (vitesse du jeu)
//

import UIKit




var  settingView : SettingsView?

let mvcNavVC : UINavigationController = {
    let chatVC = ChatViewController()
    chatVC.title = "Messagerie"
    
    var nv = UINavigationController(rootViewController: chatVC)
    nv.modalTransitionStyle = .flipHorizontal
    nv.modalPresentationStyle = .fullScreen
    
    return nv
}()


class WelcomeViewController: UIViewController{
    
    static let sharedInstance = WelcomeViewController()
    var welcomeView : WelcomeView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      //  self.isModalInPresentation = true
       // self.view = WelcomeView(frame: UIScreen.main.bounds)
        
        //welcomeView = WelcomeView(frame : UIScreen.main.bounds)
        settingView = SettingsView(frame : UIScreen.main.bounds)
        
       // self.view.addSubview(welcomeView!)
        self.view.addSubview(settingView!)
        settingView!.isHidden = true
    }
    
    
    
    @IBAction  func startGame() {
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
    
    
    @IBAction  func settingsButtonSelector() {
        print( "trying" )
        settingView?.isHidden = false
        welcomeView?.isHidden = true
        gOvView.isHidden = true
        view.bringSubviewToFront(settingView!)
    }
    
    
    
    @IBAction  func scoreButtonSelector () {
        let scoreController = ScoreViewController.sharedInstance
        scoreController.modalTransitionStyle = .coverVertical
        scoreController.modalPresentationStyle = .fullScreen
        self.present(scoreController, animated: true, completion: nil)
    }
    
    
    
@IBAction func chatButtonSelector() {
        self.present(mvcNavVC, animated: true, completion: nil)
    }
        
    
    
}
