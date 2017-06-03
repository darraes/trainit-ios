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
        
        Auth.auth().addStateDidChangeListener(
            { auth, user in
                if user != nil {
                    self.successfulLogin(user)
                }
            }
        )

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginDidTouch(_ sender: Any) {
        Auth.auth().signIn(withEmail: textFieldLoginEmail.text!,
                           password: textFieldLoginPassword.text!)
        { user, error in
            if error == nil {
                self.successfulLogin(user)
            }
        }
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
            
            Auth.auth().createUser(withEmail: emailField.text!,
                                   password: passwordField.text!)
            { user, error in
                if error != nil {
                    // TODO proper error handling
                    print(error!)
                }
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
    
    func successfulLogin(_ user: User?) {
        UserAccountManager.Instance.current = UserAccount(user!)
        self.performSegue(
            withIdentifier: LoginViewController.kSuccessLoginSegue,
            sender: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
