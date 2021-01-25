//
//  ModelRoad.swift
//  projet-ppm
//
//  Created by ramzi on 16/01/2021.
//

import Foundation
import  UIKit





enum TypeOfObject: Int {
    //case character = 0
    case coin = 0
    case empty = 1
    
    
    case barrier = 10
    case wall = 11
    case water = 12
    
    
    case coinx2 = 20
    case coinx5 = 21
    case magnet = 22
    
    case power = 30
    case transparency = 31
    case turbo = 32 //accelere
    case teleportation = 33 // le personnage disparait pendant que le jeu accelere puis il reapparait 
    
    
    case malus = 40
    case inversion = 41 //les pieces echanges de colonnes
    
    case any = -1
}


class ModelRoad {
    
    var i0 : CGFloat = 0
    var i1 : CGFloat = 0
    var i2 : CGFloat = 0
    
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
    
    
    let data: [CGFloat] = [
        
        372.500001015, 372.50001624, 372.500082215, 372.50025983999996, 372.500634375, 372.50131544000004, 372.502437015, 372.50415744, 372.506659415, 372.51015, 372.51486061500003, 372.52104704, 372.528989415, 372.53899223999997, 372.551384375, 372.56651904, 372.584773815, 372.60655064, 372.632275815, 372.6624, 372.697398215, 372.73776984, 372.78403861500004, 372.83675264, 372.896484375, 372.96383064, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 372.6711989583334, 372.5, 372.38045711833337, 371.95896832, 371.61154523875, 370.984375, 370.29998765166664, 369.61806464, 368.7367426775, 367.90204862, 367.35453875, 366.52158387199995, 365.942790782, 365.01650787200003, 364.04105430199996, 363.26840000000004, 361.9197070775, 361.00151422, 359.2661168775, 356.95668864, 355.0965645833333, 352.8146192533333, 350.139836555, 347.59056512, 344.7393082775, 340.88955, 337.621431355, 334.401465088, 331.68490410333334, 328.19087607999995, 323.0904947916667, 317.41217408, 311.45899015500004, 306.28915448, 299.24625419375, 289.41519999999997, 279.13410183250005, 269.07561713999996, 257.8086292949999, 244.57179903999992, 230.85891625000005, 217.184827504, 204.09218607124998, 191.28552575999993, 180.56234519374996, 171.78816249999997, 165.3446218775, 160.42917183999998, 156.09349840928573, 152.75398056000003, 149.49264866071425, 145.79132416000002, 142.64277978500002, 140.0, 139.5, 139.5,
        
        
        397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.020458923, 397.070637568, 397.126490443, 397.18843000000004, 397.256883163, 397.332291328, 397.415110363, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.42241292312497, 397.0, 396.6576450892857, 396.48757705142856, 396.0, 395.9142294514286, 395.5, 395.0, 395.0, 395.0, 395.0, 394.5, 394.5, 394.0, 394.0, 394.0, 394.0, 394.0, 394.0, 394.0, 394.0, 394.5, 395.0, 396.0, 396.7915782215, 397.0, 397.67705629, 397.67705629,
        
        422.50000051666666, 422.50000826666667, 422.50004185, 422.50013226666664, 422.5003229166667, 422.5006696, 422.50124051666666, 422.5021162666667, 422.50338985, 422.50516666666664, 422.50756451666666, 422.5107136, 422.51475651666664, 422.51984826666666, 422.52615625, 422.53386026666664, 422.5431525166667, 422.5542376, 422.5673325166667, 422.5826666666667, 422.60048185, 422.62103226666665, 422.64458451666667, 422.6714176, 422.7018229166667, 422.7361042666667, 422.77457785, 422.8175722666667, 422.86542851666667, 422.9185, 422.97715251666665, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.169, 423.9740357, 425.15332079999996, 426.5, 427.7546848, 429.3369375, 431.42867264, 433.38108506, 435.52151040000007, 437.951056325, 441.43100000000004, 447.20161479999996, 452.3089536, 457.3793961333334, 462.95838560000004, 470.650390625, 481.1341184, 491.46164064999994, 500.744456, 510.55656387500005, 522.452, 536.8896702, 550.04704032, 562.7415902, 575.733536, 587.7710625, 596.0725296, 605.1837246857142, 613.0034760000001, 618.6435336428572, 624.6922857142857, 631.3327880571429, 638.0409088, 643.2987077, 647.6773925333333, 651.0705535714286, 654.2992667428572, 655.0, 655.0, 655.0, 655.0
        
    ]
    
    
    
    
    struct Param {
        var nRows: Int
        var nColumns: Int
        var W : CGFloat
        var H: CGFloat
        var D : CGFloat
        var bSize : CGFloat = 10.0
        var fSize : CGFloat = 100.0
        var useData: Bool = false
    }
    
    
    
