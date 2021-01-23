//
//  HumanInterface.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import Foundation
import UIKit


class HumanInterface: UIView {
    
    let messageButton = UIButton()
    let scoreLabel = UILabel()
    
    let pauseButton = UIButton()
    let counterView = UIImageView()
    
    let startButton = UIButton()
    
    //nombre de pieces réscoltées
    var score : Int = 0
    
    let h = UIScreen.main.bounds.height
    let w = UIScreen.main.bounds.width
    
    
    //le nombre de pouvoirs
    var nbPower : Int = 0
    var powerAnchor : CGPoint = CGPoint(x: 0, y: 200)
    let sizeOfPowerIcons : CGSize  = CGSize(width: 200, height: 200)
    
    //TODO A REMPLACER par les irecognizer
    let droite = setButton(title: ">>>>", posx: UIScreen.main.bounds.width-100, posy: 50)
    let gauche = setButton(title: "<<<<", posx: 10, posy: 50)
    let saute = setButton(title: "Sauter", posx: UIScreen.main.bounds.width/2, posy: 300)
    let baisse = setButton(title: "BAisser", posx: UIScreen.main.bounds.width/2, posy: 400)
    let accelerate = setButton(title: "x10", posx: 400, posy: 600)
    
    /**
        bouton pour simuler le deplacement du character
     */
    
    static func setButton(title: String, posx: CGFloat, posy : CGFloat) -> UIButton {
        let b = UIButton()
        b.frame = CGRect(x: posx, y: posy, width: 50, height: 50)
        b.setTitle(title, for: .normal)
        b.setTitleColor(.black, for: .normal)
        
        return b
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pauseButton.isHidden = true
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        pauseButton.addTarget(self.superview,
                              action: #selector(GameViewController.pauseGame),
                              for: .touchUpInside)
        
        startButton.setImage(UIImage(named: "startButton"), for: .normal)
        startButton.addTarget(self.superview,
                              action: #selector(GameViewController.startGame),
                              for: .touchUpInside)
        
        
        scoreLabel.text = "0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        scoreLabel.textColor = .black
        
        messageButton.setImage(UIImage(named: "message"), for: .normal)
        messageButton.addTarget(self.superview, action: #selector(GameViewController.seeMessage), for: .touchUpInside)
        messageButton.isHidden = true
        
        
        addSubview(pauseButton)
        addSubview(counterView)
        addSubview(scoreLabel)
        addSubview(messageButton)
        addSubview(startButton)
        
        
        //TODO A SUPPRIMER QUAND ON utilisera gesture recognizer
        droite.addTarget(self.superview, action: #selector(GameViewController.movePersonnage(sender:)), for: .touchUpInside)
        gauche.addTarget(self.superview, action: #selector(GameViewController.movePersonnage(sender:)), for: .touchUpInside)
        saute.addTarget(self.superview, action: #selector(GameViewController.movePersonnage(sender:)), for: .touchUpInside)
        baisse.addTarget(self.superview, action: #selector(GameViewController.movePersonnage(sender:)), for: .touchUpInside)
        accelerate.addTarget(self.superview, action: #selector(GameViewController.movePersonnage(sender:)), for: .touchUpInside)
        
        addSubview(gauche)
        addSubview(droite)
        addSubview(baisse)
        addSubview(saute)
        addSubview(accelerate)
        
        //////////////////////////////////////////////
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func draw(_ rect: CGRect) {
        pauseButton.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
        startButton.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
        counterView.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
   
        scoreLabel.frame = CGRect(x: w-100, y: 30, width: 100, height: 100)
        messageButton.frame = CGRect(x: 100, y: 30, width: 100, height: 100)
    }
    
    
    
    func getScore()->Int {
        return score
    }
    
    func setScore(score: Int){
        self.score = score
        self.scoreLabel.text = String(score)
    }
    
    func addScore(_ score: Int){
        self.score += score
        self.scoreLabel.text = String(self.score)
    }
    
    func animationForNumber(imageName: Int, callback: @escaping ()->Void) {
        
        if(imageName>3){
            print("start the game from callback")
            callback()
            return
        }
        
        
        let h = UIScreen.main.bounds.height
        let w = UIScreen.main.bounds.width
        
        counterView.image = UIImage(named: String(imageName))
        counterView.alpha = 1
        counterView.frame.origin = CGPoint(x: w/2-50, y: h/2-50)
        counterView.frame.size = CGSize(width: 100, height: 100)
        
        
        UIView.animate(withDuration: 1,
                       animations: {
                        print("animation \(imageName)")
                        
                        self.counterView.alpha = 0
                        self.counterView.frame.origin = CGPoint(x: w/2-100, y: h/2-100)
                        self.counterView.frame.size = CGSize(width: 200, height: 200)
                        
                       }, completion: {(true) in
                        
                        self.animationForNumber(imageName: imageName + 1, callback: callback)
                        
                       })
    }
    
    
    func addPower(powerView : UIImageView, duration : TimeInterval){
        powerView.isHidden = false
        powerView.frame.origin = self.powerAnchor
        powerView.frame.size = self.sizeOfPowerIcons
        
        nbPower += 1
        powerAnchor.y += self.sizeOfPowerIcons.height
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations:
                        {
                            powerView.alpha = 0
                        },
                       completion: {(Bool) in
                        print("---------------completion done")
                        self.nbPower -= 1
                        self.powerAnchor.y -= self.sizeOfPowerIcons.height
                        self.isHidden = true
                       })
        
    }
    
}