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
    static let adresse = "127.0.0.1"
    static let port    = "5000"
}



import UIKit

class MessageViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,  receiveTCP {
 
    static let sharedInstance = MessageViewController()
    
    var messageView: MessageView
    var networkManager: NetworkManager

    var nbOfMessage = 0
    
    var msg:  [String] = [String]()
    
    private init() {
        networkManager = NetworkManager(host : _SERVER.adresse , port : _SERVER.port )
        messageView = MessageView()
        
        super.init(nibName: nil, bundle: nil)
        
        networkManager.delegate = self
       // networkManager.checkAndConnect()
        
        messageView.tableView.delegate = self
        messageView.tableView.dataSource = self
        messageView.newMessage.delegate = self
    }
    
    
   


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view = messageView
       
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
    }
  
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
     
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        messageView.frame.origin.y -= keyboardFrame.cgRectValue.height
        messageView.setNeedsDisplay()
    
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        messageView.frame.origin.y += keyboardFrame.cgRectValue.height
        messageView.setNeedsDisplay()
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
    }
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func stopChatService () {
        networkManager.close()
    }
    



    func receiveTCP(data: String) {
        DispatchQueue.main.async {
            self.addMessage(msg: data)
        }
        
    }
    
    
    
    
    func addMessage(msg : String){
        messageView.tableView.beginUpdates()
        self.msg.append(msg)
        messageView.tableView.insertRows(at: [IndexPath.init(row: nbOfMessage, section: 0)], with: .bottom)
        nbOfMessage += 1
        messageView.tableView.endUpdates()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nbOfMessage
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "customeReuseIdentifier") as? MessageTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MessageTableViewCell", owner: self, options: nil)?.first as? MessageTableViewCell
        }

        cell?.messageLabel.text = msg.removeFirst()
        return cell!
    }
    


    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if textField.text?.isEmpty ?? false {
            textField.text = "   "
        }
    }
    
    
    
    func clearText (textField: UITextField) -> String{
        var textCleared = String()
        var firstChar = true
        for char in textField.text! {
            if (!firstChar || char != " ") {
                textCleared.append(char)
                firstChar = false
            }
        }
        textField.text = textCleared
        return textCleared
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        textField.resignFirstResponder()
        let cleared = self.clearText(textField: textField)
        print ("text cleared - "  + cleared)
        if  !(textField.text!.isEmpty) {
            networkManager.sendMsg(textField.text!)
            addMessage(msg: textField.text!)
            
        }
        textField.text = ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return (range.location > 2) ? true : false
    }
    
    

    func addGestureReconizer () {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideView))
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = .left
        self.messageView.addGestureRecognizer(swipeGesture)
    }
    
    
    
    @objc func hideView (_ gesture: UIGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        self.messageView.viewDisappeared()
                       },
                       completion: { (finished:Bool) in
                        self.messageView.removeGestureRecognizer(gesture)
                        self.willMove(toParent: nil)
                        self.view.removeFromSuperview()
                        self.removeFromParent()
                       })
    }
    


    func error(error: Error?) {
        let alert = UIAlertController(title: "Error", message: "No connection", preferredStyle: .alert)
        alert.addAction(.init(title: "ok", style: .default, handler: nil))
        DispatchQueue.main.async {
         
        }
    }
    


}
