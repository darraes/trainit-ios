//
//  WorkoutDetailTableViewController.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/27/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import UIKit

class WorkoutDetailTableViewController: UITableViewController {
    
    var workout: Workout?
    var activity: Activity?
    var workoutExercises: [Exercise]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activity = ActivityManager.Instance.activity(by: self.workout!.type)
        self.workoutExercises = []
        
        self.navigationItem.title = activity!.title
        self.navigationController?.navigationBar.barTintColor =
            getColor(for: self.activity!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WorkoutManager.Instance.subscribe(for: self.workout!) { (exercises) in
            self.workoutExercises = exercises
            self.tableView.reloadData()
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        self.navigationController?.navigationBar.barTintColor =
            getDefaultNavBarColor()
        WorkoutManager.Instance.unsubscribe(for: self.workout!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.workoutExercises.count
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ExerciseTableViewCell", for: indexPath)
                as? ExerciseTableViewCell  else {
                    fatalError("The dequeued cell is not an instance of"
                        + " ExerciseTableViewCell.")
            }
            let exercise = self.workoutExercises[indexPath.row]
            cell.configure(for: exercise, activity: self.activity!)
            return cell
    }
}
