//
//  GameView.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit




class GameView: UIView {

    
    var personnage :UIImageView?
   
    let messageButton = UIButton()
    
    let grassLeft = UIImageView()
    let grassRight = UIImageView()
    
    let grassLeftCopy = UIImageView()
    let grassRightCopy = UIImageView()
    
    let scoreLabel = UILabel()
    
    let pauseButton = UIButton()
    let counterView = UIImageView()
    
    let widthGrass: CGFloat = 100.0
    
    
    //nombre de pieces réscoltées
    var score : Int = 0
    
    //tableau contenant les pieces affiché sur l'ecran
    var coins: [UIImageView] = [UIImageView]()
    
    //le pas d'avancement des objets vers le bas
   
    var deltaY : Int = 10
    
    override init(frame: CGRect) {
        
        
        
        super.init(frame: frame)
        self.backgroundColor = .white
       
    
       // let i = UIImage(named: "run-1")
       // personnage.image = i
       
        pauseButton.isHidden = true
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        pauseButton.addTarget(self.superview,
                              action: #selector(GameViewController.startGame),
                              for: .touchUpInside)
     
        
        personnage = createAnimatedView("personnage", position: nil, size: nil)
        personnage?.isHidden = true
        
        
        scoreLabel.text = "0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        scoreLabel.textColor = .black
        
        
        messageButton.setImage(UIImage(named: "message"), for: .normal)
        messageButton.addTarget(self.superview, action: #selector(GameViewController.seeMessage), for: .touchUpInside)
        
        addSubview(personnage!)
        addSubview(grassLeft)
        addSubview(grassRight)
        
        addSubview(grassLeftCopy)
        addSubview(grassRightCopy)
        
        addSubview(pauseButton)
        
        addSubview(counterView)
        addSubview(scoreLabel)
       
        addSubview(messageButton)
    }
    
    
    
    func initGrassImage(grassImage: UIImageView,  origin: CGPoint)  {
        
        grassImage.frame =  CGRect(origin: origin, size: CGSize(width: widthGrass, height: UIScreen.main.bounds.height))
        
        grassImage.contentMode = .scaleToFill
        //grassLeft.adjustsImageSizeForAccessibilityContentSizeCategory=false
        grassImage.image = UIImage(named: "grass")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let h = rect.height
        let w = rect.width
        
        initGrassImage(grassImage: grassLeft, origin: CGPoint(x: 0, y: 0))
        initGrassImage(grassImage: grassRight, origin: CGPoint(x: w-widthGrass, y: 0))
        
        initGrassImage(grassImage: grassLeftCopy, origin: CGPoint(x: 0, y: h))
        initGrassImage(grassImage: grassRightCopy, origin: CGPoint(x: w-widthGrass, y: h))
        
        
        pauseButton.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
        counterView.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
        
        
        personnage!.frame = CGRect(x: w/2 - 50, y:h - 300, width: 100, height: 100)
        
        
        scoreLabel.frame = CGRect(x: w-100, y: 30, width: 100, height: 100)
        messageButton.frame = CGRect(x: 100, y: 30, width: 100, height: 100)
        print("draw")
    }
    
    func createAnimatedView(_ name: String, position: CGPoint?, size: CGSize?)->UIImageView{
        let w : Int = Int(UIScreen.main.bounds.width - 2*widthGrass)
        
        var o = UIImageView()
        o.animationImages = animatedImages(for: name)
        o.animationDuration = 0.9
        o.animationRepeatCount = 0
        o.frame = CGRect(origin: position ?? CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100))
        
      //  o.startAnimating()
        
        return o
    }
    /**
     Ajoute une piece aleatoirement dans le tableau des pieces
     */
    func createCoin(){
        let w : Int = Int(UIScreen.main.bounds.width - 2*widthGrass)
        let r = Int.random(in: Int(widthGrass)...w)

        var newCoin =  createAnimatedView("coin", position: CGPoint(x: r, y: -50), size: CGSize(width: 50, height: 50))
        coins.append(newCoin)
        newCoin.startAnimating()
        addSubview(newCoin)
    }
    
    func animatedImages(for name: String) -> [UIImage] {
        
        var i = 1
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)-\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
 
 
    var c = 0
    @objc func updateView() {
        
       // print("update view")
        c += 1
        if(c>10){
            createCoin()
            c=0
        }
       
        let h : Int = Int(UIScreen.main.bounds.height)
        
        var y1 : Int = Int(grassRight.frame.origin.y)
        grassRight.frame.origin.y = CGFloat( (y1 + h + deltaY )%(2*h) - h )
        grassLeft.frame.origin.y = grassRight.frame.origin.y
        
        var y2 : Int = Int(grassRightCopy.frame.origin.y)
        grassRightCopy.frame.origin.y = CGFloat( (y2 + h + deltaY )%(2*h) - h )
        grassLeftCopy.frame.origin.y = grassRightCopy.frame.origin.y
        
        var i = 0
        while(i<coins.count) {
            var coin = coins[i]
            let o : Int = Int(coin.frame.origin.y)

            if( o > h ){
                coin.image=nil
                coins.remove(at: i)
            }
            else if (coin.frame.intersects(personnage!.frame)){
                //un point en plus
                score += 1
                
                coins.remove(at: i)
               
                print("score est: \(score)")
                
                scoreLabel.text = String(score)
                moveCoinToCorner(coin, point: scoreLabel.frame.origin)
            }
            else{
                coin.frame.origin.y += CGFloat(deltaY)
                i += 1
            }
        }
        
       // setNeedsDisplay()
    }
   
 
    
    

    
    func stopAnimation(){
        personnage?.stopAnimating()
        for coin in coins {
            coin.stopAnimating()
        }
    }
    
    func startAnimation(){
        personnage?.startAnimating()
        for coin in coins {
            coin.startAnimating()
        }
        
    }
    
    
    
    func moveCoinToCorner(_ coin : UIImageView, point : CGPoint){
        
        UIView.animate(withDuration: 1, delay: 0, options: .transitionCurlUp) {
            coin.frame.origin = point
            coin.frame.size.height = coin.frame.size.height/3.0
            coin.frame.size.width = coin.frame.size.width/3.0
            //coin.alpha = 0
        } completion: { (true) in
            //erase the coin
            coin.stopAnimating()
            coin.image=nil
            coin.isHidden = true
        }
        
        
        

    }
    
}
