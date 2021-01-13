//
//  GameViewController.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit


class GameViewController : UIViewController {
    
    
    override func viewDidLoad() {
        self.modalTransitionStyle = .crossDissolve
        view = GameView(frame: UIScreen.main.bounds)
        
    }
    
    
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
