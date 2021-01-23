//
//  3DRoadViewController.swift
//  projet-ppm
//
//  Created by ramzi on 22/01/2021.
//

import Foundation
import UIKit

enum Level {
    case easy
    case average
    case hard
}

class ThreeDRoadViewController : UIViewController , CAAnimationDelegate{
 
    let names : [TypeOfElem: String] = [.straight:"straight"]
    
    
    //size of the first pic
    var  rh : CGFloat = 0.8
    var rw : CGFloat = 0.5
    var size : CGSize
    var level :  Level
    //duration et level soint lié normalement
    var duration : TimeInterval
    

    var model : ThreeDRoadModel
    //la vue à afficher. C'est un tableau contenant les portion de route à afficher
    var threeDView : [ThreeDRoadView]
    
    
    var nElements : Int
    
    
    
    init(duration : TimeInterval, size : CGSize, rh : CGFloat, rw : CGFloat) {
        level = .easy
        self.duration = duration
        self.size = size
        nElements = 0
        self.rh = rh
        self.rw = rw
        model = ThreeDRoadModel(s: size, rh: rh, rw: rw)
        //au depart la vue est vide
        threeDView = [ThreeDRoadView]()
     
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.main.bounds
        
    }

    override func viewDidLoad() {
        startTheGame()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    func getImageView(accordingTo : ThreeDElem ) -> UIImageView{
//        return threeDView[accordingTo]!
//    }
    
    func getName(accordingTo : TypeOfElem ) -> String{
        return names[accordingTo]!
    }
    
    
    //créé la vue associée à l'element en parametre
    func appendView(withElem: ThreeDElem){
        //create the image view
        let type = withElem.type()
        let name = getName(accordingTo: type)
        let i = UIImage(named:name)
        if i == nil {
            print("image \(name) n'existe pas")
            return
        }
        //we create the element and associate it to the its view
        let v = ThreeDRoadView(elem: withElem, im : i!)
        
        //initialise les animations de la nouvelle vue
        //ses animations dependent de la position dans la pile de vue
        initAnimation(viewToAnimate: v)
        threeDView.append(v)
        self.view.addSubview(v)
        
        nElements += 1
    }
    
    
    /*
     genere 4 vue de type straight
     ajouter les à la vue principale
     commencer les animations
     */
    func startTheGame(){
        for _ in 1...4 {
            //genere un element droit
            //se frame est calculée au prealable par le model pour que la vue
            //associée soit affiché au bon endroit
            let elem = model.generateElementStraight()
            
            //créé la vue et l'ajoute à la liste des elements geree par le controller
            //cette vue sera animée
            model.append(elem: elem)
            appendView(withElem: elem)
        }
    }
    
    
    
    func initAnimation(viewToAnimate: ThreeDRoadView) {
        let translate = CABasicAnimation(keyPath: "position.y")

        translate.fromValue = viewToAnimate.center.y
        translate.toValue = 1024
    
        let transform = CABasicAnimation(keyPath: "transform.scale.x")
        transform.fromValue = 1
        transform.toValue = 2.15 //1.0 / pow(Double(rh), Double(viewToAnimate.elem.index))

        let transformGroup : CAAnimationGroup = CAAnimationGroup()
        transformGroup.duration = 10
        transformGroup.repeatCount = 100
        transformGroup.autoreverses = false
        
        transformGroup.animations = [transform, translate]
        transformGroup.isRemovedOnCompletion = false
        transformGroup.fillMode = .forwards
        transformGroup.delegate = self
        
        viewToAnimate.layer.anchorPoint.x=0.5
        
        let c = viewToAnimate.layer.bounds
        let b = viewToAnimate.layer.contentsCenter
        viewToAnimate.layer.add(transformGroup, forKey: "translationAndResize")
       
        
        
        
        
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        //on enleve la vue qui est sortie
        //c'est focemment le premier element
      //  removeFirst()
        
        //TODOOOooooo
        
        
     //   IL ne FAUT pas mettre à jour la durée de l'animation pour les view située apres une rotation
        
        
        
        //////////////////////
        //on ajoute une nouvelle
        //dabord on genere une nouvelle vue grace au model
//        let elem : ThreeDElem? = model.generateElement(level: level)
//
//        threeDView.append(type: t, view: getImageView(accordingTo: t))
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
    
    
//    //si j'enleve une rotation
//    // je dois mettre à jour les elements suivants jusqu'a la prochaine rotation
//    func removeFirst() -> ThreeDElem {
//        let t = roadElements.remove(at: 0).type
//
//        if t == ThreeDElem.turnLeft || t == TypeOf3DRoadElement.turnRight {
//            //je dois mettre à jour tous les prochaines animations
//            //TODO Il faudra aussi ne pas les metttre à jour au momembt de l'ajout
//            // dans add, ne pas faire init animation quand il y a une rotation aui a eté rajoité avant
//        }
//    }
    
    
    
    
    
    
    
    
    
    //    func append(type: ThreeDElem, view : UIImageView) {
    //
    //        //tous les elements ajoutéées avec une rotation doivent etre traités differemment
    //        //en prevision de la rotation
    //        if type == .turnLeft || type == .turnRight {
    //            rotationIsPresent = true
    //            //traiter normalement cette element
    //            //mais les prochains ajour seront différents
    //            append(type: type, view : view )
    //            nElements += 1
    //            return
    //        }
    //
    //        //
    //        if rotationIsPresent {
    //
    //
    //        }
    //        else {
    //            //ici on nn'itialise pas les transformations
    //            append(type: type, view : view )
    //        }
    //    }
}
