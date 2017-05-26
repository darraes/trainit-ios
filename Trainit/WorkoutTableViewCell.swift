//
//  WorkoutRunTableViewCell.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/22/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var workoutColorBar: UIView!
    @IBOutlet weak var completedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
