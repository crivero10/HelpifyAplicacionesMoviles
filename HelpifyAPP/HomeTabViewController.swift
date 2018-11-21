//
//  HomeTabViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/2/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeTabViewController: UITabBarController {

    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var verifyButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DataManager.data.user.InstitutionID == "null"{
            verifyButton.isEnabled = false
            verifyButton.tintColor = .clear
            postButton.isEnabled = false
            postButton.tintColor = .clear
            
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func postPrompt(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "userIsInstitution", sender: nil)
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
