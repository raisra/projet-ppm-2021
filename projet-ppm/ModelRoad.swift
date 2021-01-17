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

enum TypeOfObject {
    case character
    case coin
    case barrier
    case empty
}


class ModelRoad {

    var i0 : CGFloat = 0
    var i1 : CGFloat = 0
    var i2 : CGFloat = 0
    
    var N : Int = 0
    var D : CGFloat = 0
    var d : CGFloat = 0
    
    var road : [[frame]]
    var W : CGFloat
    var H : CGFloat
    
    
    var bSize : CGFloat = 10.0
    var fSize : CGFloat = 100.0
  
    
    
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
        
        for k in 0...N {
            var ligne = [frame]()
            let kk = CGFloat(k)
            for i in 0...2 {
//                var x : CGFloat =  (F(kk) / H) * (i0 + CGFloat(i) * d - CGFloat(i)*W/3.0) + CGFloat(i)*W/3.0
//                x = x +  (d + (W/3.0 - d) * kk/CGFloat(N))/2.0
                var x : CGFloat =   (i0+d*CGFloat(i)  - CGFloat(i)*W/3.0)
                    x *= (F(kk) / H)
                x += CGFloat(i)*W/3.0
                
                x = x +  W/6.0 + F(kk)*(d-W/3.0)/(2.0*H)
                
                
                let y : CGFloat = UIScreen.main.bounds.height - F(kk)

                let o = CGPoint(x: x, y: y)
                let s = CGSize(width: G(kk), height: G(kk))
                
                
                ligne.append(frame(size: s, center: o, imagesToDisplay: [(TypeOfObject, UIImageView)]()))
            }
            road.append(ligne)
        }
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
    
    func getImages(i: Int , j: Int) -> [(TypeOfObject,UIView)] {
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
                    let s = String(UInt(bitPattern: ObjectIdentifier(im.1)))
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
            
            for im in road[0][i].imagesToDisplay {
                road[0][i].imagesToDisplay.removeAll()
            }
            
            
        }
    }
    
    
    func addImage(_ img: UIImageView, type : TypeOfObject,  i:Int , j : Int) {
        img.frame = CGRect(origin: CGPoint(), size: road[j+1][i].size)
        img.center = road[j][i].center
        road[j][i].imagesToDisplay.append((type, img))
    }
    
    
    func removeCoin(i:Int , j : Int)->UIImageView?{
        for k in 0..<road[j][i].imagesToDisplay.count{
            let (t,_)=road[j][i].imagesToDisplay[k]
            
            if t == .coin {
                let r = road[j][i].imagesToDisplay.remove(at: k)
                
                let s = String(UInt(bitPattern: ObjectIdentifier(r.1)))
                //print("coin collapsed so move it to corner \(s)")
                
                return r.1
            }
        }
        return nil
    }
    
    func getCenter(i : Int , j: Int) -> CGPoint{
        return road[j][i].center
    }
    
}
