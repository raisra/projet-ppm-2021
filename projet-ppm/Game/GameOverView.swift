//
//  GameOverView.swift
//  projet-ppm
//
//  Created by jihane on 30/01/2021.
//

import Foundation

import Foundation
import UIKit


class GameOverView: UIView {
    
    let restartButton = UIButton()
    let GameOver = UIImageView()
    
    let h = UIScreen.main.bounds.height
    let w = UIScreen.main.bounds.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white

        restartButton.setImage(UIImage(named: "restart"), for: .normal)
        restartButton.setTitleColor(.black, for: .normal)
        restartButton.addTarget(self.superview, action: #selector(WelcomeViewController.RestartGame), for: .touchUpInside)
        
        GameOver.image = UIImage(named: "gameover")
        GameOver.alpha = 1
        GameOver.frame.origin = CGPoint(x: w/2, y: h/2)
        GameOver.frame.size = CGSize(width: 500, height: 400)
        
        self.addSubview(restartButton)
        self.addSubview(GameOver)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let h = rect.height
        let w = rect.width
        
        GameOver.frame = CGRect(x: w/2 - 250, y: h/2-350, width: 500, height: 400)
        restartButton.frame = CGRect(x: w/2-100, y: h/2+200, width: 200, height: 200)
        
    }
    
}

