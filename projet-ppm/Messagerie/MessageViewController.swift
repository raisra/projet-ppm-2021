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
//    var keyboardFrame: NSValue
    var keyBoarAlreadyAppeared: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view = MessageView(frame: UIScreen.main.bounds)
        messageView = self.view as? MessageView
        
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(backToGameView))
        recognizer.direction = [.right, .left]
        view.gestureRecognizers = [recognizer]
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewwilldisappear")
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

