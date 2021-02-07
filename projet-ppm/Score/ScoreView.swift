//
//  ScoreView.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import UIKit

class ScoreView: UIView {

    
    var tableView : UITableView?
    let topSubView = UIView()
    let bottomSubView = UIView()
    let footerViewLabel = UILabel()
    let closeButtonImage = UIImage(named: "closeButton")
    let backButton = UIButton(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(red: 240, green: 240, blue: 140, alpha: 1)
        self.tableView = UITableView(frame: frame, style: .plain)
        self.tableView!.layoutMargins = .zero // sert a rien :/
        self.tableView!.separatorStyle = .none
        self.tableView!.tableFooterView = footerViewLabel
        footerViewLabel.text = "Empty Score"
        footerViewLabel.textAlignment = .center
        footerViewLabel.backgroundColor = .systemGreen
        self.addSubview(self.tableView!)

        self.addSubview(self.topSubView)
        self.addSubview(self.bottomSubView)
        
        backButton.setImage(closeButtonImage, for: .normal)
        topSubView.addSubview(backButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.tableView?.frame = CGRect(x: 0, y: rect.height/6, width: rect.width,height: rect.height * 4/6)
        self.topSubView.frame.size = CGSize(width: tableView!.frame.width, height: tableView!.frame.minY)
        self.bottomSubView.frame.origin = CGPoint(x: tableView!.frame.minX, y: tableView!.frame.maxY)
        self.bottomSubView.frame.size = CGSize(width: tableView!.frame.width,height: rect.height - tableView!.frame.maxY)
       
        bottomSubView.layer.cornerRadius = 0
        
        footerViewLabel.frame = CGRect(origin: .zero,  size: tableView!.frame.size)
        
        backButton.frame = CGRect (origin: CGPoint(x: 15, y: 15), size: closeButtonImage?.size ?? .zero)
    }
    
    

}
