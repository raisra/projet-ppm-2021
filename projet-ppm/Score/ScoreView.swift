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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(red: 240, green: 240, blue: 140, alpha: 1)
        self.tableView = UITableView(frame: frame, style: .plain)
        self.tableView!.backgroundColor = UIColor(patternImage: UIImage(named: "bluejeans.png")!)
        self.tableView!.layoutMargins = .zero // sert a rien :/
        self.tableView!.separatorStyle = .none
        self.addSubview(self.tableView!)
        
        
        topSubView.backgroundColor = .systemPink
        bottomSubView.backgroundColor = .systemPink
        self.addSubview(self.topSubView)
        self.addSubview(self.bottomSubView)
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
                                       height: rect.height * 4/6)
        self.topSubView.frame.size = CGSize(width: tableView!.frame.width,
                                            height: tableView!.frame.minY)
        self.bottomSubView.frame.origin = CGPoint(x: tableView!.frame.minX,
                                                  y: tableView!.frame.maxY)
        self.bottomSubView.frame.size = CGSize(width: tableView!.frame.width,
                                               height: rect.height - tableView!.frame.maxY)
       
        bottomSubView.layer.cornerRadius = 0
    }
    
    

}
