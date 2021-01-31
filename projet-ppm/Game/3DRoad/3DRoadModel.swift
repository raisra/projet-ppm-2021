
import Foundation
import UIKit


let TURNLEFT = 100
let TURN_RIGHT  = 101
let STRAIGHT = 102
let TREE  = 103
let BRIDGE = 104
let PASSAGE = 105





class ThreeDRoadModel : ModelRoad{
    var nbElements : Int = 0

    var duration : TimeInterval
    
    init(_ p: ModelRoad.Param, duration : TimeInterval) {
        self.duration = duration
        super.init(p)
        
        let scale : CGFloat = (p.fSize - p.bSize)/CGFloat(nRows)
        
        for k in 0...nRows {
            for i in iMin...iMax {
                //
                let f = self.getObj(i, k)
                
                let s = computeSpeed()
                let o = computeOpacity(index: nRows-k)
                let sc = 1.0 + scale/( p.bSize + scale * CGFloat(k) )
                let x = computeXTranslation(i: i, j: k)
                let y = computeYTranslation(i: i, j: k, factor: 1)
                
                f.duration = s
                f.opacity = o
                f.scaleH = sc
                f.scaleW = sc
                f.yTranslate = y
                f.xTranslate = x
                f.setType(_EMPTY_)

                initAnimation(elem: f)
            }
        }
        for k in 0...nRows {
            let f = self.getObj(0, k)
            
            let fr = computeFrame(index: nRows-k)
            let s = computeSpeed()
            let o = computeOpacity(index: nRows-k)
            let sc = computeSCale()
            let y = computeYTranslation(index: nRows - k)
            let size = computeSize(index: nRows - k)
            f.frame = fr
            f.duration = s
            f.opacity = o
            f.scaleH = sc.scaleH
            f.scaleW = sc.scaleW
            f.yTranslate = y
            f.xTranslate = 0
            f.size = size
            f.setType(_EMPTY_)
            f.index = nRows - k
            f.index_j = -1
            initAnimation(elem: f)
        }
    }
    
    
    
    override func reset() {
        super.reset()
        nbElements = 0
        duration = DURATION
    }
    
    func setDuration(duration: TimeInterval)  {
        self.duration = duration
    }
    func getElemAtIndex(_ i : Int) -> Frame? {
        if nbElements == 0 {return nil}
        
        return getObj(0, nRows - i )
    }
    
    func getCenter(index: Int) -> CGPoint? {
        return getElemAtIndex(nRows - index)?.center
    }
    
//     func computeFrame(factor: CGFloat, factor : CGFloat, index : Int)->CGRect{
//
//        let index_ = CGFloat(index)
//        let x : CGFloat = pow(factor, index_)*(1.0-factor) * size.width
//        let y : CGFloat = size.height * ( 1 - pow(factor, index_+1.0))/(1.0-factor)
//
//        return CGRect(x: x, y: y, width: size.width*pow(factor, index_), height: size.height*pow(factor, index_))
//    }
    
    
    func computeSpeed() -> TimeInterval {
        return  duration
    }
    
    func computeOpacity(index : Int) -> CGFloat {
//        let i : CGFloat = CGFloat(index)
//        let n : CGFloat = CGFloat(nbElements)
//        return (n - i ) / n
        return 1
    }
    
    func computeYTranslation(index : Int) -> CGFloat {
        let i_ : CGFloat = CGFloat(nRows) - CGFloat(index)
    
        let c = (factor+1.0) * F(i_) / 2.0
        let d = (factor+1.0) * F(i_+1) / 2.0
       
        return c-d
    }
    
    func computeXTranslation(i : Int , j : Int) -> CGFloat {
        return  linearX(i, j+1) - linearX(i, j)
    }
    
    func computeYTranslation(i : Int , j : Int, factor : CGFloat) -> CGFloat {
        let j_ : CGFloat = CGFloat(j)
        
        let c = (factor+1.0) * F(j_) / 2.0
        let d = (factor+1.0) * F(j_+1) / 2.0
        
        return c-d
    }
    
    func computeYTranslation(i : Int , j : Int) -> CGFloat {
        return computeYTranslation(i: i, j: j, factor: self.factor)
    }
    
    
    func computeSCale(index : Int ) -> (scaleH:CGFloat, scaleW: CGFloat) {
        let i_ : CGFloat = CGFloat(nRows) - CGFloat(index)
        let rh = (F(i_ - 1) - F(i_)) / (F(i_) - F(i_ + 1))
        return (1/rh,1/factor)
    }
    
