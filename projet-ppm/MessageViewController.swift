//
//  MessageViewController.swift
//  splitview
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit


class MessageViewController: UIViewController{
    
    var messageView : MessageView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view = MessageView(frame: UIScreen.main.bounds)
        messageView = self.view as? MessageView
        
        
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(backToGameView))
        recognizer.direction = [.right, .left]
        view.gestureRecognizers = [recognizer]
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("keyboardwillHide")
        if(keyBoarAppeared){
            
        }
    }
  
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardwillshow")
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        messageView?.frame.origin.y -= keyboardFrame.cgRectValue.height
        messageView?.setNeedsDisplay()
        keyBoarAppeared = true
    }
    
    var keyBoarAppeared: Bool = false
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardwillHide")
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        messageView?.frame.origin.y += keyboardFrame.cgRectValue.height
        messageView?.setNeedsDisplay()
        keyBoarAppeared = false
    }
    
    func
    
    @objc func backToGameView()  {
        self.dismiss(animated: true, completion: nil)
    }
    

    
}

