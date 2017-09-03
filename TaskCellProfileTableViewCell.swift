//
//  TaskCellProfileTableViewCell.swift
//  Timo
//
//  Created by Ha on 8/7/17.
//  Copyright © 2017 Ha. All rights reserved.
//

import UIKit

class TaskCellProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var scoresLabelProfile: UILabel!
    @IBOutlet weak var nameLabelProfile: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var timeLabelProfile: UILabel!
    @IBOutlet weak var commentProfile: UILabel!
    @IBOutlet weak var numberDateLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