    func computeFrame(index: Int) -> CGRect {
        let i_ : CGFloat = CGFloat(nRows) - CGFloat(index)
        let f = linearNoCenter(0, Int(i_))
        let h = F(i_-1)-F(i_)
     
        let s = CGSize(width: size0.width * pow(factor,CGFloat(index)), height: h )
        return CGRect(origin: CGPoint(x: f, y: UIScreen.main.bounds.height - F(i_-1)), size: s)
    }
    
    
    func computeCenter(index:Int) -> CGPoint {
        let e = getElemAtIndex(index-1)
        
        if e == nil {
            return CGPoint(x: size0.width/2.0, y: UIScreen.main.bounds.height - size0.height/2.0)
        }
        else {
            let prevCenter = e!.center
            let y = prevCenter!.y - computeYTranslation(index: index)
            let x = prevCenter!.x
            return CGPoint(x: x, y: y)
        }
    }
    
    func computeSize(index: Int) -> CGSize {
        let i_ : CGFloat = CGFloat(nRows) - CGFloat(index)
        let h = F(i_-1)-F(i_)
        return CGSize(width: size0.width * pow(factor,CGFloat(index)), height: h )
    }
    
    func computeSCale() -> (scaleH:CGFloat, scaleW: CGFloat) {
        return (CGFloat(1.0/factor), CGFloat(1.0/factor))
    }
    
    func computeYTranslation(lastElem: Frame?) -> CGFloat {
        var lastFrameHeight : CGFloat
        if lastElem == nil {
            lastFrameHeight = size0.height/factor
        }
        else {
            lastFrameHeight =  lastElem!.frame!.height
        }
        return lastFrameHeight * (factor+1.0)/2.0
    }
    
    
    func generateElement(level : Level)->TypeOfObject{
        let lastElementType : TypeOfObject?
        if nbElements == 0 {
            lastElementType = STRAIGHT
        } else {
            lastElementType = getLastElem()?.getType()
        }
    
        
        var nextPossibleType : [TypeOfObject]
        
        
        switch lastElementType! {
        case STRAIGHT:
            //straight turn tree bridge passage
            nextPossibleType = [STRAIGHT, BRIDGE, PASSAGE, TREE, _EMPTY_, TURNLEFT, TURN_RIGHT]
            break
            
            
        case TURNLEFT, TURN_RIGHT,  BRIDGE, PASSAGE, TREE, _EMPTY_ :
            nextPossibleType = [STRAIGHT]
            break
            
        default:
            nextPossibleType = [STRAIGHT]
        }
        
        
        var nextElementType: TypeOfObject
        
        var probability : Int
        
        switch level {
        case .Beginner:
            probability = 80
            break
        case .Medium:
            probability = 50
            break
        case .Hard:
            probability = 20
            break
        case .Extreme:
            probability = 10
            break
        }
        
        let p = Int.random(in: 1...100)
        if p < probability {
            nextElementType = STRAIGHT
        }
        else{
            let r = Int.random(in : 0..<nextPossibleType.count)
            nextElementType = nextPossibleType[r]
        }
        
        
        return nextElementType
    }


    
    //ajoute à la verticiale
   func append(im : UIImageView, type: TypeOfObject) -> Frame?{

        if (nRows - nbElements) < 0 {
            return nil
        }
    
        let obj = super.addObj(im, type: type, i: 0, j: nRows - nbElements)
        startAnimation(elem: obj)
        nbElements += 1
    
        return obj
    }
    
    
    func startAnimation(elem: Frame){
        elem.view?.layer.add(elem.transformation!, forKey: "translationAndResize")
    }

    
    
