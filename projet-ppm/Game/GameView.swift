//
//  GameView.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit





class GameView: UIView {
    
    let floor = UIImageView()
    let roadImage : UIImageView = UIImageView()
    let backGround : UIImageView = UIImageView()
    let character : UIImageView = UIImageView()
    let blurr : UIImageView = UIImageView()
    
    
    // la vue contenant tous les objets
    let objectsView : UIView = UIView()
    
//    //ajout de flou
//    let gradientLayer : CAGradientLayer = {
//
//        let initialColor : CGColor = UIColor.black.cgColor
//        let fincalColor : CGColor = CGColor.init(gray: 1, alpha: 0 )
//
//        let gradientLayer =  CAGradientLayer()
//        gradientLayer.type = .axial
//        gradientLayer.colors = [initialColor, fincalColor]
//        gradientLayer.locations = [0, 1]
//        gradientLayer.frame = UIScreen.main.bounds
//
//        return gradientLayer
//    }()
    
    var speed : TimeInterval
    
    
     init(frame: CGRect, s: TimeInterval, position : CGPoint , size : CGSize) {
        self.speed = s
        super.init(frame: frame)
        roadImage.contentMode = .scaleToFill
        
        
        initView(roadImage, "magic-road", speed: speed, animated: true)
        initView(backGround, "aboveTheSky")
        initView(blurr, "blurr")
        initView(character, "personnage", speed: speed, animated: true)
        
        backGround.frame = frame
        roadImage.frame = frame
        blurr.frame = frame
        initPersonnage(position: position, size: size)
        
        addSubview(backGround)
        addSubview(roadImage)
        addSubview(character)
        addSubview(objectsView)
        addSubview(blurr)
        
//        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func initView(_ o: UIImageView,  _ name: String, speed: TimeInterval = 0, animated : Bool = false){
        if(animated){
            o.animationImages = animatedImages(for: name)
            o.animationDuration = speed
            o.animationRepeatCount = 0
            o.startAnimating()
        }
        else {
            o.image = UIImage(named: name)
        }
    }
    
    
    private func animatedImages(for name: String) -> [UIImage] {
        var i = 1
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)-\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }

    
    private func initPersonnage(position : CGPoint , size : CGSize)  {
        character.frame = CGRect(origin: CGPoint(), size: size)
        character.center = position
        character.isHidden = true
    }
    
    
    func setSpeed(speed: TimeInterval)  {
        self.speed = speed
        character.animationDuration = speed
        //TODO changer la vitesse du ciel
    }
    
    
    func startAnimation(){
        
        character.startAnimating()
        
        UIView.animate(withDuration: speed*200, delay: 0, options: [.repeat] ,
                       animations : {
                        self.backGround.frame.origin.y += 500
        },
        completion: nil)
        
        //TODO animation de la route

    }
    
    
    func stopAnimation(){
        character.stopAnimating()
    }
 
    
    func hideCharacter()  {
        character.isHidden = true
    }
    
    func showCharacter(){
        character.isHidden = false
    }
    
    
}









