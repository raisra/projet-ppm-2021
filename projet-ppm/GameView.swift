//
//  GameView.swift
//  projet-ppm
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit




class GameView: UIView {
    
    let test : UILabel = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    let back = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        test.text = "This is the game view"
        
        back.setTitle("back", for: .normal)
        back.setTitleColor(.black, for: .normal)
        back.addTarget(self.superview, action: #selector(GameViewController.backAction), for: .touchUpInside)
        back.frame = CGRect(x: 100, y: 200, width: 100, height: 100)
        addSubview(test)
        addSubview(back)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
    }
}
