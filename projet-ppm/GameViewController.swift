//
//  GameViewController.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit


class GameViewController : UIViewController, UISplitViewControllerDelegate {
    
    var mvc : MessageViewController
    
    let blurView : UIVisualEffectView = {
        let a = UIVisualEffectView(effect: UIBlurEffect(style:.dark) )
        a.frame = UIScreen.main.bounds
        return a
    }()
    
    
    init(mvc: MessageViewController) {
        self.mvc = mvc
        super.init(nibName: nil, bundle: nil)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
       
        view.addSubview(GameView(frame: UIScreen.main.bounds))
        view.addSubview(blurView)
        blurView.isHidden=true
    }
    
    

    
    
}
