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
    
    
    
    @IBAction func mainMenuSelector(_ sender: Any) {
        present(WelcomeViewController.sharedInstance, animated: true, completion: nil)
    }
    
    
    @IBAction func resumeSelector(_ sender: Any) {
        present(GameViewController.sharedInstance, animated: true, completion: nil)
    }
    
    @IBAction func restartSelector(_ sender: Any) {
        present(GameViewController.sharedInstance, animated: true, completion: nil)
    }
    
    @IBOutlet weak var scoreView: UIView!
    
    
    
    
    let GameOver = UIImageView()
    
    let h = UIScreen.main.bounds.height
    let w = UIScreen.main.bounds.width
    
    
    var  pauseViewController : PauseViewController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        let storyboard = UIStoryboard(name: "PauseViewController", bundle: nil)
        pauseViewController = storyboard.instantiateViewController(withIdentifier: "PauseViewController") as!PauseViewController
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    override func viewDidLoad() {
        
        
        addChild(pauseViewController!)
        
       // view.addSubview(pauseViewController!.view)
        pauseViewController!.didMove(toParent: self)
    }
    
    required init?(coder: NSCoder) {   
        super.init(coder: coder)
      
    }
    
  
    

    
}

