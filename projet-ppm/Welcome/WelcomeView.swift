//
//  WelcomeView.swift
//  projet-ppm
//
// Desccription : Image d'acceuil : choix niveaux et boutton play.
//

import Foundation


import UIKit
class WelcomeView : UIView{

    let playButton = UIButton()
    let settingsButton = UIButton()
    let scoreButton : UIButton = UIButton()
    let chatButton : UIButton = UIButton()
    
    override init(frame: CGRect) {
    
        super.init(frame: frame)
        self.backgroundColor = .white
      
        playButton.setImage(UIImage(named: "playButton"), for: .normal)
        playButton.addTarget(self.superview, action: #selector(WelcomeViewController.startGame), for: .touchUpInside)
        addSubview(playButton)
        
       
        settingsButton.setImage(UIImage(named: "settings"), for: .normal)
        settingsButton.addTarget(self.superview, action: #selector(WelcomeViewController.settingsButtonSelector), for: .touchUpInside)
        
        
        self.initialiseButton(button: chatButton,
                              title: "chat",
                              sel: #selector(WelcomeViewController.chatButtonSelector))
        
        
        self.initialiseButton(button: scoreButton,
                              title: "scores",
                              sel: #selector(WelcomeViewController.scoreButtonSelector))
        
        
        
        addSubview(playButton)
        addSubview(settingsButton)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialiseButton(button: UIButton, title:String, sel:Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .cyan
        
        button.titleLabel?.shadowOffset = CGSize(width: 0, height: 1)
        button.setTitleShadowColor(.black, for: .normal)
        button.setTitleShadowColor(.clear, for: .highlighted)
        
        if button.isKind(of: UIButton.self) {
            button.setTitleColor(.gray, for: .disabled)          // for enabled state
            button.setTitleShadowColor(.clear, for: .disabled)   // for enabled state
        }
        let fontMarker = UIFont(name: "Marker Felt Wide", size: 25)
        let fontAcadamy = UIFont(name: "Academy Engraved LET", size: 25)
        let fontBold = UIFont.boldSystemFont(ofSize: 25)
        button.titleLabel?.font =  fontMarker
 
        button.addTarget(self.superview, action: sel, for: .touchUpInside)
        addSubview(button)
    }
   
    
        
    func drawButton(button: UIButton, below aboveButton :UIButton, offset:CGFloat = 10.0, shadow : Bool = true) {
        let (width, height):(CGFloat, CGFloat) = (130.0, 50.0)
        button.frame    = CGRect(x: 0, y: 0, width: width, height: height)
        button.center   = CGPoint(x: self.center.x,
                                  y: aboveButton.center.y + height + offset)
        if shadow {
            self.addShadow(vue: button)
        }
       
    }
    
    
    func addShadow(vue: UIView,
                        _ offset:CGSize = CGSize(width: 0, height: 2),
                        _ opacity: Float = 0.5,
                        _ isBborder: Bool = true)
    {
        
        vue.layer.borderWidth = isBborder ? 1 : 0
        vue.layer.cornerRadius = 5
        vue.layer.shadowPath = UIBezierPath(rect: vue.bounds).cgPath
        vue.layer.shadowRadius = 2
        vue.layer.shadowOffset = .init(width: offset.width, height: offset.height)
        vue.layer.shadowOpacity = opacity
    }
   
    

    
    override func draw(_ rect: CGRect) {
       
        //print (rect.debugDescription)
        //print (self.bounds.debugDescription)
        //playButton.backgroundColor = .systemGreen
        playButton.frame    = CGRect(x: 0, y: 0, width: 130, height: 46)
        playButton.center   = self.center
        playButton.center.y = rect.height * 1 / 3
        
        self.drawButton(button: settingsButton, below: playButton, shadow: false)
        self.drawButton(button: scoreButton, below: settingsButton)
        self.drawButton(button: chatButton, below: scoreButton)
    }
    
    
}
