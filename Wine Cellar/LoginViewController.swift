//
//  LoginViewController.swift
//  Wine Cellar
//
//  Created by Stefan Pel on 21-03-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Actions
    @IBAction func loginButtonTouched(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!) { (user, error) in
            if error == nil {
                // go to next view
                self.performSegue(withIdentifier: "login", sender: nil)
                
            }
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    FIRAuth.auth()!.signIn(withEmail: emailField.text!, password: passwordField.text!)
                    self.performSegue(withIdentifier: "login", sender: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

