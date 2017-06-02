//
//  TimelineTableViewCell.swift
//  Trainit
//
//  Created by Daniel Pereira on 6/1/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mondayStackView: UIStackView!
    @IBOutlet weak var tuesdayStackView: UIStackView!
    @IBOutlet weak var wednesdayStackView: UIStackView!
    @IBOutlet weak var thursdayStackView: UIStackView!
    @IBOutlet weak var fridayStackView: UIStackView!
    @IBOutlet weak var saturdayStackView: UIStackView!
    @IBOutlet weak var sundayStackView: UIStackView!
    
    var weekdayToStack: [String:UIStackView] = [:]
    var plan: WorkoutPlan!
    
    //MARK: Initialization
    
    func setup(for plan: WorkoutPlan) {
        self.plan = plan
        
        setupDailyStacks()
        setupCell()
        setupCompletions()
    }
    
    func setupDailyStacks() {
        let eraseStack = { (stack: UIStackView) -> UIStackView in
            for subview in stack.arrangedSubviews {
                stack.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
            return stack
        }
        
        self.weekdayToStack["Mon"] = eraseStack(self.mondayStackView)
        self.weekdayToStack["Tue"] = eraseStack(self.tuesdayStackView)
        self.weekdayToStack["Wed"] = eraseStack(self.wednesdayStackView)
        self.weekdayToStack["Thu"] = eraseStack(self.thursdayStackView)
        self.weekdayToStack["Fri"] = eraseStack(self.fridayStackView)
        self.weekdayToStack["Sat"] = eraseStack(self.saturdayStackView)
        self.weekdayToStack["Sun"] = eraseStack(self.sundayStackView)
    }
    
    func setupCell() {
        self.selectionStyle = .none
    }
    
    func setupCompletions() {
        var workoutPerDay: [String: [Workout]] = [:]
        for workout in self.plan.workouts {
            for completion in workout.completions {
                let idx = weekDayStr(for: completion)
                if workoutPerDay[idx] == nil {
                   workoutPerDay[idx] = []
                }
                workoutPerDay[idx]?.append(workout)
            }
        }
        
        for (day, stack) in self.weekdayToStack {
            var toAdd = plan.maxCompletionsPerDay
            if workoutPerDay[day] != nil {
                for workout in workoutPerDay[day]! {
                    let label = UILabel()
                    label.text = ActivityManager.Instance.activity(
                        by: workout.type).shortName
                    label.font = UIFont(name: "Helvetica", size: 8)
                    label.textAlignment = .center
                    label.layer.borderWidth = 1.0
                    label.layer.cornerRadius = 3.0
                    label.layer.borderColor = UIColor(
                        red: CGFloat(0.9),
                        green: CGFloat(0.9),
                        blue: CGFloat(0.9),
                        alpha: 1.0).cgColor
                    stack.addArrangedSubview(label)
                    label.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 5).isActive = true
                    //label.topAnchor.constraint(equalTo: previous.topAnchor, constant: 5).isActive = true
                    toAdd -= 1
                }
            }
            while toAdd > 0 {
                stack.insertArrangedSubview(UIView(), at: 0)
                toAdd -= 1
            }
            
            let dayLabel = UILabel()
            dayLabel.font = UIFont(name: "Helvetica", size: 10)
            dayLabel.textAlignment = .center
            dayLabel.text = day
            dayLabel.backgroundColor = UIColor.darkGray
            dayLabel.textColor = UIColor.white
            stack.addArrangedSubview(dayLabel)
            dayLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 0).isActive = true
            dayLabel.heightAnchor.constraint(equalToConstant: 20)
            
            let topView = stack.arrangedSubviews[0]
            topView.topAnchor.constraint(equalTo: stack.topAnchor, constant: 5).isActive = true
        }
        
        /*
        for workout in self.plan.workouts {
            let activity = ActivityManager.Instance.activity(by: workout.type)
            
            for completion in workout.completions {
                let image = UIImage(named: activity.icon)
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                
                let wrapperView = UIView()
                //wrapperView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                wrapperView.layer.borderWidth = 1.0
                wrapperView.layer.borderColor = getColor(for: activity).cgColor
                
                
                imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
                wrapperView.addSubview(imageView)
                imageView.center = CGPoint(x: 25, y: 20)
                
                
                let weekDayIdx = weekDayStr(for: completion)
                self.weekdayToStack[weekDayIdx]!.addArrangedSubview(wrapperView)
            }
        }*/
    }
}
