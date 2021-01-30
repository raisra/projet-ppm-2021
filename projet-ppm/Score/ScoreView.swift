//
//  ScoreView.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import Foundation
import UIKit

class ScoreView: UIView {

    
    var tableView : UITableView?
    let titleView = UILabel()
    let backButton = UIButton()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemYellow
        
        
        tableView = UITableView(frame: frame,style: .plain)
        
        titleView.text = "Sores"
        titleView.textAlignment = .center
        titleView.textColor  = .white
        titleView.sizeToFit()
        
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.addTarget(self.superview, action: #selector(ScoreViewController.backAction), for: .touchUpInside)
        
        addSubview(titleView)
        addSubview(tableView!)
        addSubview(backButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        titleView.frame  = CGRect(x: 0, y: 0, width: rect.width, height: rect.height/8)
        titleView.center.x = rect.midX
        tableView?.frame = CGRect(x: 0,
                                  y: rect.height/8,
                                  width: rect.width,
                                  height: rect.height * 6/8)
        backButton.frame = CGRect(x: 0,
                                  y: rect.height * 7/8,
                                  width: rect.width,
                                  height: rect.height/8)
       
    }
    
    

}
