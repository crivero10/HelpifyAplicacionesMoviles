//
//  PostDetailViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/16/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var institutionDetailButton: UIButton!
    @IBOutlet weak var PostImageView: UIImageView!
    @IBOutlet weak var institutionNameLabel: UILabel!
    @IBOutlet weak var postDescriptionTextView: UITextView!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var donateButtonOutlet: UIButton!
    let thispost = DataManager.data.currentPosts[DataManager.data.clickedPost]
    var date = ""
    var time = ""
    
    @IBAction func institutionDetailAction(_ sender: UIButton) {
        DataManager.data.latestPostVisitedInstID = thispost.fullname
        DataManager.data.latestPostVisitedInstPP = thispost.profileimage
        self.startAnimation()
        DataManager.data.fetchInstitutionPosts(name: thispost.fullname) { (didFinish) in
            self.stopAnimation()
            self.performSegue(withIdentifier: "theFireRises", sender: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DataManager.data.user.InstitutionID != "null"{
            donateButtonOutlet.isHidden = true
        }
        if DataManager.data.postImageCache[thispost.postimage as NSString] != nil{
            PostImageView.image = UIImage(data: DataManager.data.postImageCache[thispost.postimage as NSString]! as Data)
        }
        else{
            print("NOT LOADED YET")
        }

        if DataManager.data.profileImageCache[thispost.profileimage as NSString] != nil{
            ProfileImageView.image = UIImage(data: DataManager.data.profileImageCache[thispost.profileimage as NSString]! as Data)
        }
        else{
            print("NOT LOADED YET")
        }

        institutionNameLabel.text = thispost.fullname
        postDescriptionTextView.text = thispost.description
        dateLabel.text = thispost.date
        let now = Date()
        let formatterA = DateFormatter()
        formatterA.timeZone = TimeZone.current
        formatterA.dateFormat = "yyyy-MM-dd"
        let formatterB = DateFormatter()
        formatterB.timeZone = TimeZone.current
        formatterB.dateFormat = "HH-mm"
        date = formatterA.string(from: now)
        time = formatterB.string(from: now)
        var borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        postDescriptionTextView.layer.borderWidth = 0.5
        postDescriptionTextView.layer.borderColor = borderColor.cgColor
        postDescriptionTextView.layer.cornerRadius = 5.0
        institutionDetailButton.setTitle("More about this organization", for: UIControl.State.normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func donateButtonAction(_ sender: UIButton) {
        var capable : Bool = true
        for donation in DataManager.data.userDonations{
            if donation.postKey == thispost.postKey && donation.Status == "pendiente"{
                capable = false
            }
        }
        if capable{
            let newDonation = HelpifyDonation()
            newDonation.Fecha_solicitud = date
            newDonation.institutionName = thispost.fullname
            newDonation.InstitutionID = thispost.uid
            newDonation.userID = DataManager.data.userID
            newDonation.postKey = thispost.postKey
            newDonation.InstitutionID = thispost.uid
            startAnimation()
            DataManager.data.addDonation(donation: newDonation) { (didFinish) in
                DataManager.data.latestDonationCode = newDonation.donationID
                DataManager.data.loadDonations()
                stopAnimation()
                self.performSegue(withIdentifier: "thankyou", sender: nil)
            }
        }
        else{
            let alertController = UIAlertController(title: "Previous donation exists", message: "You have already donated to this post. Please complete said donation before starting a new one", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
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
