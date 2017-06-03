//
//  ExerciseTableViewCell.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/27/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var routineInfoLabel: UILabel!
    @IBOutlet weak var routineTypeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    func configure(for exercise: Exercise, activity: Activity) {
        self.titleLabel.text = exercise.title
        self.colorBar.backgroundColor = getColor(for: activity)
        self.routineInfoLabel.text = exercise.infoStr()
        self.routineTypeLabel.text = exercise.typeStr()
        self.notesLabel.text = exercise.notes
    }

}
