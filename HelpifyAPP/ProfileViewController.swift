//
//  ProfileViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/2/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    var ref: DatabaseReference! = Database.database().reference()
    let storage = Storage.storage()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let userID = Auth.auth().currentUser?.uid
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.usernameLabel.text = value!["username"] as? String
            self.nameLabel.text = value!["fullname"] as? String
            let profileImageRef = self.storage.reference(forURL: value!["profileimage"] as! String)
            profileImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    // Uh-oh, an error occurred!
                } else {
                    let image = UIImage(data: data!)
                    self.profileImageView.image = image
                }
            }
        })*/

        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        let thisuser = DataManager.data.user
        if thisuser.InstitutionID != "null"{
            firstView.isHidden = true
            secondView.isHidden = false
        }
        else{
            firstView.isHidden = false
            secondView.isHidden = true
        }
        if DataManager.data.profileImageCache[DataManager.data.user.profileimage as NSString] != nil{
            profileImageView.image = UIImage(data: DataManager.data.profileImageCache[DataManager.data.user.profileimage as NSString]! as Data)!
        }
        else{
            print("NOT LOADED YET")
        }

        

        usernameLabel.text = DataManager.data.user.username
        nameLabel.text = DataManager.data.user.fullname
        
        // Do any additional setup after loading the view.
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

