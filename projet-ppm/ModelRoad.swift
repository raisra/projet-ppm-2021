//
//  ModelRoad.swift
//  projet-ppm
//
//  Created by ramzi on 16/01/2021.
//

import Foundation
import  UIKit

struct frame {
    var size : CGSize
    var center : CGPoint
    var imagesToDisplay : [(TypeOfObject, UIImageView)]
}

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
    
    var N : Int = 100
    var D : CGFloat = 0
    var d : CGFloat = 0
    
    var road : [[frame]]
    var W : CGFloat
    var H : CGFloat
    
    
    var bSize : CGFloat = 10.0
    var fSize : CGFloat = 100.0
    
    let Colonne : CGFloat = 3.0
    
    let data: [CGFloat] = [
        
        372.500001015, 372.50001624, 372.500082215, 372.50025983999996, 372.500634375, 372.50131544000004, 372.502437015, 372.50415744, 372.506659415, 372.51015, 372.51486061500003, 372.52104704, 372.528989415, 372.53899223999997, 372.551384375, 372.56651904, 372.584773815, 372.60655064, 372.632275815, 372.6624, 372.697398215, 372.73776984, 372.78403861500004, 372.83675264, 372.896484375, 372.96383064, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 373.0, 372.6711989583334, 372.5, 372.38045711833337, 371.95896832, 371.61154523875, 370.984375, 370.29998765166664, 369.61806464, 368.7367426775, 367.90204862, 367.35453875, 366.52158387199995, 365.942790782, 365.01650787200003, 364.04105430199996, 363.26840000000004, 361.9197070775, 361.00151422, 359.2661168775, 356.95668864, 355.0965645833333, 352.8146192533333, 350.139836555, 347.59056512, 344.7393082775, 340.88955, 337.621431355, 334.401465088, 331.68490410333334, 328.19087607999995, 323.0904947916667, 317.41217408, 311.45899015500004, 306.28915448, 299.24625419375, 289.41519999999997, 279.13410183250005, 269.07561713999996, 257.8086292949999, 244.57179903999992, 230.85891625000005, 217.184827504, 204.09218607124998, 191.28552575999993, 180.56234519374996, 171.78816249999997, 165.3446218775, 160.42917183999998, 156.09349840928573, 152.75398056000003, 149.49264866071425, 145.79132416000002, 142.64277978500002, 140.0, 139.5, 139.5,
        
        
        397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.0, 397.020458923, 397.070637568, 397.126490443, 397.18843000000004, 397.256883163, 397.332291328, 397.415110363, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.5, 397.42241292312497, 397.0, 396.6576450892857, 396.48757705142856, 396.0, 395.9142294514286, 395.5, 395.0, 395.0, 395.0, 395.0, 394.5, 394.5, 394.0, 394.0, 394.0, 394.0, 394.0, 394.0, 394.0, 394.0, 394.5, 395.0, 396.0, 396.7915782215, 397.0, 397.67705629, 397.67705629,
        
        422.50000051666666, 422.50000826666667, 422.50004185, 422.50013226666664, 422.5003229166667, 422.5006696, 422.50124051666666, 422.5021162666667, 422.50338985, 422.50516666666664, 422.50756451666666, 422.5107136, 422.51475651666664, 422.51984826666666, 422.52615625, 422.53386026666664, 422.5431525166667, 422.5542376, 422.5673325166667, 422.5826666666667, 422.60048185, 422.62103226666665, 422.64458451666667, 422.6714176, 422.7018229166667, 422.7361042666667, 422.77457785, 422.8175722666667, 422.86542851666667, 422.9185, 422.97715251666665, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.0, 423.169, 423.9740357, 425.15332079999996, 426.5, 427.7546848, 429.3369375, 431.42867264, 433.38108506, 435.52151040000007, 437.951056325, 441.43100000000004, 447.20161479999996, 452.3089536, 457.3793961333334, 462.95838560000004, 470.650390625, 481.1341184, 491.46164064999994, 500.744456, 510.55656387500005, 522.452, 536.8896702, 550.04704032, 562.7415902, 575.733536, 587.7710625, 596.0725296, 605.1837246857142, 613.0034760000001, 618.6435336428572, 624.6922857142857, 631.3327880571429, 638.0409088, 643.2987077, 647.6773925333333, 651.0705535714286, 654.2992667428572, 655.0, 655.0, 655.0, 655.0
               
    ]
    
    
    
    func readData ( _ i : Int , _ j : Int) -> CGFloat{
        return data [i * (N) + j]
    }
    
    
    func linearX ( _ i : Int , _ k : Int) -> CGFloat{
        
        //                var x : CGFloat =  (F(kk) / H) * (i0 + CGFloat(i) * d - CGFloat(i)*W/3.0) + CGFloat(i)*W/3.0
        //                x = x +  (d + (W/3.0 - d) * kk/CGFloat(N))/2.0
        
        let kk : CGFloat = CGFloat(k)
        var x : CGFloat =   (i0+d*CGFloat(i)  - CGFloat(i)*W/Colonne)
        x *= (F(kk) / H)
        x += CGFloat(i)*W/Colonne
        
        x = x +  W/6.0 + F(kk)*(d-W/Colonne)/(2.0*H)
        
        return x
        
    }
    
    
    init(N: Int, W : CGFloat, i0 : CGFloat , i3 : CGFloat, H: CGFloat, bSize : CGFloat = 10.0 , fSize : CGFloat = 100.0) {
        self.N = N
        self.W = W
        self.H = H
        
        self.bSize = bSize
        self.fSize = fSize
        
        self.i0 = i0
        
        
        D = i3 - i0
        d = D/3.0
        
        
        self.i1 = i0 + d
        self.i2 = i1 + d
        
        road = [[frame]]()
        
        for k in 0..<N {
            var ligne = [frame]()
            let kk = CGFloat(k)
            for i in 0...2 {
                
                //
                let x : CGFloat = readData(i, k)
                print("k:\(k) i:\(i) center:\(x)" )
                let y : CGFloat = UIScreen.main.bounds.height - F(kk)
                
                let o = CGPoint(x: x, y: y)
                let s = CGSize(width: G(kk), height: G(kk))
                
                
                ligne.append(frame(size: s, center: o, imagesToDisplay: [(TypeOfObject, UIImageView)]()))
            }
            road.append(ligne)
        }

        print(data.count)
    }
    
    
    /**
     function de [0 N] --->[h 0]
     */
    func F(_ k : CGFloat) -> CGFloat {
        let p : CGFloat = 4.0
        let Nf = pow(CGFloat(N), p)
        return CGFloat(-H/CGFloat((Nf))) * CGFloat(pow(CGFloat(k),p)-Nf)
        
        //return CGFloat(((CGFloat(N) - k) * H)/CGFloat(N))
    }
    
    
    /**
     function de [0 N] --->[d   W/3]
     */
    
    
    func G(_ k: CGFloat) -> CGFloat {
        return  bSize + (fSize - bSize) * CGFloat(k)/CGFloat(N)
    }
    
    func getFrame(i: Int , j: Int) -> (CGSize, CGPoint) {
        
        return (road[j][i].size, road[j][i].center)
    }
    
    func getObject(i: Int , j: Int) -> [(TypeOfObject,UIView)] {
        return road[j][i].imagesToDisplay
    }
    
    
    
    
    /**
     completion : la methode à effectuer en cas de sortie d'une piece de l'ecran
     */
    func  movedown(completion : (_: UIView)->())  {
        
        for i in 0...2 {
            
            for im in road[N-1][i].imagesToDisplay {
                im.1.isHidden = true
                if(im.0 == .coin){
                    //let s = String(UInt(bitPattern: ObjectIdentifier(im.1)))
                    //print("coin is out os screen so reuse it \(s)")
                    completion(im.1)
                }
            }
            road[N-1][i].imagesToDisplay.removeAll()
            
            var j = N-2
            while(j>=0)
            {
                road[j+1][i].imagesToDisplay = road[j][i].imagesToDisplay
                for view in road[j+1][i].imagesToDisplay {
                    view.1.frame = CGRect(origin: CGPoint(), size: road[j+1][i].size)
                    view.1.center = road[j+1][i].center
                }
                j -= 1
            }
            
            for _ in road[0][i].imagesToDisplay {
                road[0][i].imagesToDisplay.removeAll()
            }
            
            
        }
    }
    
    
    func addImage(_ img: UIImageView, type : TypeOfObject,  i:Int , j : Int) {
        img.frame = CGRect(origin: CGPoint(), size: road[j+1][i].size)
        img.center = road[j][i].center
        road[j][i].imagesToDisplay.append((type, img))
    }
    
    
    func removeObject(i:Int , j : Int, type: TypeOfObject)->(type: TypeOfObject, view: UIImageView?){
        
        //le personnage a sauté
        if i == 42 {
            return (TypeOfObject.empty, nil)
        }
        
        for (index,obj) in road[j][i].imagesToDisplay.enumerated() {
            if obj.0 == type || type == .any{
                let r = road[j][i].imagesToDisplay.remove(at: index)
                
                //let s = String(UInt(bitPattern: ObjectIdentifier(r.1)))
                //print("coin collapsed so move it to corner \(s)")
                
                return r
            }
        }
        return (TypeOfObject.empty, nil)
    }
    
    func getCenter(i : Int , j: Int) -> CGPoint{
        return road[j][i].center
    }
    
    
    
    var repeatCount = 0
    var prevRandomValue : [TypeOfObject] = [TypeOfObject](repeating: TypeOfObject.empty, count: 3)//utiliser colonne au lieu de 3
    var prevR = 0
    
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
        let r1 = (r+prevR)%3
        prevRandomValue[r1] = TypeOfObject.coin
        prevR = r1
        repeatCount -= 1
        return prevRandomValue
    }
    
    /**
        level from 1 to 10.
     */
    func generateNewObject(level:Int) -> [TypeOfObject]{
        var coins : [TypeOfObject] = generateCoin()
        let p = Int.random(in: 1...100)
        
        if p < 70 {
            //nothing to do
            return coins
        }
        else
        {
            var objPos : [TypeOfObject] = [TypeOfObject](repeating: TypeOfObject.empty, count: 3)
            let r1 = Int.random(in: 0..<(Int)(Colonne))
//            if p < 80 {
//            //creer un obstacle
//                let r2 = Int.random(in: 10...12)
//                objPos[r1] = TypeOfObject(rawValue: r2)!
//            }
//            else if p < 100 {
            objPos[r1] = TypeOfObject(rawValue: TypeOfObject.magnet.rawValue * coins[r1].rawValue)!
               
//            }
            
            return objPos
        }
    }
    

    
    
    
}
