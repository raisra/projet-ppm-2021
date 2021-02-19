//
//  ViewController.swift
//  projet-ppm
//
//  Description : lancement du jeu et choix du niveau (vitesse du jeu)
//

import UIKit







//let mvcNavVC : UINavigationController = {
//  //  let chatVC = ChatViewController()
//   // chatVC.title = "Messagerie"
//    
//   // var nv = UINavigationController(rootViewController: chatVC)
//    nv.modalTransitionStyle = .flipHorizontal
//    nv.modalPresentationStyle = .fullScreen
//    
//    return nv
//}()


class WelcomeViewController: UIViewController{
    
    static let sharedInstance = WelcomeViewController()
    var welcomeView : WelcomeView?
    let svc = SettingsViewController.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction  func startGame() {
        print("Start Game")
        let gvc = GameViewController.sharedInstance
        gvc.modalTransitionStyle = .flipHorizontal
        gvc.modalPresentationStyle = .fullScreen
        self.present(gvc , animated: true, completion: {
            gvc.reset()
            gvc.startTheGame()
        })
       

    }
    
    

    
    
    @IBAction  func settingsButtonSelector() {
        svc.modalTransitionStyle = .flipHorizontal
        svc.modalPresentationStyle = .fullScreen
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            svc.modalPresentationStyle = .formSheet
        }
        self.present(svc, animated: true, completion: nil)
    }
    
    
    
    @IBAction  func scoreButtonSelector () {
        let scoreController = ScoreViewController()
        scoreController.modalTransitionStyle = .coverVertical
        scoreController.modalPresentationStyle = .fullScreen
        if UIDevice.current.userInterfaceIdiom == .pad {
            scoreController.modalPresentationStyle = .formSheet
        }
        scoreController.showCloseButton()
        self.present(scoreController, animated: true, completion: nil)
    }
    
    
    
@IBAction func chatButtonSelector() {
       // self.present(mvcNavVC, animated: true, completion: nil)
    }
        
    

    
}
