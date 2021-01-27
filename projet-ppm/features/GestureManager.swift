//
//  GameGestureManager.swift
//  projet-ppm
//
//  Created by ramzi on 24/01/2021.
//

import UIKit

@objc protocol GestureManagerProtocol {
    
    @objc /*optional*/ func swipeGesture  (_ gesture: UIGestureRecognizer)
    
}

extension GestureManagerProtocol {
    func swipeGesture  (_ gesture: UIGestureRecognizer) {}
}

class GestureManager: NSObject {
    
    //var view: UIView? = nil
    
    var delegate: GestureManagerProtocol?
    
    // MARK: -
    
   

    func addSwipeGesture (to view:UIView, with directions:[UISwipeGestureRecognizer.Direction]) {
//        if self.delegate?.swipeGesture(_:) == nil {
//            print ("IL FAUT DEFINIR LA FONCTION swipe")
//            return
//        }
        
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self.delegate,
                                                   action: #selector(self.delegate?.swipeGesture(_:)))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
        
    }
    
    func removeGesture (from view: UIView) {
        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                view.removeGestureRecognizer(gesture)
            }
        }
    }
    
}
