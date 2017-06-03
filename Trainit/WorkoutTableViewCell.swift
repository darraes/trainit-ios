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
    @IBOutlet weak var completionsLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    func setup(for workout: Workout) {
        let activity = ActivityManager.Instance.activity(by: workout.type)
        
        self.workoutLabel.text = activity.title
        self.workoutImage.image = UIImage(named: activity.icon)
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.cornerRadius = 23.0
        self.borderView.layer.borderColor = getColor(for: activity).cgColor
        
        self.completedLabel.text =
        "\(workout.getSessionsCompleted())/\(workout.sessionsPerWeek)"
        
        var completionsStr: String = ""
        for (idx, completion) in workout.completions.enumerated() {
            completionsStr += weekDayStr(for: completion)
            if (idx != workout.completions.count - 1) {
                completionsStr += ", "
            }
        }
        self.completionsLabel.text = completionsStr
        
        self.toggleCompletion(workout)
    }
    
    func toggleCompletion(_ workout: Workout) {
        if (workout.getSessionsCompleted() < workout.sessionsPerWeek) {
            self.accessoryType = .none
            self.completedLabel.isHidden = false
            self.completionsLabel.isHidden = false
            self.workoutLabel?.textColor = UIColor.black
        } else {
            self.accessoryType = .checkmark
            self.completedLabel.isHidden = true
            self.completionsLabel.isHidden = true
            self.workoutLabel?.textColor = UIColor.gray
        }
    }

}
