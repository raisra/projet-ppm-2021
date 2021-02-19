//
//  ScoreView.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import UIKit

class ScoreView: UIView {

    
    var tableView : UITableView?
    let topSubView = UILabel()
    let footerViewLabel = UILabel()
    let closeButtonImage = UIImage(named: "closeButton")
    let backButton = UIButton(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(red: 240, green: 240, blue: 140, alpha: 1)
        self.tableView = UITableView(frame: frame, style: .plain)
        self.tableView!.backgroundColor = .gray
        self.tableView!.layoutMargins = .zero // sert a rien :/
        //self.tableView!.separatorStyle = .none
        self.tableView!.tableFooterView = footerViewLabel
        footerViewLabel.text = "Empty Score"
        footerViewLabel.textAlignment = .center
        footerViewLabel.backgroundColor = .lightGray
        self.addSubview(self.tableView!)
        
        
        topSubView.backgroundColor = .lightGray
        topSubView.text = "Scores"
        topSubView.font = UIFont.boldSystemFont(ofSize: 35)
        topSubView.textAlignment = .left
        topSubView.layer.borderWidth = 1
        topSubView.layer.borderColor = UIColor.black.cgColor
        
        self.addSubview(self.topSubView)
        
        
        backButton.setImage(closeButtonImage, for: .normal)
        backButton.isHidden = true
        addSubview(backButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.tableView?.frame = CGRect(x: 0, y: rect.height/6,
                                       width: rect.width,
                                       height: rect.height * 5/6)
        
        self.topSubView.frame.origin.x = -1
        self.topSubView.frame.size = CGSize(width: tableView!.frame.width + 2,
                                            height: tableView!.frame.minY)
        
        footerViewLabel.frame = CGRect(origin: .zero,
                                       size: tableView!.frame.size)
        
        backButton.frame = CGRect (origin: CGPoint(x: rect.width - 15 - 30, y: 15),
                                   size: CGSize(width: 30, height: 30))
    }
    
    

}
