//
//  LoginViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/2/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func logicAction(_ sender: UIButton) {
        self.startAnimation()
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
                DataManager.data.userID = Auth.auth().currentUser!.uid
                DataManager.data.loadUser { (FINISHED) in
                    if FINISHED{
                        DataManager.data.loadPosts { (didFinish) in
                            if didFinish{
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                                    self.stopAnimation()
                                    self.performSegue(withIdentifier: "loginToHome", sender: nil)
                                })
                            }
                        }
                        DataManager.data.fetchInstitutionPostsForMe(name: DataManager.data.user.fullname) { (didFinish) in
                            for post in DataManager.data.MYtempPosts{
                                print(post.fullname)
                            }
                        }
                    }
                }
                DataManager.data.fetchInstitutionLocations()
                DataManager.data.loadDonations()
            }
            else{
                self.stopAnimation()
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func startAnimation(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopAnimation(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
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
