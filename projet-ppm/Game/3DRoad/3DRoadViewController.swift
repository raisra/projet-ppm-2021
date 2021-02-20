//
//  3DRoadViewController.swift
//  projet-ppm
//
//  Created by ramzi on 22/01/2021.
//

import Foundation
import UIKit






class ThreeDRoadViewController : UIViewController , CAAnimationDelegate{
 
    var names : [TypeOfObject: String]
    var duration : TimeInterval
    //var size : CGSize
   
    
    var nbElements : Int
    var level :  Level
    
    var model3D : ThreeDRoadModel
    //la vue à afficher. C'est un tableau contenant les portion de route à afficher
    
    var N : Int
    
    //créé la vue associée à l'element en parametre
    var buffer : [(UIImageView, TypeOfObject)] = []
    
    var goingToTurn = false
    var stopCoins = false

    init(names : [TypeOfObject: String] , duration : TimeInterval, model3D : ThreeDRoadModel, N: Int) {
        //le nombre dd'ilages à empiler
        self.N = N
        self.names = names
        self.duration = duration
        
        level = SettingsViewController.sharedInstance.getLevel()
        nbElements = 0
        
        self.model3D = model3D
        
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.main.bounds
    }

  
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    func setDuration(_ d : TimeInterval){
        duration = d
    }
    
    func getName(accordingTo : TypeOfObject ) -> String{
        return names[accordingTo]!
    }
    
    func getImages(_ ofType : TypeOfObject){
        let name = getName(accordingTo : ofType )
        if let image = UIImage(named: "\(name)") {
            buffer.append( (UIImageView(image:image), ofType) )
        }
        
        var i = 1
        
        while let image = UIImage(named: "\(name)-\(i)") {
            buffer.append( (UIImageView(image:image), ofType) )
            i += 1
        }
    }
    

    /*
     genere 4 vue de type straight
     ajouter les à la vue principale
     commencer les animations
     */
    func initRoads(){
        model3D.deleteAllRoad()
        for _ in 0..<N {
            _ = createRoad(withType: STRAIGHT, level: level)
          //  ThreeDRoadModel.startAnimation(elem: road)
        }
    }
    
 
    
    func stopGeneratingCoins()-> Bool{
        return stopCoins
    }
   
    
    //get called by the timer every duration
    func createRoad(withType : TypeOfObject? = nil, level : Level) -> Frame?{

        var t : TypeOfObject? = withType
        
        if !goingToTurn  {
            //on genere un nouvel element si on ne va pas tourner
            if withType == nil {
                t = model3D.generateElement(level: level)
                
                if t == TURNLEFT || t == TURN_RIGHT {
                    print("------------lutilisateur va tourner")
                    goingToTurn = true
                    stopCoins = true
                }
            }
            //ici on remplie le buffer
            getImages(t!)
        }
        
        if buffer.isEmpty { return nil }
        //on vide le buffer
        let (view, type) = buffer[0]
        let frame = model3D.append(im: view, type: type)
        
        if frame != nil {
            view.contentMode = .scaleAspectFit
            view.frame = frame!.frame!
            self.view.addSubview(view)
            self.view.sendSubviewToBack(view)
          
            buffer.removeFirst()
        }
        
       return frame
    }
    
 
    func turn (level: Level) {
        model3D.deleteAllRoad()
        buffer.removeAll()
        
        goingToTurn = false
        stopCoins = false
        
        for _ in 1...5 {
            let road = createRoad(withType: STRAIGHT, level: level)
            ThreeDRoadModel.startAnimation(elem: road)
        }
        
        for _ in 1...N {
            let road = createRoad(level: level)
            ThreeDRoadModel.startAnimation(elem: road)
        }
    }
     
}





