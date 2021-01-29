//
//  WelcomeView.swift
//  projet-ppm
//
// Desccription : Image d'acceuil : choix niveaux et boutton play.
//

import Foundation


import UIKit
class WelcomeView : UIView{
    let title = UILabel()
    let playButton = UIButton()
    let levels = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        title.text = "Jeu de course"
        title.textAlignment = .center
        
       // playButton.setTitle("Play", for: .normal)
        playButton.setImage(UIImage(named: "playButton"), for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.addTarget(self.superview, action: #selector(WelcomeViewController.startGame), for: .touchUpInside)
        
        levels.setImage(UIImage(named: "playButton"), for: .normal)
        levels.setTitleColor(.black, for: .normal)
        levels.addTarget(self.superview, action: #selector(WelcomeViewController.levelChoices), for: .touchUpInside)

        addSubview(title)
        addSubview(playButton)
        addSubview(levels)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func draw(_ rect: CGRect) {
        
        let h = rect.height
        let w = rect.width
        
        title.frame = CGRect(x: w/2-50, y: h/2, width: 100, height: 30)
        
        playButton.frame = CGRect(x: w/2-100, y: h/2-50, width: 200, height: 100)
        
        levels.frame = CGRect(x: w/2-100, y: h/2-250, width: 200, height: 100)
    }
    
    
 
    
    
    
}
