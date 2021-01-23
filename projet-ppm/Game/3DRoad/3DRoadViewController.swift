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
    let duration : TimeInterval = 1
    let size : CGSize = CGSize(width: 400, height: 400)
    let rh : CGFloat = 0.45
    let rw : CGFloat = 0.45

    
    var nbElements : Int
    var level :  Level
    
    var model : ThreeDRoadModel
    //la vue à afficher. C'est un tableau contenant les portion de route à afficher
    var threeDView : [ThreeDRoadView]
    

    
    init() {
        level = .easy
       
        nbElements = 0
        
        model = ThreeDRoadModel(s: size, rh: rh, rw: rw, duration: duration)
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
    func appendView(withElem: ThreeDElem) -> ThreeDRoadView?{
        //create the image view
        let type = withElem.type()
        let name = getName(accordingTo: type)
        let i = UIImage(named:name)
        if i == nil {
            print("image \(name) n'existe pas")
            return nil
        }
        //we create the element and associate it to the its view
        let v = ThreeDRoadView(elem: withElem, im : i!)
        
        //initialise les animations de la nouvelle vue
        //ses animations dependent de la position dans la pile de vue
        threeDView.append(v)
        self.view.addSubview(v)
        self.view.sendSubviewToBack(v)
        nbElements += 1
        return v
    }
    
    
    
    
    func removeFirstView() {
        
        let firstView = threeDView.removeFirst()
        
        for view in threeDView {
            view.frame = view.elem.frame
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
        for _ in 1...4 {
            //genere un element droit
            //se frame est calculée au prealable par le model pour que la vue
            //associée soit affiché au bon endroit
            let elem = model.generateElementStraight()
            
            //créé la vue et l'ajoute à la liste des elements geree par le controller
            //cette vue sera animée
            let v = appendView(withElem: elem)!
            initAnimation(viewToAnimate: v)
        }
    }
    
    
    
    func initAnimation(viewToAnimate: ThreeDRoadView) {
        let translate = CABasicAnimation(keyPath: "position.y")

        translate.fromValue = viewToAnimate.center.y
        translate.toValue = viewToAnimate.center.y + viewToAnimate.elem.yTranslate
    
        let transform = CABasicAnimation(keyPath: "transform.scale")
        transform.fromValue = 1
        
        
        transform.toValue = viewToAnimate.elem.scale //1.0 / pow(Double(rh), Double(viewToAnimate.elem.index))

        let transformGroup : CAAnimationGroup = CAAnimationGroup()
       
        transformGroup.duration = CFTimeInterval(viewToAnimate.elem.duration)
        transformGroup.repeatCount = 1
        transformGroup.autoreverses = false
        
        transformGroup.animations = [translate, transform]
        transformGroup.isRemovedOnCompletion = false
        transformGroup.fillMode = .forwards
        transformGroup.delegate = self
        
        transformGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
       
        //on associe la view à son animation afin de retrouver la vue de l'animation qui s'est terminé
        transformGroup.setValue(viewToAnimate, forKey: "id")
        
        
        viewToAnimate.layer.add(transformGroup, forKey: "translationAndResize")
    }
    
    var c = 0
    //sauvegarder les view dont l'animation s'est terminé
    var buffer : [ThreeDRoadView] = [ThreeDRoadView]()
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        let threeDView = anim.value(forKey: "id") as! ThreeDRoadView
       
        print ( "animation number \(model.getIndex(threeDView.elem)! )finished ")
        if threeDView.elem.index != 0 {
            buffer.append(threeDView)
        }
       
        c += 1
        
        if c == nbElements {
            print ( "all animation finished \(nbElements )")
            
            model.removeFirst()
            removeFirstView()
            let newElem = model.generateElementStraight()
            
            //créé la vue et l'ajoute à la liste des elements gerees par le controller
            //cette vue sera animée
            let v = appendView(withElem: newElem)!
            initAnimation(viewToAnimate: v)
            
            for v in buffer {
                //toutes les animations sont terminées
                // si c'est la premiere vue, je la supprime
                    initAnimation(viewToAnimate: v)
            }
            
            c = 0
            buffer.removeAll()
        }
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
