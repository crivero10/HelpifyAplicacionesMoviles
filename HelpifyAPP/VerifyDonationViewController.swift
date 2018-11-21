//
//  VerifyDonationViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/19/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class VerifyDonationViewController: UIViewController {

    @IBOutlet weak var donationCodeTextField: UITextField!
    @IBOutlet weak var statusCommand: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        statusCommand.isHidden = true
        startDateLabel.isHidden = true
        endDateLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func retrieveButton(_ sender: Any) {
        let now = Date()
        let formatterA = DateFormatter()
        formatterA.timeZone = TimeZone.current
        formatterA.dateFormat = "yyyy-MM-dd"
        let formatterB = DateFormatter()
        formatterB.timeZone = TimeZone.current
        formatterB.dateFormat = "HH-mm"
        let date = formatterA.string(from: now)
        let time = formatterB.string(from: now)
        let code = donationCodeTextField.text
        let ref = Database.database().reference()
        if code!.contains("$") || code!.contains("[") || code!.contains("]") || code!.contains("#") || code!.contains(".") || code! == ""{
            self.startDateLabel.isHidden = true
            self.endDateLabel.isHidden = true
            self.statusCommand.isHidden = false
            self.statusCommand.text = "Donation not found"
            self.statusCommand.textColor = UIColor.red
        }
        else{
            ref.child("Donaciones").child(code!).observeSingleEvent(of: .value, with: { (snapshot) in
                print("Hola")
                if let dict : NSDictionary = snapshot.value as? NSDictionary{
                    print("Hello")
                    print(dict["InsitutionID"] as! String)
                    print(DataManager.data.user.userID)
                    if dict["InsitutionID"] as! String == Auth.auth().currentUser?.uid{
                        let numero = Int(dict["Numero"] as! String)
                        self.statusCommand.text = "Donation successfully confirmed"
                        self.statusCommand.textColor = UIColor.green
                        ref.child("Donaciones").child(code!).updateChildValues(["Fecha_realizdo" : date])
                        ref.child("Donaciones").child(code!).updateChildValues(["Status" : "Realizado"])
                        ref.child("Donaciones").child(code!).updateChildValues(["Numero" : "\(numero!+1)"])
                        self.startDateLabel.text = "Donation started on "+(dict["Fecha_solicitud"] as! String)
                        self.endDateLabel.text = "Donation verified on "+date
                        self.statusCommand.isHidden = false
                        self.startDateLabel.isHidden = false
                        self.endDateLabel.isHidden = false
                    }
                    else{
                        self.startDateLabel.isHidden = true
                        self.endDateLabel.isHidden = true
                        self.statusCommand.isHidden = false
                        self.statusCommand.text = "Donation not found"
                        self.statusCommand.textColor = UIColor.red
                    }
                    
                }
                else{
                    self.startDateLabel.isHidden = true
                    self.endDateLabel.isHidden = true
                    self.statusCommand.isHidden = false
                    self.statusCommand.text = "Donation not found"
                    self.statusCommand.textColor = UIColor.red
                }
                
            }) { (Error) in
                
            }
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

