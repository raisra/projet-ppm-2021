//
//  GameViewController.swift
//  projet-ppm
//
//  Description : 
//

import Foundation
import UIKit


let gOvView = GameOverView(frame : UIScreen.main.bounds)




//var sizeIm = CGSize(width: 400, height: 60)
//let alpha : CGFloat = 75.96
//let factor : CGFloat = 0.925



var SoundOnOff : Bool = true

class GameViewController : UIViewController, GestureManagerProtocol {
    
    
    static let sharedInstance = GameViewController();
    // var mvc : MessageViewController
    /*let mvc = { () -> MessageViewController in
        let mvc = MessageViewController()
        
        mvc.modalTransitionStyle = .flipHorizontal
        mvc.modalPresentationStyle = .fullScreen
        
        return mvc
    }()*/
    var mvcNavVC: UINavigationController?
    
    var timer : Timer?
    var gv : GameView!
    var userInterfaceView : UserInterfaceView!
    var modelRoad : ThreeDRoadModel!
    var threeDRoadVC : ThreeDRoadViewController!
    
    var gameIsStoped : Bool = true
    
    //the position of the character on the screen grid
    var thePosition :(Int, Int) = (0,0)
    
    
//    //set of coins
//    var coins: Set<UIImageView> = Set<UIImageView>()
    
    let backGround : UIImageView = UIImageView()
    
    
    lazy var soundManager = SoundManager()
    

    var gestureManager : GestureManager?
   
    
  //  var motionManager : MotionManager?
    
    
    var duration : TimeInterval?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        print ("the Game view did load")
        LevelDuration()
        //init du model 3D
        
        
        
        
        //le paraemetre à metter dans Model
        print( sizeIm.height)
        
        
        let D : CGFloat = sizeIm.width * pow(factor, NB_ROWS)
        
        
        let param : ModelRoad.Param = ModelRoad.Param(nRows: Int(NB_ROWS),
                                                      nColumns: Int(NB_COLUMNS),
                                                      W: UIScreen.main.bounds.width,
                                                      
                                                      D: D,
                                                      bSize: 5, fSize:50,
                                                      useData: false,
                                                      size0: sizeIm,
                                                      factor: factor, duration: duration!)
        
        //init du model
        //besoin de alpha et de la taille de la premiere image
        
        
        
        modelRoad = ThreeDRoadModel(param)
        
        //initialise la position du persinnage au mileu de l'ecran
        thePosition = ((Int)(NB_COLUMNS/2) , Int(NB_ROWS - INITIAL_CHAR_POSITION))
        
        let posOfCharacter = modelRoad.getCenter(i: thePosition.0, j: thePosition.1 )
        
        
        gv = GameView(frame: UIScreen.main.bounds, s: duration!, centerBottom: posOfCharacter , sizeOfChar: sizeChar)
        userInterfaceView = UserInterfaceView()


       
        threeDRoadVC = ThreeDRoadViewController(names: NAMES,
                                                duration: duration!,
                                                model3D: modelRoad,
                                                N: Int(NB_ROWS))
        
        addChild(threeDRoadVC)
        threeDRoadVC.didMove(toParent: self)
        
        backGround.frame = UIScreen.main.bounds
        GameView.initView(backGround, BACK_GROUND_IMAGE)
        
        view.addSubview(backGround)
        view.addSubview(threeDRoadVC.view)
        view.addSubview(gv)
        view.addSubview(userInterfaceView)
        view.addSubview(gOvView)


        SoundOnOff = settingView.soundON()
        
       
        gestureManager = GestureManager(forView: self.userInterfaceView)
        gestureManager?.delegate = self
        
