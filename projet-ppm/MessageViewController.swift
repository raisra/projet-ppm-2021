//
//  MessageViewController.swift
//  splitview
//
//  Created by ramzi on 13/01/2021.
//

import Foundation
import UIKit


class MessageViewController: UIViewController , UISplitViewControllerDelegate {
    
    var gvc : GameViewController
    var messageView : MessageView?
    
    
    init(gvc : GameViewController) {
        self.gvc = gvc
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let a = self.navigationItem
        self.navigationItem.title = "Messages"
     
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(MessageViewController.backToGameView))
        self.navigationItem.backBarButtonItem?.tintColor = .blue
        
        view = MessageView(frame: UIScreen.main.bounds)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        
        messageView = (self.view) as! MessageView
        
        splitViewController?.delegate = self
    }
    
  
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardwillshow")
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        let a = messageView?.frame
        messageView?.frame.origin.y -= keyboardFrame.cgRectValue.height
        let c = keyboardFrame.cgRectValue.height
        let b = messageView?.frame
        
        messageView?.setNeedsDisplay()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardwillHide")
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        messageView?.frame.origin.y += keyboardFrame.cgRectValue.height
        messageView?.setNeedsDisplay()
    }
    
    @objc func backToGameView()  {
        print("move from primary to secondary")
        let a = self.navigationController?.viewControllers
        splitViewController?.preferredDisplayMode = .secondaryOnly

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("message view will appear")
        
        
        gvc.blurrGameView()
        gvc.pauseGame()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("message view will desappear")
        gvc.unblurrGameView()
        gvc.showPauseButton()
    
    }
    
    func splitViewController(
                 _ splitViewController: UISplitViewController,
                 collapseSecondary secondaryViewController: UIViewController,
                 onto primaryViewController: UIViewController) -> Bool {
            // Return true to prevent UIKit from applying its default behavior
        
        print("split view delegate")
            return true
        }
    
}

