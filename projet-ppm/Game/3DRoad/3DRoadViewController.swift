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
 
    let dict : [TypeOf3DRoadElement:String] = [.straight:"straightRoad"]
    let r1 : CGFloat = 2.1
    let r2 : CGFloat = 1.4
    
    //size of the first pic
    var size : CGSize?  = nil
    
    var dictOf3DRoadViews : [TypeOf3DRoadElement: UIImageView?]
    
    var level :  Level
    var duration : TimeInterval
    
    var model : ThreeDRoadModel
    var threeDView : ThreeDRoadView
    
    init(duration : TimeInterval) {
        level = .easy
        self.duration = duration
        
        dictOf3DRoadViews = [TypeOf3DRoadElement: UIImageView]()
        var im : UIImage?
        for (_,kv) in dict.enumerated() {
            im = UIImage(named: kv.value)
            let imview = UIImageView(image: im)
            imview.contentMode = .scaleAspectFill
            
            dictOf3DRoadViews.updateValue(imview, forKey: kv.key)
        }
        size = im?.size
        
        model = ThreeDRoadModel()
        threeDView = ThreeDRoadView(frame: UIScreen.main.bounds, size!, r1,  r2)
        
        super.init(nibName: nil, bundle: nil)
        self.view = threeDView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getImageView(accordingTo : TypeOf3DRoadElement) -> UIImageView{
        return dictOf3DRoadViews[accordingTo]!!
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        //on enleve la vue qui est sortie
        //c'est focemment le premier element
        threeDView.removeFirst()
        
        //TODOOOooooo
        
        
     //   IL ne FAUT pas mettre à jour la durée de l'animation pour les view située apres une rotation
        
        
        
        //////////////////////
        //on ajoute une nouvelle
        //dabord on genere une nouvelle vue grace au model
        let t : TypeOf3DRoadElement = model.generateElement(level: level)!
        threeDView.append(type: t, view: getImageView(accordingTo: t))
    }
    
    
    //on change de niveau apres un virage
    //car es vitesses d'animations changeant en modifiant le niveau
    var levelHasChanged : Bool = false
    func setLevel(newLevel: Level)  {
        level = newLevel
        levelHasChanged = true
    }
    
    
    func initAnimation(elem : ThreeDRoadElement, duration: TimeInterval) {
        let translate = CABasicAnimation(keyPath: "translation.y")
        translate.fromValue = elem.view.frame.origin.y
        translate.toValue = view.frame.height
            
        let transform = CABasicAnimation(keyPath: "transform.scale.x")
        transform.fromValue = 1
        transform.toValue = 1.0 / pow(Double(r1), Double(nElements))
        
        let transformGroup : CAAnimationGroup = CAAnimationGroup()
        transformGroup.duration = duration
        transformGroup.repeatCount = 0
        transformGroup.autoreverses = false
        transformGroup.animations = [translate, transform]
        transformGroup.isRemovedOnCompletion = true
        transformGroup.fillMode = .removed
        transformGroup.delegate = self
        
       
        elem.view.layer.add(transformGroup, forKey: "translationAndResize")
    }
    
}
