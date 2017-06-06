//
//  LoginViewController.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/27/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    static let kSuccessLoginSegue = "ShowPlan"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserAccountManager.Instance.loggedUser(with:
            { user in
                if user != nil {
                    self.successfulLogin()
                }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginDidTouch(_ sender: Any) {
        UserAccountManager.Instance.signIn(
            email: textFieldLoginEmail.text!,
            password: textFieldLoginPassword.text!,
            with: { user, error in
                if error != nil {
                    // TODO error message
                }
                self.successfulLogin()
        })
    }
    
    @IBAction func signUpDidTouch(_ sender: Any) {
        // TODO Signup screen
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default)
        { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            let confirmField = alert.textFields![1]
            
            if (passwordField.text != confirmField.text) {
                // TODO do something
                return
            }
            
            UserAccountManager.Instance.createUser(
                email: emailField.text!,
                password: passwordField.text!)
            { user, error in
                if error != nil {
                    // TODO proper error handling
                    print(error!)
                }
                // TODO login
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)

        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
            textEmail.keyboardType = .emailAddress
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addTextField { confirmPassword in
            confirmPassword.isSecureTextEntry = true
            confirmPassword.placeholder = "Confirm your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func successfulLogin() {
        self.performSegue(
            withIdentifier: LoginViewController.kSuccessLoginSegue,
            sender: nil)
    }
}
