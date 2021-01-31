//
//  MessageViewController.swift
//
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit

struct _USER {
    static let myID   = UIDevice.current.identifierForVendor?.description
    static let myUUID = UUID().uuidString
    static let myName = UIDevice.current.name
}

struct _NOTIFICATION {
    static let START_COMPTEUR       = "NOTIFICATION_START_COMPTEUR"
    static let STOP_COMPTEUR        = "NOTIFICATION_STOP_COMPTEUR"
}

struct _SERVER {
    static let adresse = "192.168.2.98"
    static let port    = "50000"
}



class MessageViewController: UIViewController{
    
    var messageView : MessageView!
    var keyBoarAlreadyAppeared: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view = MessageView(frame: UIScreen.main.bounds)
        messageView = self.view as? MessageView
        
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(backToGameView))
        recognizer.direction = [.right, .left, .up, .down]
        view.gestureRecognizers = [recognizer]
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        print("willappear")
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
    }
  
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardwillshow")
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        messageView?.frame.origin.y -= keyboardFrame.cgRectValue.height
        messageView?.setNeedsDisplay()
    
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardwillHide")
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        messageView?.frame.origin.y += keyboardFrame.cgRectValue.height
        messageView?.setNeedsDisplay()
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc func backToGameView()  {
        self.dismiss(animated: true, completion: nil)
    }
    

    
}

