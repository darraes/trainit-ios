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
    
    let workoutRef = Database.database().reference(withPath: "workout-plans/1/current")
    
    var workoutPlan: WorkoutPlan!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutRef.observe(.value, with: { snapshot in
            //self.workoutPlan = WorkoutPlan(snapshot)
            //self.tableView.reloadData()
        })
        
        WorkoutManager.Instance.listen(for: User())
        WorkoutManager.Instance.subscribe(with: { workoutPlan in
            self.workoutPlan = workoutPlan
            self.tableView.reloadData()
        })
        if let workoutPlan = WorkoutManager.Instance.workoutPlan {
            self.workoutPlan = workoutPlan
        }
        
        // Uncomment the following line to preserve selection between
        // presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the
        // navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            let workouts = self.workoutPlan.workouts
            let workout = workouts[indexPath.row]
            let activity = ActivityManager.Instance.activity(by: workout.type)
            
            cell.workoutLabel.text = activity.title
            cell.completedLabel.text =
                "\(workout.completedSessions)/\(workout.sessionsPerWeek)"
            cell.workoutImage.image = UIImage(named: activity.icon)
            cell.workoutColorBar.backgroundColor = getColor(for: activity)
            self.showCheckboxIfCompleted(cell, workout)
            
            return cell
    }
    
    func showCheckboxIfCompleted(_ cell: WorkoutTableViewCell,
                                 _ workout: Workout) {
        if (workout.completedSessions < workout.sessionsPerWeek) {
            cell.accessoryType = .none
            cell.completedLabel.isHidden = false
            cell.workoutLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.completedLabel.isHidden = true
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
            if workout.completedSessions > 0 {
                actions.append(undoAction)
            }
            return actions
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little
     // preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
