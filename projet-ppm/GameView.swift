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
    let cloud : UIImageView = UIImageView()
    
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
        
        initAnimatedView(personnage, "personnage", speed: speed)
        
   
        personnage.isHidden = true
    
        
        scoreLabel.text = "0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        scoreLabel.textColor = .black
        
        messageButton.setImage(UIImage(named: "message"), for: .normal)
        messageButton.addTarget(self.superview, action: #selector(GameViewController.seeMessage), for: .touchUpInside)
        messageButton.isHidden = true
        
        
        viewHandlingCoins.isHidden = false
        
        roadImage.contentMode = .scaleToFill
        initAnimatedView(roadImage, "chemin", speed: speed)
        
        landscapeView.backgroundColor = .green
        
        
        
        cloud.image = UIImage(named: "clouds")
        
        
        
        skyView.contentMode = .scaleToFill
        skyView.image = UIImage(named: "sky")
        skyView.backgroundColor = .blue
        skyView.addSubview(cloud)
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
  
        pauseButton.frame = CGRect(x: w-50, y: h-50, width: 50, height: 50)
        startButton.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
        counterView.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
   
        scoreLabel.frame = CGRect(x: w-100, y: 30, width: 100, height: 100)
        messageButton.frame = CGRect(x: 100, y: 30, width: 100, height: 100)
              
        cloud.frame = CGRect(x: w, y: 40, width: 100, height: 100)
        skyView.frame = CGRect(x: 0, y: 0, width: w, height: sk)
        landscapeView.frame = CGRect(x: 0, y: sk, width: w, height: rh)
        roadImage.frame = CGRect(x: 0, y: 0, width: w, height: rh)
        viewHandlingCoins.frame = UIScreen.main.bounds
        print("draw")
    }
    
    
    
    func initAnimatedView(_ o: UIImageView,  _ name: String, speed: TimeInterval){
        o.animationImages = animatedImages(for: name)
        o.animationDuration = speed
        o.animationRepeatCount = 0
        o.image = UIImage(named: name)
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
    
    func startAnimation(){
        
        UIView.animate(withDuration: 50, delay: 0, options: [.repeat , .curveLinear]) {
            self.cloud.frame.origin = CGPoint(x: -50, y: 40)
        } completion: {_ in
        }
        
        personnage.startAnimating()
        roadImage.startAnimating()
        
    }
    
    
    
    
    
}
