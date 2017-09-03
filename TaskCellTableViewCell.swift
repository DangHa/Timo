//
//  TaskCellTableViewCell.swift
//  Timo
//
//  Created by Ha on 7/25/17.
//  Copyright © 2017 Ha. All rights reserved.
//

import UIKit
import CoreData

class TaskCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTaskLabel: UILabel!
    @IBOutlet weak var timeBeginLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ScoresView: UILabel!
    @IBOutlet weak var timeOutLabel: UIButton!
   

    @IBOutlet weak var AcceptOutlet: UISegmentedControl!
    @IBAction func AcceptButton(_ sender: Any) {
    }
    

    

    
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