    init(_ p : Param) {
        self.nRows = p.nRows
        self.nColumns = p.nColumns
        
        self.W = p.W
        self.H = p.H
        
        self.D = p.D
        d = self.D/3.0
        self.bSize = p.bSize
        self.fSize = p.fSize
        
        self.i0 = (p.W - p.D)/2.0
        self.i1 = i0 + d
        self.i2 = i1 + d
        
       
        
        
        roadGrid = [Frame]()
        roadGrid.reserveCapacity(nRows*nColumns)
        
        repeatCount = 0
        prevRandomValue = [TypeOfObject](repeating: TypeOfObject.empty, count: nColumns)//utiliser colonne au lieu de 3
        prevR = 0
        
        if nRows * nColumns != data.count && p.useData == true{
            print ("ModelRoad: data non initialisé correctement")
            return
        }
        
        
        
        for k in 0..<nRows {
            let k_ = CGFloat(k)
            for i in 0..<nColumns {
                //
                let x : CGFloat
                if(p.useData){
                    x = readData(i, k)
                }
                else{
                    x = QuadraticX(i, k)
                }
                // print("k:\(k) i:\(i) center:\(x)" )
                let y : CGFloat = UIScreen.main.bounds.height - F(k_)
                
                let o = CGPoint(x: x, y: y)
                let s = CGSize(width: G(k_), height: G(k_))
                
                roadGrid.append(Frame(type: TypeOfObject.empty, view: nil, size: s, center: o))
            }
        }
        
        print(roadGrid.count)
    }
    
    func getObj(_ i: Int, _ j: Int) -> Frame {
        return roadGrid[nColumns*j + i]
    }
    
    func readData ( _ i : Int , _ j : Int) -> CGFloat{
        return data [i * (nRows) + j]
    }
    
    func linearX ( _ i : Int , _ k : Int) -> CGFloat {
        let k_ : CGFloat = CGFloat(k)
        var x : CGFloat =  (F(k_) / H) * (i0 + CGFloat(i) * d - CGFloat(i)*W/3.0) + CGFloat(i)*W/3.0
        x = x +  (d + (W/3.0 - d) * k_/CGFloat(nRows))/2.0
        return x
    }
    
    
    func QuadraticX ( _ i : Int , _ k : Int) -> CGFloat{
        let k_ : CGFloat = CGFloat(k)
        let c : CGFloat = CGFloat(nColumns)
        
        var x : CGFloat =   (i0+d*CGFloat(i)  - CGFloat(i)*W/c)
        x *= (F(k_) / H)
        x += CGFloat(i)*W/c
        
        x = x +  W/(2*c) + F(k_)*(d-W/c)/(2.0*H)
        
        return x
    }
    
    
    
    
    
    /**
     function de [0 nRows] --->[h 0]
     */
    func F(_ k : CGFloat) -> CGFloat {
        let p : CGFloat = 4.0
        let nRowsf = pow(CGFloat(nRows), p)
        return CGFloat(-H/CGFloat((nRowsf))) * CGFloat(pow(CGFloat(k),p)-nRowsf)
        
       // return CGFloat(((CGFloat(nRows) - k) * H)/CGFloat(nRows))
    }
    
    
    /**
     function de [0 nRows] --->[d   W/3]
     */
    
    
    func G(_ k: CGFloat) -> CGFloat {
        return  bSize + (fSize - bSize) * CGFloat(k)/CGFloat(nRows)
    }
    
    func getFrame(i: Int , j: Int) -> (CGSize, CGPoint) {
        let obj = getObj(i, j)
        return (obj.size, obj.center)
    }
    
