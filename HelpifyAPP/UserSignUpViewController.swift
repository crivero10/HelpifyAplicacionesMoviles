//
//  UserSignUpViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/4/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class UserSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var email : String = ""
    var password : String = ""
    var conutryField : String = ""
    var type : Bool = true
    var imageUploaded : Bool = false
    var profileImage : UIImage = UIImage()
    var imagePicker = UIImagePickerController()
    var ref: DatabaseReference! = Database.database().reference()
    var storageRef = Storage.storage().reference()
    let pickData = ["Mexico", "United States of America", "Canada", "Spain", "Bangladesh", "Japan", "Australia", "Other"]
    var latimex = "10.333333"
    var longimex = "50.66666"
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var variantLable: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var variantTextField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var picky: UIPickerView!
    @IBOutlet weak var optionSelector: UISegmentedControl!
    @IBOutlet weak var locationMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        imagePicker.delegate = self
        if type{
            nameLabel.text = "Name of your social institution"
            variantLable.text = "Institution ID"
        }
        else{
            optionSelector.isHidden = true
            locationMessage.isHidden = true
        }
        picky.delegate = self
        picky.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.conutryField = pickData[row]
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select a source", message: "Passwords do not match", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                alert.popoverPresentationController?.sourceView = sender
                alert.popoverPresentationController?.sourceRect = sender.bounds
                alert.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func continueButton(_ sender: Any) {
        
        if imageUploaded{
            startAnimation()
            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) -> Void in
                if (error == nil) {
                    
                    let data = self.profileImage.jpegData(compressionQuality: 0.05)! as NSData
                    let currentUID = Auth.auth().currentUser?.uid
                    let photoRef = self.storageRef.child("Profile Images").child(currentUID! + ".jpg")
                    photoRef.putData(data as Data, metadata: nil, completion: { (meta, error) in
                        photoRef.downloadURL(completion: { (url, error) in
                            if let myurl = url?.absoluteString{
                                self.ref.child("Users").child(currentUID!).updateChildValues(["username" : self.usernameField.text!])
                                if self.type{
                                    if self.optionSelector.selectedSegmentIndex == 0{
                                        self.locationManager.requestAlwaysAuthorization()
                                        self.locationManager.requestWhenInUseAuthorization()
                                        if CLLocationManager.locationServicesEnabled() {
                                            self.locationManager.delegate = self
                                            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                                            self.locationManager.startUpdatingLocation()
                                        }
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["fullname" : self.nameTextField.text!])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["InstitutionID" :self.variantTextField.text!])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["country" : self.conutryField])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["profileimage" : myurl])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["instLatitud" : self.latimex])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["instLongitud" : self.longimex])
                                        DataManager.data.userID = Auth.auth().currentUser!.uid
                                        DataManager.data.loadUser(completion: { (didFinish) in
                                            DataManager.data.fetchInstitutionPostsForMe(name: DataManager.data.user.fullname, completion: { (didfinish) in
                                            })
                                        })
                                        DataManager.data.fetchInstitutionLocations()
                                        DataManager.data.loadDonations()
                                        DataManager.data.loadPosts(completion: { (didFinish) in
                                            self.stopAnimation()
                                            self.performSegue(withIdentifier: "gohome", sender: nil)
                                        })
                                    }
                                    else{
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["fullname" : self.nameTextField.text!])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["InstitutionID" :self.variantTextField.text!])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["country" : self.conutryField])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["profileimage" : myurl])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["instLatitud" : self.latimex])
                                        self.ref.child("Users").child(currentUID!).updateChildValues(["instLongitud" : self.longimex])
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                                            self.stopAnimation()
                                            self.performSegue(withIdentifier: "toLocationSelector", sender: nil)
                                        })
                                    }
                                }
                                else{
                                    self.ref.child("Users").child(currentUID!).updateChildValues(["fullname" : self.nameTextField.text!+" "+self.variantTextField.text!])
                                    self.ref.child("Users").child(currentUID!).updateChildValues(["InstitutionID" : "null"])
                                    self.ref.child("Users").child(currentUID!).updateChildValues(["country" : self.conutryField])
                                    self.ref.child("Users").child(currentUID!).updateChildValues(["profileimage" : myurl])
                                    self.ref.child("Users").child(currentUID!).updateChildValues(["instLatitud" : "null"])
                                    self.ref.child("Users").child(currentUID!).updateChildValues(["instLongitud" : "null"])
                                    DataManager.data.userID = Auth.auth().currentUser!.uid
                                    DataManager.data.loadUser(completion: { (didFinish) in
                                        DataManager.data.fetchInstitutionPostsForMe(name: DataManager.data.user.fullname, completion: { (didfinish) in
                                        })
                                    })
                                    DataManager.data.fetchInstitutionLocations()
                                    DataManager.data.loadDonations()
                                    DataManager.data.loadPosts(completion: { (didFinish) in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                                            self.stopAnimation()
                                            self.performSegue(withIdentifier: "gohome", sender: nil)
                                        })
                                    })
                                }
                            }
                        })
                    })
                    
                }
                else{
                    print("el error \(String(describing: error))")
                }
            })
        }
        else{
            let alert = UIAlertController(title: "No profile picture", message: "You must succesfully upload a profile picture first", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.profileImage = selectedImage
        self.imageUploaded = true
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latimex = "\(locValue.latitude)"
        longimex = "\(locValue.longitude)"
    }


}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
