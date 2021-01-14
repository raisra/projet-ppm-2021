//
//  WelcomeView.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import Foundation


import UIKit
class WelcomeView : UIView{
    let title = UILabel()
    let playButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        title.text = "Jeu de course"
        title.textAlignment = .center
        
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.addTarget(self.superview, action: #selector(WelcomeViewController.startGame), for: .touchUpInside)

        
        addSubview(title)
        addSubview(playButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func draw(_ rect: CGRect) {
        
        let h = rect.height
        let w = rect.width
        
        title.frame = CGRect(x: w/2-50, y: h/2, width: 100, height: 30)
        
        playButton.frame = CGRect(x: w/2-50, y: h - 30, width: 100, height: 30)
    }
    
    
 
    
    
    
}
