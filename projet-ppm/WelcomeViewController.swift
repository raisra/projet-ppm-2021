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
        let gameView = GameView()
        
       // self.navigationController?.pushViewController(GameViewController(), animated: true)
        self.isModalInPresentation = true
        self.modalTransitionStyle = .crossDissolve
        self.present(GameViewController(), animated: false, completion: nil)
    }

}

