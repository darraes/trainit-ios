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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor =
            getDefaultNavBarColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WorkoutManager.Instance.listen(with: { workoutPlan in
            self.workoutPlan = workoutPlan
            self.tableView.reloadData()
        })
        
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (self.workoutPlan === nil) {
            return 0;
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if (self.workoutPlan === nil) {
            return 0;
        }
        
        return workoutPlan.workoutCount()
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cellIdentifier = "WorkoutTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellIdentifier,
                for: indexPath) as? WorkoutTableViewCell  else {
                    fatalError("The dequeued cell is not an instance of"
                        + " WorkoutTableViewCell.")
            }
            
            // Fetches the appropriate meal for the data source layout.
            let workout = self.workoutPlan.workouts[indexPath.row]
            setup(cell, for: workout);
            return cell
    }
    
    func setup( _ cell: WorkoutTableViewCell, for workout: Workout) {
        let activity = ActivityManager.Instance.activity(by: workout.type)
        
        cell.workoutLabel.text = activity.title
        cell.workoutImage.image = UIImage(named: activity.icon)
        cell.borderView.layer.borderWidth = 1.0
        cell.borderView.layer.cornerRadius = 23.0
        cell.borderView.layer.borderColor = getColor(for: activity).cgColor
        
        cell.completedLabel.text =
            "\(workout.getSessionsCompleted())/\(workout.sessionsPerWeek)"
        
        var completionsStr: String = ""
        for (idx, completion) in workout.completions.enumerated() {
            completionsStr += weekDayStr(for: completion)
            if (idx != workout.completions.count - 1) {
                completionsStr += ", "
            }
        }
        cell.completionsLabel.text = completionsStr
        
        self.toggleCompletion(cell, workout)
    }
    
    
    
    func toggleCompletion(_ cell: WorkoutTableViewCell,
                                 _ workout: Workout) {
        if (workout.getSessionsCompleted() < workout.sessionsPerWeek) {
            cell.accessoryType = .none
            cell.completedLabel.isHidden = false
            cell.completionsLabel.isHidden = false
            cell.workoutLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.completedLabel.isHidden = true
            cell.completionsLabel.isHidden = true
            cell.workoutLabel?.textColor = UIColor.gray
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath)
        -> Bool {
            return true
    }
    
    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt: IndexPath)
        -> [UITableViewRowAction]? {
            let workouts = self.workoutPlan.workouts
            let workout = workouts[editActionsForRowAt.row]
            let activity = ActivityManager.Instance.activity(by: workout.type)
            
            let completeAction = UITableViewRowAction(style: .normal,
                                                      title: "Complete")
            { (action, index) in
                defer { self.tableView.isEditing = false }
                workout.completeOneSession()
                WorkoutManager.Instance.save(workout)
            }
            completeAction.backgroundColor = getColor(for: activity)
            
            let undoAction = UITableViewRowAction(style: .normal,
                                                  title: "Undo")
            { (action, index) in
                defer { self.tableView.isEditing = false }
                workout.revertOneSession()
                WorkoutManager.Instance.save(workout)
            }
            undoAction.backgroundColor = .lightGray
            
            var actions: [UITableViewRowAction] = []
            if !workout.allCompleted() {
                actions.append(completeAction)
            }
            if workout.getSessionsCompleted() > 0 {
                actions.append(undoAction)
            }
            return actions
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowWorkoutDetail":
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
            
            let workout = self.workoutPlan.workouts[indexPath.row]
            detailController.workout = workout
            cell.setSelected(false, animated: true)
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(
                title:"", style:.plain, target:nil, action:nil)
            
        default:
            let msg = segue.identifier ?? "nil"
            fatalError("Unexpected Segue Identifier; \(msg)")
        }
    }
    
    
    
    
}
