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
      
        gv?.hidePauseButton()
        timer = Timer.scheduledTimer(timeInterval: incTime, target: self.view, selector: #selector(GameView.updateView), userInfo: nil, repeats: true)
    }
   
    
    func animationForNumber(imageName: Int, callback: @escaping ()->Void) {
        
        if(imageName>3){
            print("start the game")
            callback()
            return
        }
        
        
        let counterView: UIImageView = gv!.counterView
        

        let h = UIScreen.main.bounds.height
        let w = UIScreen.main.bounds.width
        
        
        counterView.image = UIImage(named: String(imageName))
        counterView.alpha = 1
        counterView.frame.origin = CGPoint(x: w/2-50, y: h/2-50)
        counterView.frame.size = CGSize(width: 100, height: 100)
        
        
        UIView.animate(withDuration: 1,
                       animations: {
                        print("animation \(imageName)")
                        let   a = counterView.frame
                        
                        counterView.alpha = 0
                        counterView.frame.origin = CGPoint(x: w/2-10, y: h/2-10)
                        counterView.frame.size = CGSize(width: 20, height: 20)
                       
                       }, completion: {(true) in
                        
                        self.animationForNumber(imageName: imageName + 1, callback: callback)

                       })
        
    }
    

    
    
    override func viewDidLoad() {
        
        view = GameView(frame: UIScreen.main.bounds)
        gv = self.view as! GameView
        
        view.addSubview(blurView)
        blurView.isHidden=true
        
        print("view did load")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        animationForNumber(imageName: 1, callback: startGame )
        print("view did appear")
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
