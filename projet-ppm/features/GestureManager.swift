//
//  GameGestureManager.swift
//  projet-ppm
//
//  Created by ramzi on 24/01/2021.
//

import UIKit

protocol GestureManagerProtocol {
    
    func turnLeft()
    
    func turnRight()
    
    func jump()
}



class GestureManager  {

    var delegate : GestureManagerProtocol?
    
    init(forView: UIView) {
        
        let directions:[UISwipeGestureRecognizer.Direction] = [.left, .right, .up, .down]
        
        for direction in directions {
            
            let gesture = UISwipeGestureRecognizer(target: self,action: #selector(self.swipeGesture(_:)))
            gesture.direction = direction
            forView.addGestureRecognizer(gesture)
        }
    }
    
 
    
    func removeGesture (from view: UIView) {
        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    
    
    @objc func swipeGesture(_ gesture: UIGestureRecognizer) {
        
        let swipeGesture = gesture as! UISwipeGestureRecognizer
        
        if swipeGesture.direction == .left {
            print("move to the left")
            delegate?.turnLeft()
     
        }else if swipeGesture.direction == .right {
            print("move to right")
            delegate?.turnRight()
        }else if swipeGesture.direction == .up {
            print("move up")
            delegate?.jump()
        }
       
    }
    
}
