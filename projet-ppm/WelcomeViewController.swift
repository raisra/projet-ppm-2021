//
//  ViewController.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import UIKit

class WelcomeViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.isModalInPresentation = true
 
        self.view = WelcomeView(frame: UIScreen.main.bounds)
       
    }

    
    
    
    @objc func startGame() {
        
        print("Start Game")
       
        
       // self.navigationController?.pushViewController(GameViewController(), animated: true)
        
        
        
        let svc : UISplitViewController
        if #available(iOS 14.0, *) {
             svc = UISplitViewController(style: .doubleColumn)
        } else {
             svc = UISplitViewController()
        }
        let mvc = MessageViewController()
        let gvc = GameViewController(mvc: mvc)
        
        
       
        svc.preferredDisplayMode = .secondaryOnly
        
        svc.viewControllers = [ mvc, gvc]
        if #available(iOS 14.0, *) {
            svc.hide(.secondary)
        } else {
            // Fallback on earlier versions
        }
        svc.delegate = gvc
        svc.modalTransitionStyle = .flipHorizontal
        svc.modalPresentationStyle = .fullScreen
        self.present(svc, animated: true, completion: nil)
        
        //self.view = GameView(frame: UIScreen.main.bounds)
    }

}

