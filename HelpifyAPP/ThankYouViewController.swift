//
//  ThankYouViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/19/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var donationCodeLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fullnameLabel.text = DataManager.data.user.fullname
        donationCodeLabel.text = DataManager.data.latestDonationCode
        // Do any additional setup after loading the view.
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        if DataManager.data.profileImageCache[DataManager.data.user.profileimage as NSString] != nil{
            profileImageView.image = UIImage(data: DataManager.data.profileImageCache[DataManager.data.user.profileimage as NSString]! as Data)!
        }
        else{
            print("NOT LOADED YET")
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
