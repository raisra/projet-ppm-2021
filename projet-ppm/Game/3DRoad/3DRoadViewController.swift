//
//  3DRoadViewController.swift
//  projet-ppm
//
//  Created by ramzi on 22/01/2021.
//

import Foundation
import UIKit

enum Level: Int {
    case easy=0
    case average=1
    case hard=2
}






class ThreeDRoadViewController : UIViewController , CAAnimationDelegate{
 
    var names : [TypeOfElem: String]
    var duration : TimeInterval
    //var size : CGSize
   
    
    var nbElements : Int
    var level :  Level
    
    var model3D : ThreeDRoadModel
    //la vue à afficher. C'est un tableau contenant les portion de route à afficher
    var threeDView : [ThreeDRoadView]
    var N : Int

    init(names : [TypeOfElem: String] , duration : TimeInterval, model3D : ThreeDRoadModel, N: Int) {
        //le nombre dd'ilages à empiler
        self.N = N
        self.names = names
        self.duration = duration
        
        level = .easy
        nbElements = 0
        
        self.model3D = model3D
        
        //au depart la vue est vide
        threeDView = [ThreeDRoadView]()
     
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.main.bounds
    }

  
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    func getImageView(accordingTo : ThreeDElem ) -> UIImageView{
//        return threeDView[accordingTo]!
//    }
    
    func updateDuration(_ d : TimeInterval){
        duration = d
    }
    
    func getName(accordingTo : TypeOfElem ) -> String{
        return names[accordingTo]!
    }
    
    func getImages(_ ofType : TypeOfElem) -> [UIImage]{
        let name = getName(accordingTo : ofType )
        if let image = UIImage(named: "\(name)") {
            return [image]
        }
        
        var i = 1
        var images = [UIImage]()
        while let image = UIImage(named: "\(name)-\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    //créé la vue associée à l'element en parametre
    func appendView(withElem: ThreeDElem){
        //create the image view
        let type = withElem.type()
        let images = getImages(type)
        
        var elem = withElem
        for img in images {
            model3D.append(elem: elem)
            let v = ThreeDRoadView(elem:elem, im : img)
            
            //initialise les animations de la nouvelle vue
            //ses animations dependent de la position dans la pile de vue
            threeDView.append(v)
            self.view.addSubview(v)
            self.view.sendSubviewToBack(v)
            initAnimation(viewToAnimate: v)
            nbElements += 1
            
            elem = model3D.generateElementOfType(type)
        }
    }

    
    func removeFirstView() {
        if threeDView.isEmpty {
            print("Le personnage est sortie")
            return
        }
        let firstView = threeDView.removeFirst()
        
        
        for view in threeDView {
            //view.center = view.elem.center
            view.frame = view.elem.frame
            initAnimation(viewToAnimate: view)
        }
        
        firstView.removeFromSuperview()
        nbElements -= 1
    }
    
    /*
     genere 4 vue de type straight
     ajouter les à la vue principale
     commencer les animations
     */
    func startTheGame(){
        for _ in 1...N {
            //genere un element droit
            //se frame est calculée au prealable par le model pour que la vue
            //associée soit affiché au bon endroit
            let elem = model3D.generateElementStraight()
            
            
            //créé la vue et l'ajoute à la liste des elements geree par le controller
            //cette vue sera animée
            appendView(withElem: elem)
        }
    }
    
    
    
    func initAnimation(viewToAnimate: ThreeDRoadView) {
        let elem = viewToAnimate.elem
        
        let translate = CABasicAnimation(keyPath: "position.y")

        translate.fromValue = viewToAnimate.center.y
        translate.toValue = viewToAnimate.center.y + elem.yTranslate

        let scaleX = CABasicAnimation(keyPath: "transform.scale.x")
        scaleX.fromValue = 1
        scaleX.toValue = elem.scaleW

        let scaleY = CABasicAnimation(keyPath: "transform.scale.y")
        scaleY.fromValue = 1
        scaleY.toValue = elem.scaleH

        
        let transformGroup : CAAnimationGroup = CAAnimationGroup()

        transformGroup.duration = CFTimeInterval(viewToAnimate.elem.duration)
        transformGroup.repeatCount = 1
        transformGroup.autoreverses = false

       
        transformGroup.animations = [translate, scaleX, scaleY]
        
        if elem.index == nbElements-1 {
            let alpha = CABasicAnimation(keyPath: "opacity")
            alpha.fromValue = 0.5
            alpha.toValue = 1
            transformGroup.animations?.append(alpha)
        }
        
        transformGroup.isRemovedOnCompletion = false
        transformGroup.fillMode = .forwards
        
//        if model3D.isFirst(viewToAnimate.elem) {
//            transformGroup.delegate = self
//            transformGroup.setValue(viewToAnimate, forKey: "id")
//        }
//
       // transformGroup.beginTime = CACurrentMediaTime()
    transformGroup.timingFunction = CAMediaTimingFunction(name: .linear)

//        transformGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.50,
//                                                                            0.44      ,
//                                                                            0.7       ,
//                                                                            0.54       )
        
//        transformGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.42,
//                                                                            0.31      ,
//                                                                            0.77       ,
//                                                                            0.57       )
//        //on associe la view à son animation afin de retrouver la vue de l'animation qui s'est terminé
 
        viewToAnimate.layer.add(transformGroup, forKey: "translationAndResize")
        self.view.layer.addSublayer(viewToAnimate.layer)
        
        viewToAnimate.setNeedsDisplay()
    }
    
    


var goingToTurn = false
 var stopCoins = false
    
    func stopGeneratingCoins()-> Bool{
        return stopCoins
    }
    
   var n = 0
    
    //get called by the timer every duration
    func animate() {

       // self.view.layer.removeAnimation(forKey: "id")
        model3D.removeFirst()
        removeFirstView()
        
        //on genere un nouvel element si on ne va pas tourner
        let elem = model3D.generateElement(level: .easy)
        let type = elem.type()
        if !goingToTurn {
            appendView(withElem: elem)
            
            if type == TypeOfElem.turnLeft || type == TypeOfElem.turnRight {
                //créé la vue et l'ajoute à la liste des elements geree par le controller
                //cette vue sera animée
                print("------------lutilisateur va tourner")
                goingToTurn = true
                stopCoins = true
            }
        }
       
        for view in self.threeDView {
            initAnimation(viewToAnimate: view)
        }
    }
    

    func turn (level: Level) {
       
        for _ in 1...N {
            //genere un element droit
            //se frame est calculée au prealable par le model pour que la vue
            //associée soit affiché au bon endroit
            
            //au bout de 10 tours on augmente la diccifulté
            //et on augmente la vitesse donc on dminue la durée
            
           
            let elem = model3D.generateElement(level: level)
            print("Turn generated type \(elem.type())" )
            //créé la vue et l'ajoute à la liste des elements geree par le controller
            //cette vue sera animée
            appendView(withElem: elem)
            
            let type = elem.type()
            if type == TypeOfElem.turnLeft || type == TypeOfElem.turnRight {
                goingToTurn = true
                stopCoins = true
                return
            }
        }
        
        goingToTurn = false
        stopCoins = false
        
    }
    
    //on change de niveau apres un virage
    //car es vitesses d'animations changeant en modifiant le niveau
    var levelHasChanged : Bool = false
    func setLevel(newLevel: Level)  {
        level = newLevel
        levelHasChanged = true
    }
    
    
 
    //when rotating we have to update all the level and reompute te sizes and transofrmations
    func updateN(newN : Int){
    
    }
 
    
   
}





