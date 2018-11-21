//
//  LocationSelectorViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/14/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import MapKit

import FirebaseAuth
import FirebaseDatabase

class LocationSelectorViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let ref = Database.database().reference()
    var annotationReference = MKPointAnnotation()
    var mylatitude = "10.3333333"
    var mylongitude = "99.233333"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(LocationSelectorViewController.handleLongPress))
        lpgr.minimumPressDuration = 0.1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
        // Do any additional setup after loading the view.
    }


    @IBAction func proceedToSelection(_ sender: UIButton) {
        DataManager.data.userID = Auth.auth().currentUser!.uid
        ref.child("Users").child(DataManager.data.userID).updateChildValues(["instLatitud" : mylatitude])
        ref.child("Users").child(DataManager.data.userID).updateChildValues(["instLatitud" : mylongitude])
        DataManager.data.loadUser(completion: { (didFinish) in
            DataManager.data.fetchInstitutionPostsForMe(name: DataManager.data.user.fullname, completion: { (didfinish) in
            })
        })
        DataManager.data.fetchInstitutionLocations()
        DataManager.data.loadDonations()
        DataManager.data.loadPosts(completion: { (didFinish) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.performSegue(withIdentifier: "toHomeNewLocated", sender: nil)
            })
        })
    }
    

    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            self.mapView.removeAnnotations(mapView.annotations)
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            let latitud = "\(locationCoordinate.latitude)"
            mylatitude = latitud
            let longitud = "\(locationCoordinate.longitude)"
            mylongitude = longitud
            let annotation = MKPointAnnotation()
            let coord = CLLocationCoordinate2D(latitude : Double(latitud)!, longitude : Double(longitud)!)
            annotation.coordinate = coord
            self.mapView.addAnnotation(annotation)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
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
