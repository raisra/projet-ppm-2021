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

class ThreeDElem {

    typealias Direction = (h: Int, v: Int)
    var t: TypeOfElem
    var d : Direction
    //var index : Int
    
    var frame : CGRect
    var yTranslate : CGFloat
    var duration  :TimeInterval
    var scaleH : CGFloat
    var scaleW : CGFloat
    var index : Int
    
    init(t: TypeOfElem, _ index : Int) {
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
        
        //self.index = index
        frame = CGRect()
        yTranslate = 0.0
        duration = 0.0
        scaleH = 0.0
        scaleW = 0.0
        self.index = index
    }
    
    

    
    func type() -> TypeOfElem {
        return t
    }
    
//    func setIndex(_ i : Int){
//        index = i
//    }
    
    func setFrame(frame : CGRect) {
        self.frame = frame
    }
    
    func setYTranslation(_ d : CGFloat)  {
        yTranslate = d
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
    
    

}




class ThreeDRoadModel {


    var elementsToDisplay : [ThreeDElem]
    var nbElements : Int = 0
    var size : CGSize
    var rh: CGFloat
    var rw : CGFloat
    var duration : TimeInterval
    

    
    
    
    init(s : CGSize, rh : CGFloat, rw : CGFloat, duration : TimeInterval) {
        elementsToDisplay = [ThreeDElem]()
        size = s
        self.rh = rh
        self.rw = rw
        self.duration = duration
    }
    
    
//     func computeFrame(rh: CGFloat, rw : CGFloat, index : Int)->CGRect{
//
//        let index_ = CGFloat(index)
//        let x : CGFloat = pow(rw, index_)*(1.0-rw) * size.width
//        let y : CGFloat = size.height * ( 1 - pow(rh, index_+1.0))/(1.0-rh)
//
//        return CGRect(x: x, y: y, width: size.width*pow(rw, index_), height: size.height*pow(rh, index_))
//    }
    
    
    func computeSpeed() -> TimeInterval {
        return  duration
    }
    
    func computeSpeed(index: Int) -> TimeInterval {
        
        return duration * (Double(index)+1.0)
    }
    
    func computeYTranslation(index : Int) -> CGFloat {
        let i : CGFloat = CGFloat(index)
        let a = size.height*(rh + 1.0)/2.0
        let b = (1.0/rh + (1.0 - pow(rh, i))/(1.0 - rh))
         return a*b
       
    }
    
    func computeSCale(index : Int ) -> (scaleH:CGFloat, scaleW: CGFloat) {
        var s1 = CGFloat(1.0/rh)
        var s2 = CGFloat(1.0/rw)
        
        s1 = pow(s1, CGFloat(index+1))
        s2 = pow(s2, CGFloat(index+1))
        return (s1,s2)
    }
    
    func computeYTranslation(lastElem: ThreeDElem?) -> CGFloat {
        
        var lastFrameHeight : CGFloat
        if lastElem == nil {
            lastFrameHeight = size.height/rh
        }
        else {
            lastFrameHeight =  lastElem!.frame.height
        }
        return lastFrameHeight * (rh+1.0)/2.0
    }
    
    func computeSCale() -> (scaleH:CGFloat, scaleW: CGFloat) {
//        if lastElem == nil {
//            return CGFloat(1.0/rh)
//        }
//
//        return lastElem!.scale * CGFloat(1.0/rh)
        return (CGFloat(1.0/rh), CGFloat(1.0/rw))
    }
    
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
            
            res =  CGRect( x: x , y: o.y, width: s.width, height: s.height)
        }
        return res
    }
    
    //utile quand on tourne le monde et au debut du jeu
    func generateElementStraight()->ThreeDElem{
        let newElem = ThreeDElem(t: .straight, nbElements)
        append(elem: newElem)
        return newElem
    }
    
    func generateElement(level : Level)->ThreeDElem{
        
        let lastElementType : TypeOfElem?
        if nbElements == 0 {
            lastElementType = .straight
        } else {
             lastElementType = elementsToDisplay[nbElements-1].type()
        }
    
        
        var nextPossibleType : [TypeOfElem]
        
        
        switch lastElementType! {
        case .straight:
            //straight turn tree bridge passage
            nextPossibleType = [.straight, .bridge, .passage, .tree, .empty] //.turnLeft, .turnRight
            break
            
            
        case .turnLeft, .turnRight, .passage, .bridge, .tree, .empty :
            nextPossibleType = [.straight]
            break
            
        }
        
        
        var nextElementType: TypeOfElem
        
        var probability : Int
        
        switch level {
        case .easy:
            probability = 50
            break
        case .average:
            probability = 40
            break
        case .hard:
            probability = 20
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
        
        
        let nextElement = ThreeDElem(t: nextElementType, nbElements)
        append(elem: nextElement)
        return nextElement
    }

    
    //ajoute à la verticiale
   private func append(elem: ThreeDElem){
       // elem.setIndex(nbElements)
        let e = getLastElem()
        let f = computeFrame(lastElem: e)
        elem.setFrame(frame : f)
        let d = computeYTranslation(lastElem: e)
        elem.setYTranslation(d)
        let v = computeSpeed()
        elem.duration = v
        let s = computeSCale()
    elem.scaleH = s.scaleH
    elem.scaleW = s.scaleW
    print ( "data for index \(elem.index) : Time:\(elem.duration) TranslateY: \(elem.yTranslate) Scale: \(elem.scaleH) \(elem.scaleW) Y: \(elem.frame.origin.y)")
        elementsToDisplay.append(elem)
        nbElements += 1
    }
    
//    private func append(elem: ThreeDElem){
//        let index = elem.index
//        // elem.setIndex(nbElements)
//         let e = getLastElem()
//         let f = computeFrame(lastElem: e)
//         elem.setFrame(frame : f)
//         let d = computeYTranslation(index: index)
//         elem.setYTranslation(d)
//         let v = computeSpeed(index: index)
//         elem.duration = v
//         let s = computeSCale(index: index)
//     elem.scaleH = s.scaleH
//     elem.scaleW = s.scaleW
//        print ( "data for index \(elem.index) : Time:\(elem.duration) TranslateY: \(elem.yTranslate) Scale: \(elem.scaleH) \(elem.scaleW) Y: \(elem.frame.origin.y) size: \(elem.frame.size)")
//         elementsToDisplay.append(elem)
//         nbElements += 1
//     }
//
    
    func removeFirst(){
        
        if nbElements == 0 {
            return
        }
        
        var i = nbElements-1
        while i>0 {
            let elem = elementsToDisplay[i]
            let prevElem = elementsToDisplay[i-1]
            
            elem.frame = prevElem.frame
            elem.index = prevElem.index
            elem.yTranslate = prevElem.yTranslate
            elem.duration = prevElem.duration
            elem.scaleH = prevElem.scaleH
            elem.scaleW = prevElem.scaleW
            i -= 1
        }
        
        elementsToDisplay.removeFirst()
        nbElements -= 1
    }
    
    func getElements() -> [ThreeDElem] {
        return elementsToDisplay
    }
    
    func getLastElem() -> ThreeDElem? {
        return elementsToDisplay.last
    }
 
    
    func isFirst(_ elem : ThreeDElem) -> Bool {
        return elem.index == 0
    }
    
    func getIndex(_ elem : ThreeDElem) -> Int? {
        return elem.index
    }
}
