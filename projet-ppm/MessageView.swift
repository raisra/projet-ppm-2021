//
//  MessageView.swift
//  splitview
//
//  Created by ramzi on 13/01/2021.
//

import Foundation


import UIKit

class MessageView: UIView, UITextFieldDelegate {
    
    
    
    let messages: UITextView = UITextView()
    let newMessage : UITextField = UITextField()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        messages.backgroundColor = .white
        messages.isEditable = false
        messages.textColor = .black
        
        newMessage.backgroundColor = .white
        newMessage.textColor = .black
        newMessage.borderStyle = .roundedRect
        newMessage.keyboardType = .asciiCapable
        newMessage.delegate = self
        newMessage.placeholder = "type your message here"
   
        
        
        
        addSubview(messages)
        addSubview(newMessage)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func draw(_ rect: CGRect) {
        
        let h = rect.height
        let w = rect.width
        let entete : CGFloat = 30.0
        let margeHorizontal : CGFloat = 10.0
        let margeVertical : CGFloat = 10.0
        
        messages.frame = CGRect(x: margeHorizontal, y: margeVertical+entete,
                                 width: w - 2*margeHorizontal, height: h - 3*margeVertical-40-entete)
    
        newMessage.frame = CGRect(x: margeHorizontal, y: h - margeVertical - 40, width: w - 2*margeHorizontal, height: 40)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if(textField.text?.count==0) {return true}
        
        messages.text += (textField.text)! + "\n"
        textField.text = ""
        return true
    }
}
