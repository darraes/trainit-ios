//
//  TimelineTableViewCell.swift
//  Trainit
//
//  Created by Daniel Pereira on 6/1/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    static let kSpacing: Int = 5
    
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
        
        // TODO This will fail if we add i18n
        self.weekdayToStack["Mon"] = eraseStack(self.mondayStackView)
        self.weekdayToStack["Tue"] = eraseStack(self.tuesdayStackView)
        self.weekdayToStack["Wed"] = eraseStack(self.wednesdayStackView)
        self.weekdayToStack["Thu"] = eraseStack(self.thursdayStackView)
        self.weekdayToStack["Fri"] = eraseStack(self.fridayStackView)
        self.weekdayToStack["Sat"] = eraseStack(self.saturdayStackView)
        self.weekdayToStack["Sun"] = eraseStack(self.sundayStackView)
    }
    
    func setupCell() {
        // Disable clicking
        self.selectionStyle = .none
        
        // Making separator line to be full
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    func setupCompletions() {
        var workoutPerDay = self.plan!.getCompletionsPerDay()
        var maxCompletionsPerDay = 0
        for (_, completions) in workoutPerDay {
            maxCompletionsPerDay = max(maxCompletionsPerDay, completions.count)
        }
        
        for (day, stack) in self.weekdayToStack {
            stack.spacing = CGFloat(TimelineTableViewCell.kSpacing)
            let dayLabel = self.getDayLabel(for: day)
            stack.addArrangedSubview(dayLabel)
            
            let tagView = self.getTagStackView()
            stack.addArrangedSubview(tagView)
            
            dayLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            var missing = maxCompletionsPerDay
            if workoutPerDay[day] != nil {
                for workout in workoutPerDay[day]! {
                    let activity = ActivityManager.Instance.activity(
                        by: workout.type)
                    tagView.addArrangedSubview(getTag(for: activity))
                    missing -= 1
                }
            }
            
            
            while missing > 0 {
                tagView.addArrangedSubview(UIView())
                missing -= 1
            }
        }
    }
    
    func getTag(for activity: Activity) -> UILabel {
        let label = UILabel()
        label.text = activity.shortName
        label.font = UIFont(name: "Helvetica", size: 8)
        label.textAlignment = .center
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 3.0
        label.layer.backgroundColor = UIColor(
            red: CGFloat(0.95),
            green: CGFloat(0.95),
            blue: CGFloat(0.95),
            alpha: 1.0).cgColor
        label.layer.borderColor = UIColor(
            red: CGFloat(0.9),
            green: CGFloat(0.9),
            blue: CGFloat(0.9),
            alpha: 1.0).cgColor
        return label
    }
    
    func getDayLabel(for day: String) -> UILabel {
        let dayLabel = UILabel()
        
        dayLabel.font = UIFont(name: "Helvetica", size: 10)
        dayLabel.textAlignment = .center
        dayLabel.text = day
        
        dayLabel.backgroundColor = UIColor.gray
        dayLabel.textColor = UIColor.white
        
        return dayLabel
    }
    
    func getTagStackView() -> UIStackView {
        let tagView = UIStackView()
        
        tagView.axis = .vertical
        tagView.spacing = CGFloat(TimelineTableViewCell.kSpacing)
        tagView.distribution = .fillEqually
        
        tagView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: CGFloat(TimelineTableViewCell.kSpacing),
            bottom: CGFloat(TimelineTableViewCell.kSpacing),
            right: CGFloat(TimelineTableViewCell.kSpacing))
        tagView.isLayoutMarginsRelativeArrangement = true
        
        return tagView
    }
}
