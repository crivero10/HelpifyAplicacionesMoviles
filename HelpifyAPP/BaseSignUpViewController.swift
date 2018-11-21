//
//  BaseSignUpViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/4/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import FirebaseAuth

class BaseSignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var institutionSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UserSignUpViewController{
            let secondViewController = segue.destination as! UserSignUpViewController
            secondViewController.email = emailTextField.text!
            secondViewController.password = passwordTextField.text!
            if !institutionSwitch.isOn{
                secondViewController.type = false
            }
        }
    }
    
    @IBAction func continueButton(_ sender: Any) {
        if ((passwordTextField.text == confirmationTextField.text) && passwordTextField.text != "" && emailTextField.text != ""){
            if institutionSwitch.isOn{
                self.performSegue(withIdentifier: "institutionSignUp", sender: nil)
            }
            else{
                self.performSegue(withIdentifier: "newUserNotInstitution", sender: nil)
            }
        }
        else if passwordTextField.text != confirmationTextField.text{
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Error", message: "One or more fields are empty or invalid, password lenght must be at least 6 characters", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
