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
    static let kCompletionHeight: Int = 20
    static let kProgressFooterHeight: Int = 15
    
    @IBOutlet weak var mondayStackView: UIStackView!
    @IBOutlet weak var tuesdayStackView: UIStackView!
    @IBOutlet weak var wednesdayStackView: UIStackView!
    @IBOutlet weak var thursdayStackView: UIStackView!
    @IBOutlet weak var fridayStackView: UIStackView!
    @IBOutlet weak var saturdayStackView: UIStackView!
    @IBOutlet weak var sundayStackView: UIStackView!
    
    var weekdayToStack: [String:UIStackView] = [:]
    var plan: WorkoutPlan!
    
    func configure(for plan: WorkoutPlan) {
        self.plan = plan
        
        configureDailyStacks()
        configureCell()
        configureCompletions()
    }
    
    private func configureDailyStacks() {
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
    
    private func configureCell() {
        // Disable clicking
        self.selectionStyle = .none
        
        // Making separator line to be full
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    private func configureCompletions() {
        var workoutPerDay = self.plan!.getCompletionsPerDay()
        let maxCompletionsPerDay = self.plan!.maxCompletions()
        
        for (day, stack) in self.weekdayToStack {
            stack.spacing = CGFloat(TimelineTableViewCell.kSpacing)
            let dayLabel = self.createDayLabel(for: day)
            stack.addArrangedSubview(dayLabel)
            
            let tagView = self.createTagStackView()
            stack.addArrangedSubview(tagView)
            
            dayLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            var missing = maxCompletionsPerDay
            if workoutPerDay[day] != nil {
                for workout in workoutPerDay[day]! {
                    let activity = ActivityManager.Instance.activity(
                        by: workout.type)
                    tagView.addArrangedSubview(createTag(for: activity))
                    missing -= 1
                }
            }
            
            
            while missing > 0 {
                tagView.addArrangedSubview(UIView())
                missing -= 1
            }
        }
    }
    
    private func createTag(for activity: Activity) -> UILabel {
        let label = UILabel()
        
        label.text = activity.shortName
        label.font = UIFont(name: "Helvetica", size: 9)
        label.textAlignment = .center
        
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 3.0
        label.layer.backgroundColor = grayScale(0.97).cgColor
        label.layer.borderColor = grayScale(0.88).cgColor
        
        return label
    }
    
    private func createDayLabel(for day: String) -> UILabel {
        let dayLabel = UILabel()
        
        dayLabel.font = UIFont(name: "Helvetica", size: 10)
        dayLabel.textAlignment = .center
        dayLabel.text = day
        
        dayLabel.backgroundColor = UIColor.darkGray
        dayLabel.textColor = UIColor.white
        
        return dayLabel
    }
    
    private func createTagStackView() -> UIStackView {
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
