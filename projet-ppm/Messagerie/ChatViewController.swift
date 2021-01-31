//
//  ChatViewController.swift
//  projet-ppm
//
//  Created by ramzi on 30/01/2021.
//



import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {

    static let sharedInstance = ChatViewController()
    
    var messageView: MessageView
    var modelChat: MessageModel

    
    private init() {
        modelChat = MessageModel()
        
        messageView = MessageView()
        
        super.init(nibName: nil, bundle: nil)
        
        
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
    


    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    
    
    

    func addMessage (name:String, message: String, isMe: Bool) {
        let msg = Message(_isItMe: isMe, _name: name, _message: message)
        self.modelChat.data.append(msg)
        
        self.messageView.tableView.insertRows(at: [IndexPath (row: self.modelChat.data.count - 1, section: 0)], with: .top)
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelChat.nbOfMessages()
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "customeReuseIdentifier") as? MessageTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ChatTableViewCell", owner: self, options: nil)?.first as? MessageTableViewCell
        }

        
        cell?.messageLabel.text  = self.modelChat.data[indexPath.row]._message
        cell?.namelabel.text     = self.modelChat.data[indexPath.row]._name
        if self.modelChat.data[indexPath.row]._isItMe {
            cell?.backgroundView?.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        }
        
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
            networkManager.sendPaket(textField.text!)
            addMessage(name: _USER.myName, message: textField.text!,isMe: true)
        }
        textField.text = ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //print ("ramzi - " + range.description + " " + string)
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
    



    func receiveMessage(name: String, message:String, isMe: Bool, id:String) {
       
        addMessage(name: name,
                     message: message,
                        isMe: isMe)
    }
    
    func error(error: Error?) {
        let alert = UIAlertController(title: "Error", message: "No connection", preferredStyle: .alert)
        alert.addAction(.init(title: "ok", style: .default, handler: nil))
        DispatchQueue.main.async {
         
        }
    }
    


}
