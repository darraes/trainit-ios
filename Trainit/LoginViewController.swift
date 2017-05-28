//
//  LoginViewController.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/27/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowPlan", sender: nil)
    }

    @IBAction func signUpDidTouch(_ sender: Any) {
    }
}
