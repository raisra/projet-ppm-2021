//
//  GameView.swift
//  projet-ppm
//
//  Description : gestion image perso, road, animation jump/run.
//

import Foundation
import UIKit




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
    
    
     init(frame: CGRect, s: TimeInterval, centerBottom : CGPoint , sizeOfChar : CGSize) {
        self.speed = s
        super.init(frame: frame)
        roadImage.contentMode = .scaleToFill
        
        
        animationsJump = GameView.animatedImages(for: "jump")
        animationsRunning = GameView.animatedImages(for: "run")
        GameView.initView(character, "run", speed: speed, animated: true)
        
        
        roadImage.frame = frame
        blurr.frame = frame
        initPersonnage(centerBottom: centerBottom, sizeOfChar: sizeOfChar)
        
       
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
    
    public func setCharPosition(_ centerBottom : CGPoint){
        character.center = CGPoint(x: centerBottom.x , y: centerBottom.y - character.frame.size.height/2)
    }
    
    private func initPersonnage(centerBottom : CGPoint , sizeOfChar : CGSize)  {
        character.frame = CGRect(origin: CGPoint(), size: sizeOfChar)
        setCharPosition(centerBottom);
        character.isHidden = true
    }
    
    
    func setSpeed(speed: TimeInterval)  {
        self.speed = speed
        character.animationDuration = speed
    }
    
    
//    func startAnimation(){
//        character.startAnimating()
//    }
    
    
    func stopAnimation(){
        character.stopAnimating()
    }
 
    
    func hideCharacter()  {
        character.isHidden = true
    }
    
    func showCharacter(){
        character.isHidden = false
    }
    
  
    func startTheGame(){
        character.isHidden = false
        objectsView.isHidden = false
        character.startAnimating()
    }

    func stopTheGame(){
        character.isHidden = true
        objectsView.isHidden = true
        character.stopAnimating()
    }
    
}









