//
//  ViewController.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import UIKit

class WelcomeViewController: UIViewController{

    var nvc: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.isModalInPresentation = true
        self.view = WelcomeView(frame: UIScreen.main.bounds)
    }

    
    
    init(nextViewController: UIViewController) {
        self.nvc = nextViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func startGame() {
        
        print("Start Game")
       // self.navigationController?.pushViewController(GameViewController(), animated: true)
        self.present(nvc  as! UISplitViewController, animated: true, completion: nil)
        
        //self.view = GameView(frame: UIScreen.main.bounds)
    }

}

