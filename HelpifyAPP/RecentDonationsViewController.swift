//
//  RecentDonationsViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/15/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecentDonationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var ref = Database.database().reference()
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.data.userDonations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaMex", for: indexPath)
        print(DataManager.data.userDonations.count)
        let thisdonation = DataManager.data.userDonations[indexPath.item]
        celda.textLabel?.text = thisdonation.institutionName
        print(thisdonation.institutionName)
        var text = ""
        if thisdonation.Status != "pendiente"{
            text = "Donation confirmed on "+thisdonation.Fecha_realizado
        }
        else{
            text = "Donation not yet confirmed."+" Code: "+thisdonation.donationID
        }
        celda.detailTextLabel?.text = text
        
        
        //print(thisdonation.institutionName)
        //celda.institutionName.text = thisdonation.institutionName
        //celda.status.text = thisdonation.Status
        //celda.date.text = thisdonation.Fecha_solicitud
        print("Hi")
        return celda
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