    func initAnimation(elem : Frame){
        
        var center : CGPoint
        if elem.index_j == -1 {
            center = CGPoint(x:elem.frame!.midX, y:elem.frame!.midY )
        }
        else {
            center = elem.center!
        }
        
        let translateY = CABasicAnimation(keyPath: "position.y")
        translateY.fromValue = center.y
        translateY.toValue = center.y + elem.yTranslate
        
        let translateX = CABasicAnimation(keyPath: "position.x")
        translateX.fromValue = center.x
        translateX.toValue = center.x + elem.xTranslate
        
        let scaleX = CABasicAnimation(keyPath: "transform.scale.x")
        scaleX.fromValue = 1
        scaleX.toValue = elem.scaleW

        let scaleY = CABasicAnimation(keyPath: "transform.scale.y")
        scaleY.fromValue = 1
        scaleY.toValue = elem.scaleH

        let transformGroup : CAAnimationGroup = CAAnimationGroup()

        transformGroup.duration = CFTimeInterval(elem.duration)
        transformGroup.repeatCount = 1
        transformGroup.autoreverses = false

       
        transformGroup.animations = [translateX, translateY, scaleX, scaleY]
        
        if elem.index >= Int(NB_ROWS) - 1 {
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
 
        
        elem.transformation = transformGroup
      
    }
    
    override func removeObject(i:Int , j : Int, type: TypeOfObject)->(type: TypeOfObject, view: UIImageView?){
        let r = super.removeObject(i: i, j: j, type: type)
        r.view?.layer.removeAllAnimations()
        
        return r
    }
    
    /**
     completion : la methode à effectuer en cas de sortie d'une piece de l'ecran
     */
    override func movedown(){
        
        //suppression de la derniere ligne
        for i in  0..<nColumns {
            let obj = getObj(i, nRows)
            if obj.getType() != _EMPTY_ {
                    obj.view?.isHidden = true
            }
        }
        
        
        //print("decalage vers le bas")
        //decalage des cases vers le bas
        for i in 0..<nColumns {
            var j = nRows-1
          
            while(j>=0)
            {
                let obj = getObj(i, j+1)
                let prevObj = getObj(i, j)
                
                obj.view = prevObj.view
                obj.type = prevObj.type
                
                let view = obj.view
                
                if i ==  0{
                    view?.frame = obj.frame!
                } else {
                    view?.frame = CGRect(origin: CGPoint(), size: obj.size!)
                    view?.center = obj.center!
                }
               
                startAnimation(elem: obj)
                //view!.layer.addSublayer(viewToAnimate.layer)
                
                j -= 1
            }
        }
        
    
        
        
        //Creation d'une ligne vide et insertion au debut de la grille
        for i in 0..<nColumns {
            let obj = roadGrid[i]
            obj.view = nil
            obj.type = _EMPTY_
        }
        
        
        nbElements -= 1
        if nbElements < 0 {
            print("EROOOOOOOOR")
            nbElements = 0
        }
    }
    
    
    
    func deleteAllRoad(){
        if nbElements == 0 { return }
        
        for i in 0..<nbElements {
            removeAndDelete(i: 0, j: nRows - i, type: any)
        }
        
        nbElements = 0
    }

    
 
    func getLastElem() -> Frame? {
        if nbElements == 0 {
            return nil
        }
        
        return self.getObj(0, nRows-nbElements+1)
    }
    
    func isFirst(_ elem : Frame) -> Bool {
        return elem.index == 0
    }
    
    func getIndex(_ elem : Frame) -> Int? {
        return elem.index
    }
    
    func getFirst() -> Frame? {
        if nbElements == 0 {return nil}
        return self.getObj(0, nRows)
    }
    
    
    
    
    func printRoadModel(){
        if nbElements == 0 {
            print("ROAD IS EMPTY")
            return
        }
        print("&&&&&&&&&&&&&&&&&&&&")
        for j in 0..<nbElements {
            print("elem \(nRows - j): \(self.getObj(0, nRows - j).type)")
        }
        print("&&&&&&&&&&&&&&&&&&&&")
    }
}



//
//    //ajoute à la verticiale
//   private func append(elem: Frame){
//       // elem.setIndex(nbElements)
//        let e = getLastElem()
//        let f = computeFrame(lastElem: e)
//        elem.setFrame(frame : f)
//        let d = computeYTranslation(lastElem: e)
//        elem.setYTranslation(d)
//        let v = computeSpeed()
//        elem.duration = v
//        let s = computeSCale()
//    elem.scaleH = s.scaleH
//    elem.scaleW = s.scaleW
//    print ( "data for index \(elem.index) : Time:\(elem.duration) TranslateY: \(elem.yTranslate) Scale: \(elem.scaleH) \(elem.scaleW) Y: \(elem.frame.origin.y)")
//
//    print ( "data for index \(elem.index) : Time:\(elem.duration) TranslateY: \(computeYTranslation(index: elem.index)) Scale: \(computeSCale(index: elem.index).scaleH) \(computeSCale(index: elem.index).scaleW) Y: \(computeFrame(index: elem.index).origin.y)")
//
//    print("--------------------------------------------")
//        elementsToDisplay.append(elem)
//        nbElements += 1
//
//   // print ( "Index \(elem.index):  posY : \(elem.frame.origin.y)")
//    }
    








//    func computeFrame(lastElem : Frame?) -> CGRect {
//
//        var o : CGPoint
//        var s : CGSize
//        var res : CGRect
//        let w = UIScreen.main.bounds.size.width
//        let h = UIScreen.main.bounds.size.height
//
//        if lastElem == nil {
//            o = CGPoint(x: (w-size0.width)/2.0, y: h-size0.height)
//            s = size0
//            return CGRect(origin: o, size: s)
//        }
//
//        o = lastElem!.frame!.origin
//        s = lastElem!.frame!.size
//
//        if lastElem == nil || !(lastElem?.type() == TypeOfObject.turnLeft || lastElem?.type() == TypeOfObject.turnRight) {
//             res = CGRect( x: o.x + s.width*(1 - factor)/2.0
//                           , y: o.y - factor*s.height
//                           , width: s.width*factor
//                           , height: s.height*factor
//            )
//        }
//        else {
//            //on a une rotation
//            var x : CGFloat
//            if lastElem!.type() == TypeOfObject.turnLeft {
//                x =  o.x - s.width*factor
//            }
//            else {
//                x = o.x + s.width
//            }
//
//            res =  CGRect( x: x , y: o.y, width: s.width, height: s.height)
//        }
//
//
//        return res
//    }
    

    

    
