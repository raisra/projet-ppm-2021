//
//  GameViewController.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit


class GameViewController : UIViewController, UISplitViewControllerDelegate {
    
    // var mvc : MessageViewController
    
    var timer : Timer?
    var incTime = TimeInterval(0.1)
    var gv : GameView?
    
    let blurView : UIVisualEffectView = {
        let a = UIVisualEffectView(effect: UIBlurEffect(style:.dark) )
        a.frame = UIScreen.main.bounds
        return a
    }()
    
    
    //    init(mvc: MessageViewController) {
    //        self.mvc = mvc
    //        super.init(nibName: nil, bundle: nil)
    //
    //    }
    
    
    
    
    
    @objc func startGame(){
        pauseGame()
        let gv = self.view as! GameView
        gv.hidePauseButton()
        timer = Timer.scheduledTimer(timeInterval: incTime, target: self.view, selector: #selector(GameView.updateView), userInfo: nil, repeats: true)
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        view = GameView(frame: UIScreen.main.bounds)
        gv = self.view as! GameView
        
        view.addSubview(blurView)
        blurView.isHidden=true
        
        startGame()
    }
    
    
    func blurrGameView()  {
        blurView.isHidden = false
    }
    
    func unblurrGameView()  {
        blurView.isHidden = true
    }
    
    
    func pauseGame() {
        
        gv?.showPauseButton()
        timer?.invalidate()
        timer=nil
        
    }
    
    func showPauseButton(){
        gv?.showPauseButton()
    }
}
