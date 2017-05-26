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
            cell.completedLabel.text = "\(workout.completed)/\(workout.sessionsPerWeek)"
            cell.workoutImage.image = UIImage(named: activity.icon)
            cell.workoutColorBar.backgroundColor = UIColor(
                red: CGFloat(activity.themeColorRgb.red),
                green: CGFloat(activity.themeColorRgb.green ),
                blue: CGFloat(activity.themeColorRgb.blue),
                alpha: 1.0)
            self.showCheckboxIfCompleted(cell, workout)

            return cell
    }
    
    func showCheckboxIfCompleted(_ cell: WorkoutTableViewCell, _ workout: Workout) {
        if (workout.completed < workout.sessionsPerWeek) {
            cell.accessoryType = .none
            cell.completedLabel.isHidden = false
            cell.workoutLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.completedLabel.isHidden = true
            cell.workoutLabel?.textColor = UIColor.gray
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
