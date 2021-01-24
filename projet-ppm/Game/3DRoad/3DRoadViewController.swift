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
 
    let names : [TypeOfElem: String] = [.straight:"straight", .bridge:"bridge", .empty: "empty", .passage: "passage", .tree: "tree"]
    //let names : [TypeOfElem: String] = [.straight:"straight-1", .tree:"tree-1"]
    let duration : TimeInterval = 1
    var size : CGSize = CGSize(width: 400, height: 400) //400, 150
    let rh : CGFloat = 0.45
    let rw : CGFloat = 0.45
    

    let N : Int = 4
    
    var nbElements : Int
    var level :  Level
    
    var model : ThreeDRoadModel
    //la vue à afficher. C'est un tableau contenant les portion de route à afficher
    var threeDView : [ThreeDRoadView]
    

    let deltaY = 10
    
    init() {
        level = .easy
       
        nbElements = 0
        
        let r = size.height/size.width
        size.width = UIScreen.main.bounds.width
        size.height = size.width * r
        
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

        let scaleX = CABasicAnimation(keyPath: "transform.scale.x")
        scaleX.fromValue = 1
        scaleX.toValue = viewToAnimate.elem.scaleW

        let scaleY = CABasicAnimation(keyPath: "transform.scale.y")
        scaleY.fromValue = 1
        scaleY.toValue = viewToAnimate.elem.scaleH


        let transformGroup : CAAnimationGroup = CAAnimationGroup()

        transformGroup.duration = CFTimeInterval(viewToAnimate.elem.duration)
        transformGroup.repeatCount = 1
        transformGroup.autoreverses = false

        transformGroup.animations = [translate, scaleX, scaleY]
        transformGroup.isRemovedOnCompletion = true
        transformGroup.fillMode = .forwards
        
        if model.isFirst(viewToAnimate.elem) {
            transformGroup.delegate = self
            transformGroup.setValue(viewToAnimate, forKey: "id")
        }
   
       // transformGroup.beginTime = CACurrentMediaTime()
    //transformGroup.timingFunction = CAMediaTimingFunction(name: .linear)
//        transformGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.55,
//                                                                            0.44      ,
//                                                                            0.68       ,
//                                                                            0.54       )
        transformGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.50,
                                                                            0.44      ,
                                                                            0.7       ,
                                                                            0.54       )
        
//        transformGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.42,
//                                                                            0.31      ,
//                                                                            0.77       ,
//                                                                            0.57       )
//        //on associe la view à son animation afin de retrouver la vue de l'animation qui s'est terminé
 
        viewToAnimate.layer.add(transformGroup, forKey: "translationAndResize")
        self.view.layer.addSublayer(viewToAnimate.layer)
    }
    
    



   var n = 0
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let tv = anim.value(forKey: "id") as! ThreeDRoadView
        if(!flag) {
            return
        }
       

       // self.view.layer.removeAnimation(forKey: "id")
        model.removeFirst()
        removeFirstView()
        
        let elem = model.generateElement(level: .easy)
        
        //créé la vue et l'ajoute à la liste des elements geree par le controller
        //cette vue sera animée
        let v = appendView(withElem: elem)!
        initAnimation(viewToAnimate: v)
        
        for view in self.threeDView {
            initAnimation(viewToAnimate: view)
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
 

}



