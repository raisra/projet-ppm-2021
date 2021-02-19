//
//  HumanInterfaceController.swift
//  projet-ppm
//
//  Created by ramzi on 07/02/2021.
//

import Foundation
import UIKit




class UserInterfaceView : UIView {
    
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var backToMainButton: UIButton!
    
    var counterView : UIImageView

    //nombre de pieces réscoltées
    var score : Int = 0
    
    let h = UIScreen.main.bounds.height
    let w = UIScreen.main.bounds.width
    
    
    //le nombre de pouvoirs
    var nbPower : Int = 0
    var powerAnchor : CGPoint = CGPoint(x: 0, y: 200)
    let sizeOfPowerIcons : CGSize  = CGSize(width: 10, height: 10)
    

    let nibName = "UserInterfaceView"
    
    var view : UserInterfaceView?
    
    override init(frame: CGRect) {
        
        counterView = UIImageView()
       
        
        super.init(frame: frame)
        view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! UserInterfaceView
        view?.frame = self.bounds

        pauseButton = view!.pauseButton
        startButton = view!.startButton
        messageButton = view!.messageButton
        scoreLabel = view!.scoreLabel
        backToMainButton = view!.backToMainButton
        
        pauseButton.isHidden = true
        startButton.isHidden = true
        messageButton.isHidden = true
        scoreLabel.text = "Score: 0"
 
        addSubview(view!)
        addSubview(counterView)
    }
    
    required init?(coder: NSCoder) {
        counterView = UIImageView()
        super.init(coder: coder)
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
        
    
        UIView.animate(withDuration: 1, delay: 0, options : [],
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
                        powerView.isHidden = true
                       })
        
    }
    
    
    func resetPower() {
          powerAnchor.y -= (sizeOfPowerIcons.height * CGFloat(nbPower))
          nbPower = 0
        setScore(score: 0)
      }
    
    
    
    
    
    func startTheGame(){
        scoreLabel.isHidden = false
        messageButton.isHidden = false
        

        startButton.isHidden = true
        pauseButton.isHidden = false
    }

    func stopTheGame(){
       // scoreLabel.isHidden = true
        startButton.isHidden = true
       // messageButton.isHidden = true
        

        startButton.isHidden = false
        pauseButton.isHidden = true
    }
    
    
    func showCounter() {
        startButton.isHidden = true
        counterView.isHidden = false
    }
    
    func hideCounter() {
        startButton.isHidden = false
        counterView.isHidden = true
    }
    
    
    
}
