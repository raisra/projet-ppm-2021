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
    let mvc = { () -> MessageViewController in
        let mvc = MessageViewController()
       
        mvc.modalTransitionStyle = .flipHorizontal
        mvc.modalPresentationStyle = .fullScreen
        
        return mvc
    }()
    
    var timer : Timer?
    var speed = TimeInterval(2)
    var gv : GameView!
    
    
    let N : Int = 100
    
    var gameIsStoped : Bool = true
    var modelRoad : ModelRoad?
    
     let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    
    let sk = 0 * UIScreen.main.bounds.height
    let rh = 1 * UIScreen.main.bounds.height
    
    var thePosition :(Int, Int) = (0,0)
    var size : CGSize = CGSize(width: 100, height: 100)
    
    //tableau contenant les pieces affiché sur l'ecran
    var coins: Set<UIImageView> = Set<UIImageView>()
    

    let droite = setButton(title: ">>>>", posx: UIScreen.main.bounds.width-100, posy: 50)
    let gauche = setButton(title: "<<<<", posx: 10, posy: 50)
    
    
    let saute = setButton(title: "Sauter", posx: UIScreen.main.bounds.width/2, posy: 300)
    let baisse = setButton(title: "BAisser", posx: UIScreen.main.bounds.width/2, posy: 400)
    
    let accelerate = setButton(title: "x10", posx: 400, posy: 600)
    
    override func viewDidLoad() {
        
        let r : CGFloat = 1
        let rh = r * UIScreen.main.bounds.height
        modelRoad = ModelRoad(N: N, W: w, i0: w/4.0, i3: 3.0*w/4.0 , H: 278, bSize: 10.0, fSize: 50.0) //remplacer 278 par rh
        view = GameView(frame: UIScreen.main.bounds, r: r)
        
        
        gv = self.view as? GameView
        thePosition = (1, N-1)
        
        gv.initPersonnage(position: (modelRoad?.getCenter(i: thePosition.0, j: thePosition.1))!, size : size)
        gv.setSpeed(speed: speed)
       
        
        droite.addTarget(self, action: #selector(movePersonnage(sender:)), for: .touchUpInside)
        gauche.addTarget(self, action: #selector(movePersonnage(sender:)), for: .touchUpInside)
        saute.addTarget(self, action: #selector(movePersonnage(sender:)), for: .touchUpInside)
        baisse.addTarget(self, action: #selector(movePersonnage(sender:)), for: .touchUpInside)
        accelerate.addTarget(self, action: #selector(movePersonnage(sender:)), for: .touchUpInside)
       
        
        gv.addSubview(gauche)
        gv.addSubview(droite)
        gv.addSubview(baisse)
        gv.addSubview(saute)
        gv.addSubview(accelerate)
        
        
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
            
            self.gv?.pauseButton.isHidden = true
            self.gv?.personnage.isHidden = false
            self.gv?.messageButton.isHidden = false
            self.timer = Timer.scheduledTimer(timeInterval: self.speed/50.0, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: true)
            
            self.startAnimation()
            
        }
        if(isFirstStart) {
            animationForNumber(imageName: 1, callback: cb)
        }
        else{
            cb()
        }
        
        gameIsStoped = false
    }
    
    
    
    func startAnimation(){
        
//        UIView.animate(withDuration: 50, delay: 0, options: [.repeat , .curveLinear]) {
//            self.cloud1.frame.origin = CGPoint(x: -50, y: 40)
//        } completion: {_ in }
//
//
//        UIView.animate(withDuration: 100, delay: 0, options: [.repeat , .curveLinear]) {
//            self.cloud2.frame.origin = CGPoint(x: -50, y: 40)
//        } completion: {_ in }
//
//        UIView.animate(withDuration: 300, delay: 0, options: [.repeat , .curveLinear]) {
//            self.cloud3.frame.origin = CGPoint(x: -50, y: 40)
//        } completion: {_ in }
//
//
      

        gv.personnage.startAnimating()
        gv.roadImage.startAnimating()
        
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
    
    
    @objc func pauseGame() {
        if(!gameIsStoped){
            gv?.stopAnimation()
            timer?.invalidate()
            timer=nil
            gameIsStoped = true
            //gv?.viewHandlingCoins.isHidden = true
            gv?.pauseButton.isHidden = false
        }
        else {
            //restart the game
            startGame(isFirstStart: false)
            gameIsStoped = false
            gv?.pauseButton.isHidden = true
            gv?.viewHandlingCoins.isHidden = false
        }
    }
 

    
    //display the message view
    @objc func seeMessage(){
        print("click on message button")
        present(mvc, animated: true, completion: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("gae vew will deseapper")
        pauseGame()
    }
    
    
    @objc func startGameForTheFistTime(){
        startGame(isFirstStart: true)
    }
    
    
    //indique si une timer est déclenché pour un pouvoir
    var startTimer : Bool = false
    var timeToLive : Double = 0.0 //enclenche le pouvoir pendant 10s
    var power : TypeOfObject = .empty
    
    
    
    var c = 0
    @objc func updateView() {
        
       // print("hello from timer")
        // print("update view")
        c += 1
        if((c%10)==0){
            //on crée un object tous les dix appels pour limiter leurs nombres
            createObject()
        }
        
        //vérifie s'il y a des pouvoirs en cours d'execution
        //met à jour le timer
        handlePower()
        
        
        //ameliorer ce code
        //TODO
        modelRoad?.movedown(completion: { (coin) in
            coins.insert(coin as! UIImageView)
        })
       
        let obj : (type: TypeOfObject, view: UIImageView?) = (modelRoad?.removeObject(i: thePosition.0, j: thePosition.1-5, type: .any))!
        
        if (obj == (TypeOfObject.empty, nil)){ return}
        
        switch obj.type {
        
        case .coin:
            gv.score += 1
            gv.scoreLabel.text = String(gv.score)
            
            moveCoinToPoint(obj.view!, point: gv.scoreLabel.center)
            break
            
        case .barrier:
            
            break
            
        case .coinx2:
            gv.setScore(score: gv.getScore()*2)
            //TODO emetttre un son special
            break
            
        case .coinx5:
            gv.setScore(score: gv.getScore()*5)
            break
            
        case .magnet:
            startTimer =  true
            //TODO mettre TTT en parametre
            //cmprendre le rapport avec la frequence de declenchement timer
            timeToLive = 200
            power = .magnet
            print("aimant s'en enclenché")
            obj.view?.isHidden = true
            
            //TODO
            //ici on a caché le l'image du booster mais il faudrait l'afficher dans un petit rectangle
            //en haut avec un timer qui affiche le temps restant
            break
            
            
        default:
            break
        }
            
        
    }
    
    func handlePower(){
    
        if(startTimer == false) {return}
        
        if(timeToLive <= 0){
            print("le pouvoir est terminé")
            //un pouvoir est enclenché
            timeToLive = 0
            startTimer = false
            power = .empty
            
            
        }
        else {
            timeToLive -= speed
            //executer le pouvoir
            print("TTT: \(timeToLive)")
            switch power {
                case .magnet:
                    //attirer les pieces à la ronde
                    //on commence par retirer les pieces concernées du chemin
                    
                    //TODO corriger cela car si le tableau de ModelData contient moins de 10 lignes
                    //il y aura une seg fault
                    //Utilisez colonne
                    for i in 0 ... 2 {
                        for neighborhood in 1 ... 20 {
                            let coin = modelRoad?.removeObject(i: i, j: thePosition.1 - neighborhood, type: .coin).view
                            if coin != nil {
                                moveCoinToPoint(coin!, point: gv.personnage.center)
                            }
                        }
                    }
                    break
                    
                case .transparency:
                    
                    break
                
            default:
                print("handlePower : ne devrait jamais safficher")
            }
        }
    }
    
    
    
    /**
     Ajoute une piece aleatoirement dans le tableau des pieces
     */
    var d = 0
    func createObject(){
        let a = modelRoad!.generateNewObject(level: 0)
        
        //TODO
        //prendre en compte le nombre de colonne
        for colonne in 0...2 {
            let type : TypeOfObject = a[colonne]
            
            switch type {
                case .coin:
                    var newCoin : UIImageView
                    
                        if(coins.isEmpty){
                            c += 1
                            newCoin = UIImageView()
                            newCoin.image = UIImage(named: "coin-1")
                            gv.viewHandlingCoins.addSubview(newCoin)
                            
                            //let s = String(UInt(bitPattern: ObjectIdentifier(newCoin)))
                           // print("\t\t------------create new coin \(s) \(d)--------------")
                            d += 1
                        }
                        else{
                            newCoin = coins.popFirst()!
                            newCoin.isHidden = false
                            //let s = String(UInt(bitPattern: ObjectIdentifier(newCoin)))
                            //print("\t\t\t\t\t\t-----------reuse  coin \(s) \(coins.count)------------")
                        }

                    gv.initAnimatedView(newCoin, "coin", speed: 1)
                    newCoin.startAnimating()
                    gv.viewHandlingCoins.sendSubviewToBack(newCoin)
                    modelRoad?.addImage(newCoin, type: type, i: colonne, j: 0)
                    break
                        
                case .magnet :
                    let magnet = UIImageView(image: UIImage(named: "magnet"))
                    gv.viewHandlingCoins.addSubview(magnet)
                    modelRoad?.addImage(magnet, type: type, i: colonne, j: 0)
                    break
                    
            case .any :
                    break
                    
                default: break
            }

        }
    }
    
    
    func moveCoinToPoint(_ coin : UIImageView, point : CGPoint){
        
        UIView.animate(withDuration: 1, delay: 0, options: .transitionCurlUp) {
            coin.frame.origin = point
            coin.frame.size.height = coin.frame.size.height/3.0
            coin.frame.size.width = coin.frame.size.width/3.0
            //coin.alpha = 0
        } completion: { (true) in
            //erase the coin
            //coin.stopAnimating()
            //let s = String(UInt(bitPattern: ObjectIdentifier(coin)))
           // print("move to the corner finished \(s)")
            coin.isHidden = true
            self.coins.insert(coin)
        }
    }
    
    
  
    
    /**
        bouton pour simuler le deplacement du personnage
     */
    
    static func setButton(title: String, posx: CGFloat, posy : CGFloat) -> UIButton {
        let b = UIButton()
        b.frame = CGRect(x: posx, y: posy, width: 50, height: 50)
        b.setTitle(title, for: .normal)
        b.setTitleColor(.black, for: .normal)
        
        return b
    }
    
    
    func moveToTheRight()  {
        thePosition.0 = min(2 , thePosition.0 + 1)
        
    }
    
    func moveToTheLeft()  {
        thePosition.0 = max(0, thePosition.0 - 1)
    }
    
    func moveUp() {
        
        let initPosition = thePosition.0
        thePosition.0 = 42
        
        let upAnimation : () ->() = {
            self.gv.personnage.center.y -= 100
        }
        
        let completion : (Bool) ->() = {(_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowAnimatedContent, .curveEaseIn] ,
            animations : {
                self.thePosition.0 = initPosition
                self.gv.personnage.center.y += 100
            }
            ,  completion: nil)

            
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowAnimatedContent , .curveEaseOut ],
                       animations: upAnimation, completion: completion)
        
    }
       
    
    
    @objc func movePersonnage(sender : UIButton) {
        
        if( sender == droite){
            print("move to right")
            moveToTheRight()
            let s = modelRoad?.getCenter(i: thePosition.0, j: thePosition.1)
            gv.personnage.center = s!
        }
        else if sender == gauche {
            print("move to the left")
            moveToTheLeft()
            let s = modelRoad?.getCenter(i: thePosition.0, j: thePosition.1)
            gv.personnage.center = s!
        }
        
        else if sender == saute{
            print("move up")
            moveUp()
        }
        
        else if sender == baisse{
            print("move down")
            
        }
        else if sender == accelerate{
            print("accelerate")
           
        }
    }
    
    
    
}
