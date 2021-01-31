//
//  MessageView.swift
//  splitview
//
// Description : gestion des messages
//

import Foundation
import UIKit

class MessageView: UIView {
    
    
    let newMessage = UITextField()
    let titleLabel = UILabel()
    var tableView:UITableView
    let borderWidth:CGFloat = 2.0

    
    
    
    override init(frame: CGRect) {
        tableView = UITableView()
        tableView.backgroundColor = .white
        
        super.init(frame: frame)
        backgroundColor = .gray
        
        //self.update_textLabel(with: chatStatus)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .gray
        
        titleLabel.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel.shadowColor = .blue

        newMessage.placeholder = "   Taper votre message"
        newMessage.returnKeyType = .done
        newMessage.backgroundColor = .white
        newMessage.textColor = .black
        newMessage.borderStyle = .line
        
        addSubview(tableView)
        addSubview(newMessage)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
 
    override func draw(_ rect: CGRect) {
        
        let frameTitle = CGRect(origin: CGPoint(x: borderWidth-borderWidth, y: 0),
                                size: CGSize(width: rect.width /*+ borderWidth*/,
                                             height: 40))
        
        let frameField = CGRect (x: borderWidth-borderWidth,
                                 y: rect.height - 50,
                                 width: rect.width /*+ borderWidth*/,
                                 height: 50)
        
        let frameTableView = CGRect (x: 0,
                                    y: frameTitle.maxY,
                                    width: rect.width,
                                    height: rect.height - frameTitle.height - frameField.height)
        
        
        titleLabel.frame = frameTitle
        newMessage.frame = frameField
        tableView.frame  = frameTableView

    }
    
 
    func viewAppeared () {
        self.center = CGPoint(x: abs(-self.center.x), y: self.center.y)
        self.setNeedsDisplay()
    }
    
    func viewDisappeared () {
        self.center = CGPoint(x: -abs(-self.center.x), y: self.center.y)
        self.setNeedsDisplay()
    }
    
    
    func setTextLabel (with text: String) {
        titleLabel.text = "LIVE CHAT"
    }

    
}
