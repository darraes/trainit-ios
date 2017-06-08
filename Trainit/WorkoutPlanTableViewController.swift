//
//  WorkoutRunTableViewController.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/22/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

/*
 {
 "rules": {
 ".read": "auth != null",
 ".write": "auth != null"
 }
 }
 */

import UIKit
import Firebase

class WorkoutPlanTableViewController: UITableViewController {
    
    var workoutPlan: WorkoutPlan!
    var history: History!
    
    static let kShowDetailSegue = "ShowWorkoutDetail"
    static let kShowRolloverSegue = "ShowRollover"
    
    static let kTimelineSection = 0
    static let kWorkoutCellHeight: CGFloat = 50.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor =
            ColorUtils.getDefaultNavBarColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WorkoutManager.Instance.listen(
            // Listening for workout updates - completions / undos
            onPlan: { workoutPlan in
                self.workoutPlan = workoutPlan
                self.tableView.reloadData()
            },
            // Fetches the user history
            onHistory:{ history in
                self.history = history
                self.tableView.reloadData()
            },
            // Listening for when the week is over and the plan is rolling
            onRolling: {workoutPlan, history in
                self.workoutPlan = workoutPlan
                self.history = history
                self.tableView.reloadData()
                
                self.navigationController?.performSegue(
                    withIdentifier:
                        WorkoutPlanTableViewController.kShowRolloverSegue,
                    sender: nil)
            })
        
        self.clearsSelectionOnViewWillAppear = true
    }
    
    /**
     *  ======= MARK: User Actions
     */
    
    @IBAction func logoffAction(_ sender: UIBarButtonItem) {
        let success = UserAccountManager.Instance.signOut(onError: { error in
            // TODO do something
        })
        
        if success {
            dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     *  ======= MARK: Table view data source
     */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (self.workoutPlan === nil) {
            return 0;
        }
        
        // One section for the timeline and one for the workout list
        return 2
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if (self.workoutPlan === nil) {
            // We could not load the plan, so no cells anywhere
            return 0;
        }
        
        switch section {
        case WorkoutPlanTableViewController.kTimelineSection:
            // Timeline has only 1 cell
            return (self.workoutPlan!.maxCompletions() > 0) ? 1 : 0
        default:
            // One per workout
            return workoutPlan.workoutCount()
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == WorkoutPlanTableViewController.kTimelineSection
        {
            // We ned to find the day with most completions as that day will
            // dictate the height of the cell. We need space for the larger
            let maxCompletionsPerDay = self.workoutPlan!.maxCompletions()
            return CGFloat(TimelineTableViewCell.kCompletionHeight
                            * (maxCompletionsPerDay + 1))
        }
        
        // Workout cell height
        return WorkoutPlanTableViewController.kWorkoutCellHeight
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            if indexPath.section ==
                    WorkoutPlanTableViewController.kTimelineSection {
                let cellIdentifier = "TimelineTableViewCell"
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: cellIdentifier,
                    for: indexPath) as? TimelineTableViewCell  else {
                        fatalError("The dequeued cell is not an instance of"
                            + " TimelineTableViewCell.")
                }
                
                cell.configure(for: self.workoutPlan)
                return cell
            } else {
                let cellIdentifier = "WorkoutTableViewCell"
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: cellIdentifier,
                    for: indexPath) as? WorkoutTableViewCell  else {
                        fatalError("The dequeued cell is not an instance of"
                            + " WorkoutTableViewCell.")
                }
                
                // Fetches the appropriate meal for the data source layout.
                let workout = self.workoutPlan.workouts[indexPath.row]
                cell.configure(for: workout)
                return cell
            }
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == WorkoutPlanTableViewController.kTimelineSection
        {
            // Timeline is non-editable
            return false
        }
        // Workout cells are editable
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt: IndexPath)
        -> [UITableViewRowAction]? {
            
            // timeline cell has no edit actions
            if editActionsForRowAt.section ==
                    WorkoutPlanTableViewController.kTimelineSection {
                return []
            }
            
            // Workout actions
            let workouts = self.workoutPlan.workouts
            let workout = workouts[editActionsForRowAt.row]
            let activity = ActivityManager.Instance.activity(by: workout.type)
            
            // Marks one session of the workout as completed
            let completeAction = UITableViewRowAction(style: .normal,
                                                      title: "Complete")
            { (action, index) in
                defer { self.tableView.isEditing = false }
                workout.completeOneSession()
                WorkoutManager.Instance.save(workout)
            }
            completeAction.backgroundColor = ColorUtils.getColor(for: activity)
            
            // Un-marks the completion of one session of the workout
            let undoAction = UITableViewRowAction(style: .normal,
                                                  title: "Undo")
            { (action, index) in
                defer { self.tableView.isEditing = false }
                workout.revertOneSession()
                WorkoutManager.Instance.save(workout)
            }
            undoAction.backgroundColor = .lightGray
            
            var actions: [UITableViewRowAction] = []
            
            // If there are session left, enable complete actions
            if !workout.isAllCompleted() {
                actions.append(completeAction)
            }
            
            // If at least one session was completed, enable the undo
            if workout.completedSessionsCount() > 0 {
                actions.append(undoAction)
            }
            return actions
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForFooterInSection section: Int) -> UIView? {

        if section != WorkoutPlanTableViewController.kTimelineSection {
            return nil
        }
        
        let progress = self.workoutPlan!.getProgress()
        let progressPct = (Int)(100.0 * Float(progress.completed)
            / Float(progress.total))
        
        let progressLabel = UILabel()
        progressLabel.font = UIFont(name: "Helvetica", size: 10)
        progressLabel.textAlignment = .center
        progressLabel.text = "You completed \(progress.completed) out of"
            + " \(progress.total) -"
            + " \(progressPct)%"
        
        progressLabel.backgroundColor = ColorUtils.grayScale(0.9)
        
        return progressLabel
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForFooterInSection section: Int) -> CGFloat {
        if section == WorkoutPlanTableViewController.kTimelineSection {
            return CGFloat(TimelineTableViewCell.kProgressFooterHeight)
        }
        return 0
    }
    
    /**
     *  ======= MARK: Navigation
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case WorkoutPlanTableViewController.kShowDetailSegue:
            guard let detailController = segue.destination
                    as? WorkoutDetailTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? WorkoutTableViewCell else {
                let msg = sender ?? "nil"
                fatalError("Unexpected sender: \(msg)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else {
                fatalError(
                    "The selected cell is not being displayed by the table")
            }
            
            // Pass the desired workout to the details view
            let workout = self.workoutPlan.workouts[indexPath.row]
            detailController.workout = workout
            
            // We de-select the cell for when this view returns, no cell is
            // selected
            cell.setSelected(false, animated: true)
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(
                title:"", style:.plain, target:nil, action:nil)
            
        case WorkoutPlanTableViewController.kShowRolloverSegue:
            Log.debug("Showing rollover view")
            
        default:
            let msg = segue.identifier ?? "nil"
            fatalError("Unexpected Segue Identifier; \(msg)")
        }
    }
}
