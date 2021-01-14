//
//  MessageViewController.swift
//  splitview
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit


class MessageViewController: UIViewController {
     
   
    
  
   
    
    
   
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Messages"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(MessageViewController.backToGameView))
        self.navigationItem.backBarButtonItem?.tintColor = .blue
        
        view = MessageView(frame: UIScreen.main.bounds)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        
    }
    

    
   


    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        
            let messageView = (self.view) as! MessageView
        
            messageView.newMessage.frame.origin.y -= keyboardFrame.cgRectValue.height
        
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue

        
        
       
            let messageView = (self.view) as! MessageView
            messageView.newMessage.frame.origin.y += keyboardFrame.cgRectValue.height
        
        
    }

    @objc func backToGameView()  {
        
        let a = self.navigationController?.viewControllers
     //   splitVC?.showDetailViewController(detailVC!.navigationController!, sender: self)
    }
    
}

