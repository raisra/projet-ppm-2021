//
//  ChatCellViewTableViewCell.swift
//  projet-ppm
//
//  Created by ramzi on 30/01/2021.
//

import UIKit



class MessageTableViewCell: UITableViewCell {
    
    let nameHeight: CGFloat = 20.0
    
    @IBOutlet var messageLabel : UILabel!
    @IBOutlet var namelabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
