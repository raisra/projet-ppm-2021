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
    var speed = TimeInterval(2)
    var gv : GameView!
    
    let blurView : UIVisualEffectView = {
        let a = UIVisualEffectView(effect: UIBlurEffect(style:.dark) )
        a.frame = UIScreen.main.bounds
        return a
    }()
    
    
    let N : Int = 100
    
    var gameIsStoped : Bool = true
    var modelRoad : ModelRoad?
    
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    
    let sk = 0.3 * UIScreen.main.bounds.height
    let rh = 0.7 * UIScreen.main.bounds.height
    
    var thePosition :(Int, Int) = (0,0)
    var size : CGSize = CGSize(width: 100, height: 100)
    
    //tableau contenant les pieces affiché sur l'ecran
    var coins: Set<UIImageView> = Set<UIImageView>()
    
    override func viewDidLoad() {
        
        let r : CGFloat = 0.3
        let rh = r * UIScreen.main.bounds.height
        modelRoad = ModelRoad(N: N, W: w, i0: w/3.0, i3: 3.0*w/4.0 , H: rh, bSize: 10.0, fSize: 50.0)
        view = GameView(frame: UIScreen.main.bounds, r: r)
        
        
        gv = self.view as? GameView
        thePosition = (1, N-10)
        
        gv.initPersonnage(position: (modelRoad?.getCenter(i: thePosition.0, j: thePosition.1))!, size : size)
        gv.setSpeed(speed: speed)
        view.addSubview(blurView)
        blurView.isHidden=true
        
        
        
        
        
        print("view did load game")
        
        self.navigationController?.navigationItem.backBarButtonItem?.image = UIImage(named: "message")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear game")
    }
    
    
    
    func startGame(isFirstStart: Bool ){
        print("start the game")
        
        self.gv?.startButton.isHidden = true
        
        
        let cb : ()->() = {
            //pauseGame()
            
            self.gv?.pauseButton.isHidden = false
            self.gv?.personnage.isHidden = false
            self.gv?.messageButton.isHidden = false
            self.timer = Timer.scheduledTimer(timeInterval: self.speed/50.0, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: true)
            
            self.gv?.startAnimation()
            
        }
        if(isFirstStart) {
            animationForNumber(imageName: 1, callback: cb)
        }
        else{
            cb()
        }
        
        gameIsStoped = false
    }
    
    
    func animationForNumber(imageName: Int, callback: @escaping ()->Void) {
        
        if(imageName>3){
            print("start the game from callback")
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
                        
                        counterView.alpha = 0
                        counterView.frame.origin = CGPoint(x: w/2-100, y: h/2-100)
                        counterView.frame.size = CGSize(width: 200, height: 200)
                        
                       }, completion: {(true) in
                        
                        self.animationForNumber(imageName: imageName + 1, callback: callback)
                        
                       })
    }
    
    
    
    
    func blurrGameView()  {
        blurView.isHidden = false
    }
    
    func unblurrGameView()  {
        blurView.isHidden = true
    }
    
    
    @objc func pauseGame() {
        if(!gameIsStoped){
            gv?.stopAnimation()
            timer?.invalidate()
            timer=nil
            gameIsStoped = true
            gv?.viewHandlingCoins.isHidden = true
        }
        else {
            //restart the game
            startGame(isFirstStart: false)
            gameIsStoped = false
            gv?.viewHandlingCoins.isHidden = false
        }
        
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
    
    @objc func startGameForTheFistTime(){
        startGame(isFirstStart: true)
    }
    
    
    var c = 10000
    @objc func updateView() {
        
        // print("update view")
        c += 1
        if(c>10){
            createCoin()
            c=0
        }
        
        modelRoad?.movedown(completion: { (coin) in
            coins.insert(coin as! UIImageView)
        })
       
        let r = modelRoad?.removeCoin(i: thePosition.0, j: thePosition.1-5)
        if (r != nil) {
            gv.score += 1
            gv.scoreLabel.text = String(gv.score)
            
            moveCoinToCorner(r!, point: gv.scoreLabel.center)
        }
    }
    
    
    func moveCoinToCorner(_ coin : UIImageView, point : CGPoint){
        let a = coin.frame
        UIView.animate(withDuration: 2, delay: 0, options: .transitionCurlUp) {
            coin.frame.origin = point
            coin.frame.size.height = coin.frame.size.height/3.0
            coin.frame.size.width = coin.frame.size.width/3.0
            //coin.alpha = 0
        } completion: { (true) in
            //erase the coin
            //coin.stopAnimating()
            let s = String(UInt(bitPattern: ObjectIdentifier(coin)))
           // print("move to the corner finished \(s)")
            coin.isHidden = true
            self.coins.insert(coin)
        }
    }
    
    
    /**
     Ajoute une piece aleatoirement dans le tableau des pieces
     */
    var d = 0
    func createCoin(){
        let a = random()
        
        for (i,k) in [(0,a.0), (1,a.1), (2,a.2)] {
            if(k){
                var newCoin : UIImageView
                if(coins.isEmpty){
                    c += 1
                    newCoin = UIImageView()
                    newCoin.image = UIImage(named: "coin-1")
                    gv.viewHandlingCoins.addSubview(newCoin)
                    
                    let s = String(UInt(bitPattern: ObjectIdentifier(newCoin)))
                    print("\t\t------------create new coin \(s) \(d)--------------")
                    d += 1
                }
                else{
                    newCoin = coins.popFirst()!
                    newCoin.isHidden = false
                    let s = String(UInt(bitPattern: ObjectIdentifier(newCoin)))
                    print("\t\t\t\t\t\t-----------reuse  coin \(s) \(coins.count)------------")
                }

                gv.viewHandlingCoins.sendSubviewToBack(newCoin)
                modelRoad?.addImage(newCoin, type: .coin, i: i, j: 0)
  
                //gv.initAnimatedView(newCoin, "coin", speed: 0.2)
                // newCoin.startAnimating()
            }
        }
    }
    
    
    
    
    
    func random () -> (Bool,Bool,Bool){
        
        var ret : (Bool, Bool, Bool)
        
        ret.0=Bool.random()
        ret.1=Bool.random()
        ret.2=Bool.random()
        return ret
        
    }
}
