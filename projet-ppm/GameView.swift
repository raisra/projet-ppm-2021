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
    
    
  
    
    
    let personnage = UIImageView()
    var i = 1
    
    let grassLeft = UIImageView()
    let grassRight = UIImageView()
    
    let grassLeftCopy = UIImageView()
    let grassRightCopy = UIImageView()
    
    
    let widthGrass: CGFloat = 40.0
    
    
    let pauseButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        test.text = "This is the game view"
        
       
        
       // let i = UIImage(named: "run-1")
       // personnage.image = i
       
        pauseButton.isHidden = true
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        pauseButton.addTarget(self.superview,
                              action: #selector(GameViewController.startGame),
                              for: .touchUpInside)
        
        
        
        addSubview(test)
     
        addSubview(personnage)
        addSubview(grassLeft)
        addSubview(grassRight)
        
        addSubview(grassLeftCopy)
        addSubview(grassRightCopy)
        
        addSubview(pauseButton)
       
    }
    
    
    
    func initGrassImage(grassImage: UIImageView,  origin: CGPoint)  {
        
        grassImage.frame =  CGRect(origin: origin, size: CGSize(width: widthGrass, height: UIScreen.main.bounds.height))
        
        grassImage.contentMode = .scaleToFill
        //grassLeft.adjustsImageSizeForAccessibilityContentSizeCategory=false
        grassImage.image = UIImage(named: "grass")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let h = rect.height
        let w = rect.width
        
        initGrassImage(grassImage: grassLeft, origin: CGPoint(x: 0, y: 0))
        initGrassImage(grassImage: grassRight, origin: CGPoint(x: w-widthGrass, y: 0))
        
        initGrassImage(grassImage: grassLeftCopy, origin: CGPoint(x: 0, y: h))
        initGrassImage(grassImage: grassRightCopy, origin: CGPoint(x: w-widthGrass, y: h))
        personnage.frame = CGRect(x: 100, y:100, width: 100, height: 100)
        
        
        pauseButton.frame = CGRect(x: w/2-50, y: h/2-50, width: 100, height: 100)
    }
    
   
    @objc func updateView() {
        
        i = i%5+1
        
        personnage.image = UIImage(named: "run-\(i)")
        let h : Int = Int(UIScreen.main.bounds.height)
        
        var y1 : Int = Int(grassRight.frame.origin.y)
        grassRight.frame.origin.y = CGFloat( (y1 + h + 10)%(2*h) - h )
        grassLeft.frame.origin.y = grassRight.frame.origin.y
        
        var y2 : Int = Int(grassRightCopy.frame.origin.y)
        grassRightCopy.frame.origin.y = CGFloat( (y2 + h + 10)%(2*h) - h )
        grassLeftCopy.frame.origin.y = grassRightCopy.frame.origin.y
    }
   
    func showPauseButton() {
        pauseButton.isHidden = false
    }
    
    func hidePauseButton() {
        pauseButton.isHidden = true
    }
    
    
}
