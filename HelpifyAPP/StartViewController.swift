//
//  StartViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/2/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import FirebaseAuth
class StartViewController: UIViewController {

    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signupButtonOutlet: UIButton!
    
    @IBOutlet weak var labelMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMessage.isHidden = true
        loginButtonOutlet.isHidden = true
        signupButtonOutlet.isHidden = true
        if Reachability.isConnectedToNetwork(){
            if Auth.auth().currentUser != nil {
                labelMessage.isHidden = false
                loginButtonOutlet.isHidden = true
                signupButtonOutlet.isHidden = true
                startAnimation()
                DataManager.data.userID = Auth.auth().currentUser!.uid
                DataManager.data.loadUser { (FINISHED) in
                    if FINISHED{
                        DataManager.data.loadPosts { (didFinish) in
                            if didFinish{
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                    self.stopAnimation()
                                    self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
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
                labelMessage.isHidden = true
                loginButtonOutlet.isHidden = false
                signupButtonOutlet.isHidden = false
            }
        }
        else{
            labelMessage.isHidden = false
            labelMessage.text = "You need an internet connection to use Helpify"
        }
        
        // Do any additional setup after loading the view.
    }
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
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
