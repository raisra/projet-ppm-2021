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
    
    
    var timer : Timer?
    var incTime = TimeInterval(0.1)
    
    
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
        
        
        
 
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.backgroundColor = .blue
        
       
       
        
        
        
        addSubview(test)
     
        addSubview(personnage)
        addSubview(grassLeft)
        addSubview(grassRight)
        
        addSubview(grassLeftCopy)
        addSubview(grassRightCopy)
        timer?.invalidate()
        timer=nil
        
        timer = Timer.scheduledTimer(timeInterval: incTime, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
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
    
    
    func animateBackground() {

        // Animate background
        // cityImage is the visible image
        // cityImage2 is the hidden image

        UIView.animate(withDuration: 12.0, delay: 0.0, options: [.repeat, .curveLinear], animations: {
            self.grassLeft.frame = self.grassLeft.frame.offsetBy(dx: -1 * self.grassLeft.frame.size.width, dy: 0.0)
            self.grassLeft.frame = self.grassLeft.frame.offsetBy(dx: -1 * self.grassLeft.frame.size.width, dy: 0.0)
        }, completion: nil)

    }
    
}