       // motionManager = MotionManager()
//        motionManager?.delegate = self
//        motionManager?.start()
        
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //init des vues
        //init du character
        userInterfaceView.animationForNumber(imageName: 1) {
            self.threeDRoadVC.startTheGame()
            self.startTheGame()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        super.viewWillDisappear(animated)
        
      //  self.gestureManager?.removeGesture(from: self.gv)
      //  self.motionManager?.stop()
      //  self.motionManager?.stop()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    
    func startTheGame() {
        print("start the game")
        
        gameIsStoped = false;
        soundManager.playGameSound()
        
        gv.startTheGame();
        userInterfaceView.startTheGame();
      
        gOvView.isHidden = true
        timer = Timer.scheduledTimer(timeInterval:  duration!, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: true)
    }
    
     func startTheGame(sender: UIButton){
       startTheGame()
    }
    

         
    @objc func stoptheGame() {
        
            gameIsStoped = true;
            soundManager.stopGameSound()
            
            gv.stopTheGame();
            userInterfaceView.stopTheGame();
            
            
            timer?.invalidate()
            timer = nil
    }
    
    
    
    //display the message view
    @objc func readMessage(){
       
        present(mvcNavVC!, animated: true, completion: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("gae vew will deseapper")
        stoptheGame()
    }
    
    /**
     genere aleatoirement un objet qur le parcours
     */
    func createObject(){
        //on commence par générer un objet grace au model
        let a = modelRoad.generateNewObject(level: 0)
        
        for colonne in 0..<modelRoad.iMax {
            //le type de l'objet créé
            let type : TypeOfObject = a[colonne]
            var newObject : UIImageView?
            var animated : Bool? = false
            var name: String? //the name of the file cointaining the object to draw
            
            switch type {
            case _COIN_:
                //le model a créé une piece
                animated = COINS_ARE_ANIMATED
                name = "coin"
                newObject = UIImageView()
                break
                
            case magnet :
                //le model a créé un aimant
                animated = false
                name = "magnet"
                newObject = UIImageView()
                break
                
            case coinx2 :
                //le model a créé une piece+2
                animated = COINS_ARE_ANIMATED
                name = "coin-x2"
                newObject = UIImageView()
                break
                
            case coinx5 :
                //le model a créé une piece+2
                animated = COINS_ARE_ANIMATED
                name = "coin-x5"
                newObject = UIImageView()
                break
                
            case any : continue
            case _EMPTY_: continue
            default: continue
            }
            
            //le nouvel objet est initialisée avec l'image qui lui correspond
            newObject!.isHidden = false
            GameView.initView(newObject!, name!, speed: 1, animated: animated!)
            gv.objectsView.addSubview(newObject!)
            //l'objet est mis en arriere plan
            gv.objectsView.sendSubviewToBack(newObject!)
            //l'objet est ajouté au model
            let f = modelRoad.addObj(newObject!, type: type, i: colonne + modelRoad.iMin , j: 0)
            modelRoad.initAnimation(elem: f)
            modelRoad.startAnimation(elem: f)
        }
    }
    
    
    
    //dictionnaire contenant le Time to live de chaque pouvoir qui a été enclenché
    var TTL: [(TypeOfObject, TimeInterval)] = [(TypeOfObject, TimeInterval)]()
    
    /**
     cette fonction créé  un objet
     vérifie si des pouvoirs sont en cours d'execution et met à jour leur timers respectifs
     */
    var nbOfTurn : Int = 0
    var level : Level = .Beginner
    
    
    let MALUS_DURATION :TimeInterval = 2.0
    var malus : Bool = false //indique si le personnage s'est cogné
    
    var timerJump : TimeInterval = 0.0
    var timerBlink: TimeInterval = 0.0
    
    @objc func updateView() {

        //on véerifie si le personnage a sauté
        if wantToJump {
            timerJump -= duration!
            if timerJump < 0 {
                print("End jumping")
                timerJump = 0.0
                wantToJump = false
                gv.animationForRunning()
            }
        }
        
        if malus {
            timerBlink -= duration!
            if timerBlink < 0 {
                print("End Blink")
                timerBlink = 0.0
                malus = false
            }
        }
        
        
        //on vérifie sur quel type de route se trouve le personnage
        let t = modelRoad.getElemAtIndex(Int(INITIAL_CHAR_POSITION))?.type
        if (t == TURNLEFT && !wantToTurnLeft) || (t == TURN_RIGHT && !wantToTurnRight) {
            //le joueur a perdu
                print("l'utilisateur va perdre")
            
                if (SoundOnOff){
                    soundManager.playEndSound()
                }
                //TODO ICI AFFICHER LE SCORE
                startTheGame()
                print("The Game is becoming Harder")
            
                //arreter l'a imation du personnage
                //TODO RELA?CER LE JEU
                //effacer toutes les pieces et pouvoir etc
                //relancer le timer
                //remettre la duration des controller à la valeur initiale
            
                //stopGenerating coins à false
              
                return
        }
        
        
        if( t == TREE && !wantToJump && malus ){
            //le personnage s'est cogné deux fois d'affiler
            print("on a perdu")
            
            stoptheGame()
            return
        }
        
        if (t == TURNLEFT && wantToTurnLeft) || (t == TURN_RIGHT && wantToTurnRight){
            
                nbOfTurn += 1
                
                //level = Level(rawValue: Int(nbOfTurn/10)) ?? .Hard
                typeOfLevel()
                print("The Game is becoming Harder")
                threeDRoadVC.turn(level: level)
                wantToTurnLeft = false
                wantToTurnRight = false
                
                //on invalide le timer et on en rreceer un autre plus rapide
                self.timer?.invalidate()
                duration = duration! * 0.95
                threeDRoadVC.setDuration(duration!)
                
                self.timer =  Timer.scheduledTimer(timeInterval:  duration!, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: true)
            
                return
            }
        
        
        if( t == TREE && !wantToJump) {
            print("Le personnage se cogne sur un arbre")
            if (SoundOnOff){
                soundManager.playCollisionSound()
            }
            
            malus = true
            gv.animateBlink()
            timerBlink = BLINK_DURATION
        }
 
        
        
        let lastElemType = modelRoad.getLastElem()?.type
        if !threeDRoadVC.stopGeneratingCoins() && (lastElemType == STRAIGHT || lastElemType == BRIDGE){
            print("create object over \(lastElemType)")
            createObject()
        }
        
        modelRoad.movedown()
        
        threeDRoadVC.createRoad(level: level)
      
        //vérifie s'il y a des pouvoirs en cours d'execution
        //met à jour le timer
        handlePower()
        
        
        //tentative de suppression de l'objet situé devant le personnage
        //suppression de l'objet située 1 cases devant
        let obj : (type: TypeOfObject, view: UIImageView?)
        obj = modelRoad.removeObject(i: thePosition.0, j: thePosition.1  - 1 , type: any)
        
        //si aucun n'objet n'est devant le personnage rien à faire
        if (obj == (_EMPTY_, nil)){
            return
        }
        else {
            
        }
        
        //les coordonnées du point vers lesquels renvoyer les pieces
        var p : CGPoint?
        //callback a executer qd le personnage rencontre un object
        var cb : ((Bool) -> ())?
        
        switch obj.type {
        
        case _COIN_:
            //le personnage attrape une piece
            if (SoundOnOff){
                soundManager.playCollisionSound()
            }
            userInterfaceView.addScore(1)
            p = userInterfaceView.scoreLabel.center
            cb = {(Bool) in  obj.view?.isHidden = true }
            break
            
        case coinx2:
            //le personnage attrape une piece double
            userInterfaceView.addScore(2)
            p = userInterfaceView.scoreLabel.center
            cb = {(Bool) in  obj.view?.isHidden = true }
            break
            
        case coinx5:
            userInterfaceView.addScore(5)
            p = userInterfaceView.scoreLabel.center
            cb = {(Bool) in  obj.view?.isHidden = true }
            break
        //TODO FACTORISER LE CODE PRECEDENT
        
        
        
        case magnet:
            //le personnage attrape un aimant
            //l'icone de l'aimant est déplacée au point de coordonnées p
            p = userInterfaceView.powerAnchor
            print("aimant s'en enclenché \(TTL_POWER)")
            
            //a la fin de l'animation, ajout de l'icone du pouvoir à l'emplacement réservé dans HumanInterface
            cb = {(Bool) in
                //declenchement du timer pendant 10s
                self.TTL.append((magnet, TTL_POWER))
                self.userInterfaceView.addPower(powerView: obj.view!, duration: TTL_POWER)
                print("add the power now")
            }
            
            break
            
            
        default:
            break
        }
        
        //deplacement de l'objet si les coordonnées p sont non nuls
        moveObjToPoint(obj.view!, point: p, withDuration: 1, options: .transitionCurlUp, cb : cb)
        
        wantToTurnLeft = false
        wantToTurnRight = false
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
                print("le pouvoir \(power) est terminé")
                //un pouvoir est enclenché
                TTL.remove(at: 0)
                aa = 0
                continue
            }
            
            let timeToLive = ttl - duration!
            TTL[0].1 = timeToLive
            aa += 1
            
            switch power {
            
            case magnet:
                //attirer les pieces situé dans le voisinage
                //on commence par retirer les pieces concernées du chemin
                

                for i in 0..<modelRoad.nColumns {
                    for neighborhood in 1 ... DISTANCE_OF_MAGNET {
                        //on tente de retirer les pieces situées dans le voisinage du personnage
                        let coin = modelRoad.removeObject(i: i, j: thePosition.1 - neighborhood, type: _COIN_).view
                        
                        //si on trouve une piece
                        if coin != nil {
                            //on deplace la piece vers le personnage
                            moveObjToPoint(coin!,
                                           point: gv.character.center,
                                           withDuration: 1,
                                           options: .curveEaseIn,
                                           cb : {_ in
                                            coin!.isHidden = true
                                            //self.coins.insert(coin!)
                                           }
                            )
                            
                            //TODO faire un mouvement plus naturel
                            //Peut etre animation suivant une courbe de bezier
                        }
                    }
                }
                break
                
            case transparency:
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
    func moveObjToPoint(_ obj : UIImageView, point : CGPoint?, withDuration duration: TimeInterval = DURATION, options: UIView.AnimationOptions = [] , cb : ((Bool) ->())?){
        
        if(point == nil) {return}
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            obj.frame.origin = point!
            //obj.frame.size.height = obj.frame.size.height/3.0
            //obj.frame.size.width = obj.frame.size.width/3.0
        }, completion: cb)
    }
    
   
    

   
    
    func LevelDuration(){
        print("VALEUR IS" + settingView.value)
        switch  settingView.value {
        case "Beginner" :
            duration = 0.6
        case "Medium" :
            duration = 0.4
        case "Hard" :
            duration = 0.3
        case "Extreme" :
            duration = 0.2
        default :
            duration = 0.6
        }

     }
    
    func typeOfLevel(){
        switch  settingView.value {
        case "Beginner" :
            level = .Beginner
        case "Medium" :
            level = .Medium
        case "Hard" :
            level = .Hard
        case "Extreme" :
            level = .Extreme
        default :
            level = .Beginner
        }
    }
    
    
    
    
    
    
    
    
    
    
    /*****************************************/
    /**
            LES MOUVEMENTS
     
     */

    
    
    var wantToTurnLeft : Bool = false
    var wantToTurnRight  : Bool = false
    var wantToJump : Bool = false
    
    func moveUp () {
        if !wantToJump {
            timerJump = JUMP_DURATION
            wantToJump = true
            if (SoundOnOff){
                soundManager.playEdgeSound()
            }
            gv.animationForJump()
        }
    }
    
    func tapeTwice() {
        //Pouvoir : devenir invisible pendant 3 secondes
        //power_transparence()
        gv.animationForTransparency()
    }
    
    func longTape() {
        print("accelerating")
        self.gv.setSpeed(speed: 0.2)
    }

    
    func moveRight(){
        thePosition.0 = min(modelRoad.iMax , thePosition.0 + 1)
        let s = modelRoad.getCenter(i: thePosition.0, j: thePosition.1)

        gv.setCharPosition(s)
        print("hello from move right")
        wantToTurnRight = true
    }
    
    func moveLeft (){
        thePosition.0 = max(modelRoad.iMin, thePosition.0 - 1)
        let s = modelRoad.getCenter(i: thePosition.0, j: thePosition.1)
        gv.setCharPosition(s)
        print("hello from move left")
        wantToTurnLeft = true
    }

    
    func moveDown() {
        
    }
    
    
    // Enregistre un SCORE
    func saveScore(score : Int) {
        let currentDate = Date()
        let name = PreferenceManager.sharedInstance.loadStringPreference(for: PreferenceKeys.name)!
        let scoreDataObject = ScoreObject(score: score, date: currentDate, name: name)
        let pref = PreferenceManager.sharedInstance
        pref.savePreference(score: scoreDataObject, for: PreferenceKeys.score)
    }
    
    
    func gameOver() {
            gv.stopAnimation()
            timer?.invalidate()
            timer=nil
            gameIsStoped = true
           
            modelRoad.reset()
            soundManager.stopGameSound()
            userInterfaceView.resetPower()
     
            //effacer toutes les pieces et pouvoir etc
            //relancer le timer
            //remettre la duration des controller à la valeur initiale
        
            
            wantToTurnLeft = false
            wantToTurnRight = false
            wantToJump = false
            
            threeDRoadVC.goingToTurn = false
            threeDRoadVC.stopCoins = false
                
                
            self.timer?.invalidate()
            duration = DURATION
            threeDRoadVC.setDuration(duration!)
            
            //scoreViewController.reference(int: hv.getScore(), for key:"scores")
            thePosition = ((modelRoad.iMax + modelRoad.iMin)/2 , Int(NB_ROWS - INITIAL_CHAR_POSITION))
            
            let posOfCharacter = modelRoad.getCenter(i: thePosition.0, j: thePosition.1)
            
            gv.hideCharacter()
            
           // viewWillAppear(true)
            //scoreViewController.modalTransitionStyle = .coverVertical
           // scoreViewController.isModalInPresentation = true
           // self.present(score, animated: true, completion: nil)
            
        
        //soundManager.playGameOverSound()
        gOvView.isHidden = false
        view.bringSubviewToFront(gOvView)
        }
    
    
}
