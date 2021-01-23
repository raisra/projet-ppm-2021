//
//  3DRoadController.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import Foundation
import UIKit


enum TypeOfElem: Int {
    case turnLeft = 0
    case turnRight = 1
    case straight = 2
    case tree = 3
    case bridge = 4
    case passage = 5
    case empty = 6
}

class ThreeDElem : Hashable{

    typealias Direction = (h: Int, v: Int)
    var t: TypeOfElem
    var d : Direction
    var index : Int
    
    var frame : CGRect
    
    init(t: TypeOfElem, _ index : Int = 0) {
        self.t = t
        
        switch t {
        case .turnLeft:
            self.d = (-1,0)
            break
        case .turnRight:
            self.d = (1,0)
            break
        case .straight:
            self.d = (0,1)
            break
        case .tree :
            self.d = (0,1)
            break
        case .bridge :
            self.d = (0,1)
            break
        case .passage :
            self.d = (0,1)
            break
        case .empty :
            self.d = (0,1)
            break
        }
        
        self.index = index
        frame = CGRect()
    }
    
    

    
    func type() -> TypeOfElem {
        return t
    }
    
    func setIndex(_ i : Int){
        index = i
    }
    
    func setFrame(frame : CGRect) {
        self.frame = frame
        
    }
    
    //compute the direction
    static func +(prevType: ThreeDElem , nextType: ThreeDElem) -> Direction {
        return (prevType.d.h + nextType.d.h ,
                prevType.d.v + nextType.d.v )
    }
    
    static func rotLeft(_ t : ThreeDElem){
        t.d = (-t.d.v, t.d.h)
    }
    
    static func rotRight(_ t : ThreeDElem) {
        t.d = (t.d.v, -t.d.h)
    }
    
    
    static func ==(a: ThreeDElem , b : ThreeDElem) -> Bool{
        return a.t == b.t
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(t)
    }
}

class ThreeDRoadModel {


    var elementsToDisplay : [ThreeDElem]
    var nbElements : Int = 0
    var size : CGSize
    
     var rh: CGFloat
    var rw : CGFloat
    
    
    
    init(s : CGSize, rh : CGFloat, rw : CGFloat) {
        elementsToDisplay = [ThreeDElem]()
        size = s
        self.rh = rh
        self.rw = rw
    }
    
    
//     func computeFrame(rh: CGFloat, rw : CGFloat, index : Int)->CGRect{
//
//        let index_ = CGFloat(index)
//        let x : CGFloat = pow(rw, index_)*(1.0-rw) * size.width
//        let y : CGFloat = size.height * ( 1 - pow(rh, index_+1.0))/(1.0-rh)
//
//        return CGRect(x: x, y: y, width: size.width*pow(rw, index_), height: size.height*pow(rh, index_))
//    }
    
    
    // calcule la frame de la piece empilée
    //TODO prendre en compre les pieces qui ont été empiler
    //TRES compliqué à calculer
    //du coup on s'est limité au cas d'empilement de piece sans changement de direction
    func computeFrame(lastElem : ThreeDElem?) -> CGRect {
    
        var o : CGPoint
        var s : CGSize
        var res : CGRect
        let w = UIScreen.main.bounds.size.width
        let h = UIScreen.main.bounds.size.height
        
        if lastElem == nil {
            o = CGPoint(x: (w-size.width)/2.0, y: h-size.height)
            s = size
            return CGRect(origin: o, size: s)
        }

        o = lastElem!.frame.origin
        s = lastElem!.frame.size
        
        if lastElem == nil || !(lastElem?.t == TypeOfElem.turnLeft || lastElem?.t == TypeOfElem.turnRight) {
             res = CGRect( x: o.x + s.width*(1 - rw)/2.0
                           , y: o.y - rh*s.height
                           , width: s.width*rw
                           , height: s.height*rh
            )
        }
        else {
            //on a une rotation
            var x : CGFloat
            if lastElem!.t == TypeOfElem.turnLeft {
                x =  o.x - s.width*rw
            }
            else {
                x = o.x + s.width
            }
            
            res =  CGRect( x: x
                           , y: o.y
                           , width: s.width
                           , height: s.height)
        
        }
        return res
    }
    
    //utile quand on tourne le monde et au debut du jeu
    func generateElementStraight()->ThreeDElem{
        let newElem = ThreeDElem(t: .straight, nbElements)
        return newElem
    }
    
    func generateElement(level : Level)->ThreeDElem{
        
        let lastElementType = elementsToDisplay[nbElements-1].type()
       // let firstElement = elementsToDisplay.remove(at: 0)
        
        
        var nextPossibleType : [TypeOfElem]
        
        
        switch lastElementType {
        case .straight:
            //straight turn tree bridge passage
            nextPossibleType = [.straight, .turnLeft, .turnRight, .bridge, .passage, .tree, .empty]
            break
            
            
        case .turnLeft, .turnRight, .passage, .bridge, .tree, .empty :
            nextPossibleType = [.straight]
            break
            
        }
        
        
        var nextElementType: TypeOfElem
        
        var probability : Int = 100
        
        switch level {
        case .easy:
            probability = 80
            break
        case .average:
            probability = 50
            break
            
        case .hard:
            probability = 30
            break
        
        }
        
        let p = Int.random(in: 1...100)
        if p < probability {
            nextElementType = .straight
        }
        else{
            let r = Int.random(in : 0..<nextPossibleType.count)
            nextElementType = nextPossibleType[r]
        }
        
        
        let nextElement = ThreeDElem(t: nextElementType)
        return nextElement
    }
    

    func getElements() -> [ThreeDElem] {
        return elementsToDisplay
    }
    
    func getLastElem() -> ThreeDElem? {
        return elementsToDisplay.last
    }
 
    
    //ajoute à la verticiale
    func append(elem: ThreeDElem) {
        let e = getLastElem()
        let f = computeFrame(lastElem: e)
        elem.setFrame(frame : f)
        elementsToDisplay.append(elem)
        nbElements += 1
    }
    
}
