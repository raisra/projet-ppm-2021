//
//  GameViewController.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit


class GameViewController : UIViewController{
    
    // var mvc : MessageViewController
    
    var timer : Timer?
    var incTime = TimeInterval(0.05)
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
        print("start the game")
        //pauseGame()
        gv?.pauseButton.isHidden = true
        gv?.personnage?.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: incTime, target: self.view, selector: #selector(GameView.updateView), userInfo: nil, repeats: true)
        
        gv?.startAnimation()
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
        
        let a = self.navigationController?.navigationBar.isHidden=true
        print("view did load game")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        animationForNumber(imageName: 1, callback: startGame )
        print("view did appear game")
    }
    
    
    func blurrGameView()  {
        blurView.isHidden = false
    }
    
    func unblurrGameView()  {
        blurView.isHidden = true
    }
    
    
    func pauseGame() {
        gv?.stopAnimation()
        gv?.pauseButton.isHidden = false
        timer?.invalidate()
        timer=nil
    }
    
    func showPauseButton(){
        gv?.pauseButton.isHidden = false
    }
    
    

  
    
    //display the message view
    @objc func seeMessage(){
        
        print("click on message button")
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            self.splitViewController?.preferredDisplayMode = .oneBesideSecondary
        } else {
            self.splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
   
}
