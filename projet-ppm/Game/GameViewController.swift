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
    
    /**
     plus speed est grand plus le jeu est lent
     */
    var periodClock = TimeInterval(0.1)
    let ttlMagnet : TimeInterval = 20.0
    
    
    var gv : GameView
    var hv : HumanInterface
    var modelRoad : ModelRoad
    
    let N : Int = 100
    
    var gameIsStoped : Bool = true
    
    
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    
    let sk = 0 * UIScreen.main.bounds.height
    let rh = 1 * UIScreen.main.bounds.height
    
    //the position of the character on the screen grid
    var thePosition :(Int, Int) = (0,0)
    
    //the size of the uiview representing the character
    var size : CGSize = CGSize(width: 100, height: 100)
    
    //set of coins
    var coins: Set<UIImageView> = Set<UIImageView>()
    

    
    init() {
        
        let r : CGFloat = 1
        
        
        //init du model
        modelRoad = ModelRoad(nRows: N, nColumns: 3, W: 1000, i0: 320, i3: 480 , H: 800, bSize: 10.0, fSize: 50.0, useData: false)
        
        //init du character
        thePosition = (1, N-10)
        let posOfCharacter = modelRoad.getCenter(i: thePosition.0, j: thePosition.1)
        
        //init des vues
        gv = GameView(frame: UIScreen.main.bounds, s: periodClock*10, position: posOfCharacter , size: size)
        hv = HumanInterface(frame: UIScreen.main.bounds)
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(gv)
        view.addSubview(hv)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func startGame() {
        print("start the game")
        
        gv.showCharacter()
        gv.startAnimation()
        
        hv.pauseButton.isHidden = true
        hv.messageButton.isHidden = false
        hv.startButton.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval:  periodClock, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: true)
        
        gameIsStoped = false
    }
    
    
    @objc func pauseGame() {
        if(!gameIsStoped){
            gv.stopAnimation()
            timer?.invalidate()
            timer=nil
            gameIsStoped = true
            //gv.viewHandlingCoins.isHidden = true
            hv.pauseButton.isHidden = false
        }
        else {
            //restart the game
            startGame()
            gameIsStoped = false
            hv.pauseButton.isHidden = true
            gv.objectsView.isHidden = false
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
    
    
    
    
    
    /**
     genere aleatoirement un objet qur le parcours
     */
    var d = 0
    func createObject(){
        //on commence par générer un objet grace au model
        let a = modelRoad.generateNewObject(level: 0)
        
        for colonne in 0..<modelRoad.nColumns {
            //le type de l'objet créé
            let type : TypeOfObject = a[colonne]
            var newObject : UIImageView?
            var animated : Bool? = false
            var name: String? //the name of the file cointaining the object to draw
            
            switch type {
            case .coin:
                //le model a créé une piece
                animated = true
                name = "coin"
                if(coins.isEmpty){
                    c += 1
                    newObject = UIImageView()
                    //let s = String(UInt(bitPattern: ObjectIdentifier(newCoin)))
                    // print("\t\t------------create new coin \(s) \(d)--------------")
                    d += 1
                }
                else{
                    newObject = coins.popFirst()!
                    
                    //let s = String(UInt(bitPattern: ObjectIdentifier(newCoin)))
                    //print("\t\t\t\t\t\t-----------reuse  coin \(s) \(coins.count)------------")
                }
                break
                
            case .magnet :
                //le model a créé un aimant
                animated = false
                name = "magnet"
                newObject = UIImageView()
                break
                
            case .coinx2 :
                //le model a créé une piece+2
                animated = true
                name = "coin-x2"
                newObject = UIImageView()
                break
                
            case .coinx5 :
                //le model a créé une piece+2
                animated = true
                name = "coin-x5"
                newObject = UIImageView()
                break
                
            case .any : continue
            case .empty: continue
            default: continue
            }
            
            //le nouvel objet est initialisée avec l'image qui lui correspond
            newObject!.isHidden = false
            gv.initView(newObject!, name!, speed: 1, animated: animated!)
            gv.objectsView.addSubview(newObject!)
            //l'objet est mis en arriere plan
            gv.objectsView.sendSubviewToBack(newObject!)
            //l'objet est ajouté au model
            modelRoad.addObj(newObject!, type: type, i: colonne, j: 0)
        }
    }
    
    //compte le nombre d'objets créés
    var c = 0
    
    //dictionnaire contenant le Time to live de chaque pouvoir qui a été enclenché
    var TTL: [(TypeOfObject, TimeInterval)] = [(TypeOfObject, TimeInterval)]()
    
    /**
        cette fonction créé  un objet
            vérifie si des pouvoirs sont en cours d'execution et met à jour leur timers respectifs
     */
    @objc func updateView() {
        
        print("hello")
        // print("hello from timer")
        // print("update view")
        c += 1
        if((c%5)==0){
            //on crée un object tous les n appels pour limiter leurs nombres
            createObject()
        }
        
        //vérifie s'il y a des pouvoirs en cours d'execution
        //met à jour le timer
        handlePower()
        
        
        //ameliorer ce code
        //TODO
        modelRoad.movedown()
        
        
        //tentative de suppression de l'objet situé devant le personnage
        //suppression de l'objet située 1 cases devant
        let obj : (type: TypeOfObject, view: UIImageView?) = modelRoad.removeObject(i: thePosition.0, j: thePosition.1-1, type: .any)
        
        //si aucun n'objet n'est devant le personnage rien à faire
        if (obj == (TypeOfObject.empty, nil)){ return}
        
        
        //les coordonnées du point vers lesquels renvoyer les pieces
        var p : CGPoint?
        //callback a executer qd le personnage rencontre un object
        var cb : ((Bool) -> ())?
        
        switch obj.type {
        
        case .coin:
            //le personnage attrape une piece
            hv.addScore(1)
            p = hv.scoreLabel.center
            cb = {(Bool) in  obj.view?.isHidden = true }
            break
            
        case .coinx2:
            //le personnage attrape une piece double
            hv.addScore(2)
            p = hv.scoreLabel.center
            cb = {(Bool) in  obj.view?.isHidden = true }
            break
        
        case .coinx5:
            hv.addScore(5)
            p = hv.scoreLabel.center
            cb = {(Bool) in  obj.view?.isHidden = true }
            break
        //TODO FACTORISER LE CODE PRECEDENT
        
        case .barrier:
            
            break
            
        case .magnet:
        //le personnage attrape un aimant
            //l'icone de l'aimant est déplacée au point de coordonnées p
            p = hv.powerAnchor
            print("aimant s'en enclenché \(ttlMagnet)")
            
            //a la fin de l'animation, ajout de l'icone du pouvoir à l'emplacement réservé dans HumanInterface
            cb = {(Bool) in
                //declenchement du timer pendant 10s
                self.TTL.append((TypeOfObject.magnet, self.ttlMagnet))
                self.hv.addPower(powerView: obj.view!, duration: self.ttlMagnet)
                print("add the power now")
            }
            
            break
            
            
        default:
            break
        }
        
        //deplacement de l'objet si les coordonnées p sont non nuls
        moveObjToPoint(obj.view!, point: p, withDuration: 1, options: .transitionCurlUp, cb : cb)
    }
    
    
    
    var aa = 0
    func handlePower(){

        //si un aucun poucoir n'est en cours d'execution on ne fait rien
        if(TTL.isEmpty) {return}
        
        var i = 0
        while i<TTL.count  {
            let (power, ttl) = TTL.first!
            //si le pouvoir a fini de s'executer
            if ttl <= 0 {
                print("le pouvoir \(TypeOfObject.power.rawValue) est terminé")
                //un pouvoir est enclenché
                TTL.remove(at: 0)
                aa = 0
                continue
            }

            let timeToLive = ttl - periodClock
            TTL[0].1 = timeToLive
             aa += 1
            //executer le pouvoir
            print("TTT: \(timeToLive) \(aa)")
            switch power {
            
            case .magnet:
                //attirer les pieces situé dans le voisinage
                //on commence par retirer les pieces concernées du chemin
                
                //TODO corriger cela car si le tableau de ModelData contient moins de 10 lignes
                //il y aura une seg fault
                //Utilisez colonne
                for i in 0..<modelRoad.nColumns {
                    for neighborhood in 1 ... 20 {
                        //on tente de retirer les pieces situées dans le voisinage du personnage
                        let coin = modelRoad.removeObject(i: i, j: thePosition.1 - neighborhood, type: .coin).view
                        
                        //si on trouve une piece
                        if coin != nil {
                            //on deplace la piece vers le personnage
                            moveObjToPoint(coin!,
                                           point: gv.character.center,
                                           withDuration: 1,
                                           options: .curveEaseIn,
                                           cb : {_ in
                                            coin!.isHidden = true
                                            self.coins.insert(coin!)
                                           }
                            )

                            //TODO faire un mouvement plus naturel
                            //Peut etre animation suivant une courbe de bezier
                        }
                    }
                }
                break
                
            case .transparency:
                //le personnage devient mi-transparent
                //il devient capable de traverser les obstacles
                gv.character.alpha = 0.5
                break
                
            default:
                print("handlePower : ne devrait jamais safficher")
            }
            
            i += 1
        }
        
    }
    



    /**
    deplacement de l'image obj vers le point de coordonnées point.
     */
    func moveObjToPoint(_ obj : UIImageView, point : CGPoint?, withDuration duration: TimeInterval, options: UIView.AnimationOptions = [] , cb : ((Bool) ->())?){
        
        if(point == nil) {return}
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            obj.frame.origin = point!
            //obj.frame.size.height = obj.frame.size.height/3.0
            //obj.frame.size.width = obj.frame.size.width/3.0
        }, completion: cb)
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
            self.gv.character.center.y -= 100
        }
        
        let completion : (Bool) ->() = {(_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowAnimatedContent, .curveEaseIn] ,
                           animations : {
                            self.thePosition.0 = initPosition
                            self.gv.character.center.y += 100
                           }
                           ,  completion: nil)
            
            
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowAnimatedContent , .curveEaseOut ],
                       animations: upAnimation, completion: completion)
        
    }
    
    
    
    @objc func movePersonnage(sender : UIButton) {
        
        if( sender == hv.droite){
            print("move to right")
            moveToTheRight()
            let s = modelRoad.getCenter(i: thePosition.0, j: thePosition.1)
            gv.character.center = s
        }
        else if sender == hv.gauche {
            print("move to the left")
            moveToTheLeft()
            let s = modelRoad.getCenter(i: thePosition.0, j: thePosition.1)
            gv.character.center = s
        }
        
        else if sender == hv.saute{
            print("move up")
            moveUp()
        }
        
        else if sender == hv.baisse{
            print("move down")
            
        }
        else if sender == hv.accelerate{
            print("accelerate")
            
        }
    }
    
    
    
}
