//
//  GameView.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit




class GameView: UIView {
    
    
    let messageButton = UIButton()
    
    let grassLeft = UIImageView()
    let grassRight = UIImageView()
    
    let grassLeftCopy = UIImageView()
    let grassRightCopy = UIImageView()
    
    let scoreLabel = UILabel()
    
    let pauseButton = UIButton()
    let counterView = UIImageView()
    
    let widthGrass: CGFloat = 100.0
    
    let startButton = UIButton()
    
    //nombre de pieces réscoltées
    var score : Int = 0
    
    //tableau contenant les pieces affiché sur l'ecran
   // var coins: [UIImageView] = [UIImageView]()
    
    
    let viewHandlingCoins : UIView = UIView()
    
    
    let skyView : UIImageView = UIImageView()
    let landscapeView : UIView = UIView()
    
    
    let cloud1 : UIImageView = UIImageView()
    let cloud2 : UIImageView = UIImageView()
    let cloud3 : UIImageView = UIImageView()
    
    let roadImage : UIImageView = UIImageView()
    
    let personnage :UIImageView = UIImageView()
    
    var speed : TimeInterval = 1
    
    var sk = 0.5 * UIScreen.main.bounds.height
    var rh = 0.5 * UIScreen.main.bounds.height
    
   
     init(frame: CGRect, r : CGFloat) {
      
        
        sk = (1-r) * UIScreen.main.bounds.height
        rh = r * UIScreen.main.bounds.height
        
        super.init(frame: frame)
        self.backgroundColor = .gray
        
        // let i = UIImage(named: "run-1")
        // personnage.image = i
        
        pauseButton.isHidden = true
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        pauseButton.addTarget(self.superview,
                              action: #selector(GameViewController.pauseGame),
                              for: .touchUpInside)
        
        startButton.isHidden = false
        startButton.setImage(UIImage(named: "startButton"), for: .normal)
        startButton.addTarget(self.superview,
                              action: #selector(GameViewController.startGameForTheFistTime),
                              for: .touchUpInside)
        
        initAnimatedView(personnage, "personnage", speed: speed, animated: true)
        
   
        personnage.isHidden = true
    
        
        scoreLabel.text = "0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        scoreLabel.textColor = .black
        
        messageButton.setImage(UIImage(named: "message"), for: .normal)
        messageButton.addTarget(self.superview, action: #selector(GameViewController.seeMessage), for: .touchUpInside)
        messageButton.isHidden = true
        
        
        viewHandlingCoins.isHidden = false
        
        roadImage.contentMode = .scaleToFill
        initAnimatedView(roadImage, "riviere", speed: speed, animated: false)
        
        landscapeView.backgroundColor = .green
        
        
        
        cloud1.image = UIImage(named: "nuage1")
        cloud2.image = UIImage(named: "nuage2")
        cloud3.image = UIImage(named: "nuage3")
        
        
        skyView.contentMode = .scaleToFill
        skyView.image = UIImage(named: "ciel")
        skyView.backgroundColor = .blue
        
        skyView.addSubview(cloud1)
        skyView.addSubview(cloud2)
        skyView.addSubview(cloud3)
        
        addSubview(skyView)
        
        landscapeView.addSubview(roadImage)
        addSubview(landscapeView)
        addSubview(viewHandlingCoins)
        
 
        addSubview(personnage)
        addSubview(pauseButton)
        
        addSubview(counterView)
        addSubview(scoreLabel)
        
        addSubview(messageButton)
        addSubview(startButton)
        
    }
    
    
    func initPersonnage(position : CGPoint , size : CGSize)  {
        personnage.frame = CGRect(origin: CGPoint(), size: size)
        personnage.center = position
    }
    
    
    func setSpeed(speed: TimeInterval)  {
        self.speed = speed
        
        personnage.animationDuration = speed
        roadImage.animationDuration = speed
    }
    

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        let h = rect.height
        let w = rect.width
  
        pauseButton.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
        startButton.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
        counterView.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
   
        scoreLabel.frame = CGRect(x: w-100, y: 30, width: 100, height: 100)
        messageButton.frame = CGRect(x: 100, y: 30, width: 100, height: 100)
              
        cloud1.frame = CGRect(x: w, y: 40, width: 100, height: 100)
        cloud2.frame = CGRect(x: w/2, y: 40, width: 100, height: 100)
        cloud3.frame = CGRect(x: w/3, y: 40, width: 200, height: 100)
        
        
        skyView.frame = CGRect(x: 0, y: 0, width: w, height: sk)
        landscapeView.frame = CGRect(x: 0, y: sk, width: w, height: rh)
        roadImage.frame = CGRect(x: 0, y: 0, width: w, height: rh)
        viewHandlingCoins.frame = UIScreen.main.bounds
        print("draw")
    }
    
    
    
    func initAnimatedView(_ o: UIImageView,  _ name: String, speed: TimeInterval, animated : Bool){
        o.image = UIImage(named: name)
        
        if(animated){
            o.animationImages = animatedImages(for: name)
            o.animationDuration = speed
            o.animationRepeatCount = 0
            o.startAnimating()
        }
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
    
    

    func stopAnimation(){
        personnage.stopAnimating()
        roadImage.stopAnimating()
    }
    
    
    func getScore()->Int {
        return score
    }
    
    func setScore(score: Int){
        self.score = score
        self.scoreLabel.text = String(score)
    }
    
    
    
}
