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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let activity = ActivityManager.Instance.activity(by: self.workout!.type)
        
        self.navigationItem.title = activity.title
        self.navigationController?.navigationBar.barTintColor =
            getColor(for: activity)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        self.navigationController?.navigationBar.barTintColor =
            getDefaultNavBarColor()
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150.0
        }
        return 50.0
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let activity = ActivityManager.Instance.activity(
                by: self.workout!.type)
            
            if (indexPath.row == 0) {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "BannerTableViewCell", for: indexPath)
                    as? WorkoutBannerTableViewCell  else {
                        fatalError("The dequeued cell is not an instance of"
                            + " WorkoutBannerTableViewCell.")
                }
                setup(cell, for: activity)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ExerciseTableViewCell", for: indexPath)
                    as? ExerciseTableViewCell  else {
                        fatalError("The dequeued cell is not an instance of"
                            + " ExerciseTableViewCell.")
                }
                return cell
            }
    }
    
    func setup(_ cell: WorkoutBannerTableViewCell, for activity: Activity) {
        cell.bannerImage.image = UIImage(named: activity.banner)
        cell.bannerImage.layer.masksToBounds = true;
        cell.bannerImage.layer.borderColor = getColor(for: activity).cgColor
        cell.bannerImage.layer.borderWidth = 1.0;
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
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
