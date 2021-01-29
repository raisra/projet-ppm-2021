//
//  ModelRoad.swift
//  projet-ppm
//
//  Description : 
//

import Foundation
import  UIKit




typealias TypeOfObject = Int
let _COIN_ = 0
let _EMPTY_ = 1
    

    
    
let coinx2 = 20
let coinx5 = 21
let magnet = 22
    
let power = 30
let transparency = 31
let turbo = 32 //accelere
let teleportation = 33 // le personnage disparait pendant que le jeu accelere puis il reapparait
    
    
let malus = 40
let inversion = 41 //les pieces echanges de colonnes
    
let any = -1




class Frame {
    
    var view: UIImageView?
    var size : CGSize?
    var center : CGPoint?
    var frame : CGRect?
    
    var yTranslate : CGFloat = 0.0
    var xTranslate : CGFloat = 0.0
    var duration  :TimeInterval = 0.0
    var scaleH : CGFloat = 0.0
    var scaleW : CGFloat = 0.0
    var index : Int = 0
    var index_j : Int = 0
    var opacity : CGFloat = 0.0
    
    var type : TypeOfObject?
    
    var transformation : CAAnimation?
    
    func setObj(view: UIImageView?){
        self.view = view
    }
    
    
    func setFrame(frame : CGRect) {
        self.frame = frame
    }
    
    func setCenter(center : CGPoint) {
        self.center = center
    }
    
    func setSize(size : CGSize) {
        self.size = size
    }
    
    func setYTranslation(_ d : CGFloat)  {
        self.yTranslate = d
    }
    


    func getType() -> TypeOfObject {
        return type!
    }
    
    func setType( _ t: TypeOfObject){
        self.type = t
    }
}








class ModelRoad {
    
    
    var iN : [CGFloat] = [CGFloat]()
    var iMin : Int
    var iMax : Int
    var nRows : Int
    var nColumns : Int
    
    var D : CGFloat = 0
    var d : CGFloat = 0
    
    var W : CGFloat
    var H : CGFloat
    
    var bSize : CGFloat = 10.0
    var fSize : CGFloat = 100.0
    
    var roadGrid : [Frame]
    
    
    var repeatCount = 0
    var prevRandomValue : [TypeOfObject]
    var prevR = 0
    
    
    var size0 : CGSize
    var factor : CGFloat
    
    var duration : TimeInterval
    

    
    struct Param {
        var nRows: Int
        var nColumns: Int
        var W : CGFloat
        
        var D : CGFloat
        var bSize : CGFloat
        var fSize : CGFloat 
        var useData: Bool = false
        
        var size0 : CGSize
        var factor : CGFloat
        
        var duration : TimeInterval
    }
    
    
    
    init(_ p : Param) {
        self.nRows = p.nRows
        self.nColumns = p.nColumns
        
        self.W = p.W
    
        
        self.D = p.D
        d = self.D/CGFloat(p.nColumns)
        self.bSize = p.bSize
        self.fSize = p.fSize
        
        let i0 = (p.W - p.D)/2.0
        for i_ in 0..<nColumns {
            iN.append(i0 + d*CGFloat(i_))
        }
        
        self.iMin = 1
        self.iMax = nColumns - 2
        
        self.size0 = p.size0
        self.factor = p.factor
        
        self.duration = p.duration
        H = size0.height * (1.0 - pow(factor, NB_ROWS))/(1.0 - factor)
        
        roadGrid = [Frame]()
        roadGrid.reserveCapacity((nRows+1)*nColumns)
        
        repeatCount = 0
        prevRandomValue = [TypeOfObject](repeating: _EMPTY_, count: nColumns)//utiliser colonne au lieu de 3
        prevR = 0
        

        for k in 0...nRows {
            let k_ = CGFloat(k)
            for i in 0..<nColumns {
                //
                let x : CGFloat
              
                x = linearX(i, k)
                
                // print("k:\(k) i:\(i) center:\(x)" )
                let y : CGFloat = UIScreen.main.bounds.height - F(k_)
                
                let o = CGPoint(x: x, y: y)
                let s = CGSize(width: G(k_), height: G(k_))
                
                let f = Frame()
                
                f.index = i
                f.index_j = k
                
                f.setSize(size: s)
                f.setCenter(center: o)
                f.setType(_EMPTY_)
                roadGrid.append(f)
            }
        }
        
        print(roadGrid.count)
    }
    
    func getObj(_ i: Int, _ j: Int) -> Frame {
        return roadGrid[nColumns*j + i]
    }
    
   
    

    func linearX ( _ i : Int , _ k : Int) -> CGFloat{
        let k_ : CGFloat = CGFloat(k)
        let c : CGFloat = CGFloat(nColumns)
        
        var x : CGFloat =   iN[i]  - CGFloat(i)*W/c
        x *= (F(k_) / H)
        x += CGFloat(i)*W/c
        
        x = x +  W/(2*c) + F(k_)*(d-W/c)/(2.0*H)
        
        return x
    }
    
    
    func linearNoCenter ( _ i : Int , _ k : Int) -> CGFloat{
        let k_ : CGFloat = CGFloat(k)
        let c : CGFloat = CGFloat(nColumns)
        
        var x : CGFloat =   iN[i]  - CGFloat(i)*W/c
        x *= (F(k_) / H)
        x += CGFloat(i)*W/c
      
        return x
    }
    
    
    
