//
//  GameGestureManager.swift
//  projet-ppm
//
//  Created by ramzi on 24/01/2021.
//

import UIKit

protocol GestureManagerProtocol {
    
    func moveRight()

    func moveLeft()

    func moveUp()
    
    func moveDown()
    
    func tapeTwice()
    
    func longTape()
}


extension GestureManagerProtocol {
    func moveRight(){}

    func moveLeft() {}

    func moveUp() {}
    
    func moveDown() {}
    
    func tapeTwice() {}
    
    func longTape() {}
}


class GestureManager  {

    var delegate : GestureManagerProtocol?
    
    init(forView: UIView) {
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapeTwoTimes))
        tap.numberOfTapsRequired = 2
        

        let pressAcc = UILongPressGestureRecognizer(target: self, action:#selector(pressAccelerateFunc))
        pressAcc.minimumPressDuration = 1.5
       

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector (swipeDirectionFunc(sender:)))
        swipeLeft.direction = .left

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeDirectionFunc(sender:)))
        swipeRight.direction = .right

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector( swipeDirectionFunc(sender:)))
        swipeUp.direction = .up

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector( swipeDirectionFunc(sender:)))
        swipeDown.direction = .down
        
        

        
        forView.addGestureRecognizer(swipeLeft)
        forView.addGestureRecognizer(swipeRight)
        forView.addGestureRecognizer(swipeUp)
        forView.addGestureRecognizer(swipeDown)
        forView.addGestureRecognizer(tap)
        forView.addGestureRecognizer(pressAcc)
    }
    
 
    
    func removeGesture (from view: UIView) {
        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    
    
    @objc func tapeTwoTimes (){
        delegate?.tapeTwice()
    }
    

    @objc func pressAccelerateFunc () {
        delegate?.longTape();
    }
    
    
    @objc func swipeDirectionFunc (sender : UISwipeGestureRecognizer){
        if sender.direction == .right {
            print("going right")
            delegate?.moveRight()
        }
        if sender.direction == .left {
            print("going left")
            delegate?.moveLeft()

        }
        if sender.direction == .up {
            print("going up")
            delegate?.moveUp()
        }
        if sender.direction == .down {
            print("going down")
            delegate?.moveDown()

        }
    }
    
    
    
}
