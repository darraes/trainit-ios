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
    
    static let kDetailCellHeight: CGFloat = 50.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activity = ActivityManager.Instance.activity(by: self.workout!.type)
        self.workoutExercises = []
        
        self.navigationItem.title = activity!.title
        self.navigationController?.navigationBar.barTintColor =
            ColorUtils.getColor(for: self.activity!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WorkoutManager.Instance.listExercises(for: self.workout!)
        { (exercises) in
            self.workoutExercises = exercises
            self.tableView.reloadData()
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        self.navigationController?.navigationBar.barTintColor =
            ColorUtils.getDefaultNavBarColor()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.workoutExercises.count
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WorkoutDetailTableViewController.kDetailCellHeight
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