    /**
     function de [0 nRows] --->[h 0]
     */
//    func F(_ k : CGFloat) -> CGFloat {
//        let p : CGFloat = 2.0
//        let nRowsf = pow(CGFloat(nRows), p)
//        let x = CGFloat(-H/CGFloat((nRowsf))) * CGFloat(pow(CGFloat(k),p)-nRowsf)
//        return x
//    }

    
    
    func F(_ k : CGFloat) -> CGFloat {
        let f = factor
        let h0 = size0.height
        let a = H - h0 * pow(f,CGFloat(nRows-1)) * ( pow(1.0/f, k) - 1.0 ) / ( 1.0/f - 1.0)
        return a
    }
    
    
    
    /**
     function de [0 nRows] --->[d   W/3]
     */
    
    
    func G(_ k: CGFloat) -> CGFloat {
        return  bSize + (fSize - bSize) * CGFloat(k)/CGFloat(nRows)
    }
    
//    func getFrame(i: Int , j: Int) -> (CGSize, CGPoint) {
//        let obj = getObj(i, j)
//        return (obj.size, obj.center)
//    }
    
    func getObject(i: Int , j: Int) -> UIImageView? {
        let obj = getObj(i, j)
        return obj.view
    }
    
    
    
    
    /**
     completion : la methode à effectuer en cas de sortie d'une piece de l'ecran
     */
    func movedown(){
        
        //suppression de la derniere ligne
        for i in  iMin...iMax {
            let obj = getObj(i, nRows)
            if obj.getType() != _EMPTY_ {
                    obj.view?.isHidden = true
            }
        }
        
        //decalage des case vers le bas
        for i in iMin...iMax {
            var j = nRows-1
            while(j>=0)
            {
                let obj = getObj(i, j+1)
                let prevObj = getObj(i, j)
                
                obj.view = prevObj.view
                obj.type = prevObj.type
                
                
                //TODO CE CODE NE DEVRAIT PAS ETRE DS LE MODEL
              
                UIView.animate(withDuration: DURATION, delay: 0, options: .curveLinear, animations:  {
                    prevObj.view?.center = obj.center!
                    prevObj.view?.frame.size = obj.size!
                }, completion: {_ in
                            
                    let view = obj.view
                    view?.frame = CGRect(origin: CGPoint(), size: obj.size!)
                    view?.center = obj.center!
                    
                    
                           })

                
                j -= 1
            }
            
        }
        
        //Creation d'une ligne vide et insertion au debut de la grille
        for i in iMin...iMax {
            let obj = roadGrid[i]
            obj.view = nil
            obj.type = _EMPTY_
        }
    }
   

    
    func addObj(_ img: UIImageView, type : TypeOfObject,  i:Int , j : Int) -> Frame{
        let obj = getObj(i, j)
        img.frame = CGRect(origin: CGPoint(), size: obj.size!)
        img.center = obj.center!
        obj.setObj(view: img)
        obj.setType(type)
        
        return obj
    }
    
    func removeAndDelete(i:Int , j : Int, type: TypeOfObject){
        var r = removeObject(i: i, j: j, type: type)
        r.view?.isHidden = true
        r.view = nil
    }
    
    
    func removeObject(i:Int , j : Int, type: TypeOfObject)->(type: TypeOfObject, view: UIImageView?){
        //le personnage a sauté
        if i == 42 {
            return (_EMPTY_, nil)
        }
        
        let obj = getObj(i, j)
        if obj.getType() == type || type == any{
            let ret = (obj.getType(), obj.view)
            obj.setType(_EMPTY_)
            obj.view = nil
            return ret
        }
        
        return (_EMPTY_, nil)
    }
    
    func getCenter(i : Int , j: Int) -> CGPoint{
        let obj = getObj(i, j)
        return obj.center!
    }
    
    
    func generateCoin () -> [TypeOfObject]{
        if (repeatCount > 0){
            repeatCount -= 1
            return prevRandomValue
        }
        
        if(repeatCount == 0 ){
            repeatCount = Int.random(in: 1...5)
        }
        
        
        prevRandomValue = [TypeOfObject](repeating: _EMPTY_, count: nColumns-2)
        
        let r = Int.random(in: 1...nColumns-2)
        let r1 = (r+prevR)%(nColumns-2)
        prevRandomValue[r1] = _COIN_
        prevR = r1
        repeatCount -= 1
        return prevRandomValue
    }
    
    /**
     level from 1 to 10.
     */
    
    func generateNewObject(level:Int) -> [TypeOfObject]{
        let coins : [TypeOfObject] = generateCoin()
        var p = Int.random(in: 1...100)
        
        if p < 70 {
            //nothing to do
            return coins
        }
        else
        {
            p = Int.random(in: 1...100)
            var objPos : [TypeOfObject] = [TypeOfObject](repeating: _EMPTY_, count: iMax)
            let r1 = Int.random(in: 0..<iMax)
            var t : TypeOfObject
            if p < 0 {
                //creer un obstacle
                let r2 = Int.random(in: 10...12)
                t = r2
            }
            else {
                //TODO
                //ici evenement rare
                //on affiche un bonus ou autre evenement rare
                //0.3*0.3 de chance d'arriver la soit 3 chances sur 100
                let r3 = Int.random(in: coinx2...magnet)
                
                
                t = r3
            }
            objPos[r1] = t
            return objPos
        }
    }
    
    
    
    
    
    
    
    
}
