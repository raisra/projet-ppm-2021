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
       
        let gvc = GameViewController()
    
        gvc.modalTransitionStyle = .flipHorizontal
        gvc.modalPresentationStyle = .fullScreen
        
        self.present(gvc , animated: true, completion: nil)
    }

}

