//
//  GameView.swift
//  projet-ppm
//
//  Description : gestion image perso, road, animation jump/run.
//

import Foundation
import UIKit


let JUMP_DURATION : TimeInterval = 1.0
let BLINK_DURATION : TimeInterval = 0.5
let MOVE_DURATION : TimeInterval = 1.0
let TRANSPARENCY_DURATION : TimeInterval = 3.0


class GameView: UIView {
    
    let floor = UIImageView()
    let roadImage : UIImageView = UIImageView()
   
    let character : UIImageView = UIImageView()
    let blurr : UIImageView = UIImageView()
    
    var animationsJump = [UIImage]()
    var animationsRunning = [UIImage]()
    
    // la vue contenant tous les objets
    let objectsView : UIView = UIView()
    
    //ajout de flou
    let gradientLayer : CAGradientLayer = {

        let initialColor : CGColor = UIColor.blue.cgColor
        let fincalColor : CGColor = CGColor.init(red: 0, green: 0.2, blue: 0.7, alpha: 0)

        let gradientLayer =  CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [initialColor, fincalColor]
        gradientLayer.locations = [0, 0.7]
        gradientLayer.frame = UIScreen.main.bounds
        

        return gradientLayer
    }()
    
    var speed : TimeInterval
    
    
     init(frame: CGRect, s: TimeInterval, position : CGPoint , sizeOfChar : CGSize) {
        self.speed = s
        super.init(frame: frame)
        roadImage.contentMode = .scaleToFill
        
        
        animationsJump = GameView.animatedImages(for: "jump")
        animationsRunning = GameView.animatedImages(for: "run")
        GameView.initView(character, "run", speed: speed, animated: true)
        
        
        roadImage.frame = frame
        blurr.frame = frame
        initPersonnage(position: position, size: sizeOfChar)
        
       
        addSubview(objectsView)
        addSubview(character)
        
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    static func initView(_ o: UIImageView,  _ name: String, speed: TimeInterval = 0, animated : Bool = false){
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
    
    
    static private func animatedImages(for name: String) -> [UIImage] {
        var i = 1
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)-\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    

    func animationForJump() {
        character.stopAnimating()
        character.animationImages = animationsJump
        character.animationDuration = JUMP_DURATION
        character.animationRepeatCount = 1
        character.startAnimating()
    }

    
    func animationForRunning() {
        character.stopAnimating()
        character.animationImages = animationsRunning
        character.animationDuration = speed
        character.animationRepeatCount = 0
        character.startAnimating()
    }
    
    func animationForTransparency() {
        UIView.animate(withDuration: TRANSPARENCY_DURATION, delay: 0, options: [.allowAnimatedContent] ) {
            self.character.alpha = 0.2
        }completion: { (_) in
            self.character.alpha = 1
        }
    }

    
    func animateBlink() {
        UIView.animate(withDuration: BLINK_DURATION, delay: 0, options: [.allowAnimatedContent, .autoreverse] ) {
            self.character.alpha = 0.5
        } completion: { (_) in
            self.character.alpha = 1
        }
    }
    
    func animationMove(to position : CGPoint) {
        UIView.animate(withDuration: MOVE_DURATION , delay : 0, options : [.allowAnimatedContent, .curveEaseOut],  animations: {
            self.character.center = position
        }, completion: {(_) in
            self.character.center = position
        } )

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









