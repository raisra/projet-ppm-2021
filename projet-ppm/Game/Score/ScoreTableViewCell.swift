//
//  ScoreViewCellTableViewCell.swift
//  projet-ppm-ramzi
//
//  Created by ramzi on 05/02/2021.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet var scoreLabel : UILabel!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
  


}
