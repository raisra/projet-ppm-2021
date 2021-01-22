//
//  3DRoad.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import Foundation
import UIKit





class ThreeDRoadElement {
    var type : TypeOf3DRoadElement
    var view : UIImageView
    
    //index
    var n : Int
    
    init(t: TypeOf3DRoadElement, view : UIImageView, n : Int) {
        self.type = t
        self.view = view
        self.n = n
    }

}

class ThreeDRoadView : UIView {
    
    var nElements : Int = 0
    var roadElements : [ThreeDRoadElement]
    var size : CGSize
    var r1 : CGFloat
    //var r2 : CGFloat
    /**
        r1 le rapport de taille entre l'image 2 et 1
            r2 le rapport entre l'image 2 et 3
     */
    init(frame: CGRect, _ size : CGSize, _ r1: CGFloat, _ r2: CGFloat = CGFloat()) {
        roadElements = [ThreeDRoadElement]  ()
        self.r1 = r1
      //  self.r2 = r2
        self.size = size
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func append(type: TypeOf3DRoadElement, view : UIImageView) {
        
        //tous les elements ajoutéées avec une rotation doivent etre traités differemment
        //en prevision de la rotation
        
         append(type: TypeOf3DRoadElement, view : UIImageView, n : nbElements )
        
        
        
    }
    
    
    
    func append(type: TypeOf3DRoadElement, view : UIImageView, n : Int) {
        var lastElementFrame : CGRect
        if nElements == 0 {
             lastElementFrame = roadElements.last!.view.frame
            view.frame.size = self.size
            view.frame.origin.x = 0
            view.frame.origin.y = self.frame.height - self.size.height
        } else {
        
            let lastElementFrame : CGRect = roadElements.last!.view.frame
        
            view.frame.size = CGSize(width: lastElementFrame.size.width*r1, height: lastElementFrame.size.height*r1)
            let r = lastElementFrame.size.width * ( 1.0 - r1)/2.0
            view.frame.origin = CGPoint(x: lastElementFrame.origin.x - r  , y: lastElementFrame.origin.y - lastElementFrame.height*r1)
        }
        roadElements.append(ThreeDRoadElement(t: type, view : view, n : nbElements))
        nElements += 1
        
//        var t = CGAffineTransform.identity
//        t = t.translatedBy(x: 0, y: self.frame.height)
//        t = t.scaledBy(x: r1*CGFloat(nElements), y: r1*CGFloat(nElements)) UTILISER sqrt()
//        view.transform = t
//
    }
    
    //when rotating we have to update all the level and reompute te sizes and transofrmations
    func updateN(newN : Int){
        
        
        
        
    }
    
    
    //si j'enleve une rotation
    // je dois mettre à jour les elements suivants jusqu'a la prochaine rotation
    func removeFirst() -> ThreeDRoadElement {
        let t = roadElements.remove(at: 0).type
        
        if t == TypeOf3DRoadElement.turnLeft || t == TypeOf3DRoadElement.turnRight {
            //je dois mettre à jour tous les prochaines animations
            //TODO Il faudra aussi ne pas les metttre à jour au momembt de l'ajout
            // dans add, ne pas faire init animation quand il y a une rotation aui a eté rajoité avant
        }
    }
    
    
   
 
}