    func getObject(i: Int , j: Int) -> UIImageView? {
        let obj = getObj(i, j)
        return obj.view
    }
    
    
    
    
    /**
     completion : la methode à effectuer en cas de sortie d'une piece de l'ecran
     */
    func movedown(){
        
        //suppression de la derniere ligne
        for i in 0..<nColumns {
            let obj = getObj(i, nRows-1)
            obj.view?.isHidden = true
        }
        
        //decalage des case vers le bas
        for i in 0..<nColumns {
            var j = nRows-2
            while(j>=0)
            {
                let obj = getObj(i, j+1)
                let prevObj = getObj(i, j)
                obj.view = prevObj.view
                obj.type = prevObj.type
                
                let view = obj.view
                view?.frame = CGRect(origin: CGPoint(), size: obj.size)
                view?.center = obj.center
                j -= 1
            }
            
        }
        
        //Creation d'une ligne vide et insertion au debut de la grille
        for i in 0..<nColumns {
            let obj = roadGrid[i]
            obj.view = nil
            obj.type = TypeOfObject.empty
        }
    }
    //        for i in 0..<nColumns {
    //            let im = roadGrid[nRows-1][i]
    //                im.1.isHidden = true
    //                if(im.0 == .coin){
    //                    //let s = String(UInt(bitPattern: ObjectIdentifier(im.1)))
    //                    //print("coin is out os screen so reuse it \(s)")
    //                    completion(im.1)
    //                }
    //
    //            roadGrid[nRows-1][i].imagesToDisplay.removeAll()
    //
    //            var j = nRows-2
    //            while(j>=0)
    //            {
    //                roadGrid[j+1][i].imagesToDisplay = roadGrid[j][i].imagesToDisplay
    //                for view in roadGrid[j+1][i].imagesToDisplay {
    //                    view.1.frame = CGRect(origin: CGPoint(), size: roadGrid[j+1][i].size)
    //                    view.1.center = roadGrid[j+1][i].center
    //                }
    //                j -= 1
    //            }
    //            roadGrid.
    //            for _ in roadGrid[0][i].imagesToDisplay {
    //                roadGrid[0][i].imagesToDisplay.removeAll()
    //            }
    //        }
    //    }
    
    
    func addObj(_ img: UIImageView, type : TypeOfObject,  i:Int , j : Int) {
        let obj = getObj(i, j)
        img.frame = CGRect(origin: CGPoint(), size: obj.size)
        img.center = obj.center
        obj.setObj(type: type, view: img)
    }
    
    
    func removeObject(i:Int , j : Int, type: TypeOfObject)->(type: TypeOfObject, view: UIImageView?){
        //le personnage a sauté
        if i == 42 {
            return (TypeOfObject.empty, nil)
        }
        
        let obj = getObj(i, j)
        if obj.type == type || type == .any{
            let ret = (obj.type, obj.view)
            obj.setObj(type: TypeOfObject.empty, view: nil)
            return ret
        }
        
        return (TypeOfObject.empty, nil)
    }
    
    func getCenter(i : Int , j: Int) -> CGPoint{
        let obj = getObj(i, j)
        return obj.center
    }
    
    
    func generateCoin () -> [TypeOfObject]{
        if (repeatCount > 0){
            repeatCount -= 1
            return prevRandomValue
        }
        
        if(repeatCount == 0 ){
            repeatCount = Int.random(in: 1...5)
        }
        
        prevRandomValue = [TypeOfObject.empty, TypeOfObject.empty, TypeOfObject.empty]
        
        let r = Int.random(in: 1...2)
        let r1 = (r+prevR)%nColumns
        prevRandomValue[r1] = TypeOfObject.coin
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
            var objPos : [TypeOfObject] = [TypeOfObject](repeating: TypeOfObject.empty, count: nColumns)
            let r1 = Int.random(in: 0..<nColumns)
            var t : TypeOfObject
            if p < 0 {
                //creer un obstacle
                let r2 = Int.random(in: 10...12)
                t = TypeOfObject(rawValue: r2)!
            }
            else {
                //TODO
                //ici evenement rare
                //on affiche un bonus ou autre evenement rare
                //0.3*0.3 de chance d'arriver la soit 3 chances sur 100
                let r3 = Int.random(in: TypeOfObject.coinx2.rawValue...TypeOfObject.magnet.rawValue)
                
                t = TypeOfObject(rawValue: r3)!
            }
            objPos[r1] = t
            return objPos
        }
    }
    
    
    
    
    
}
