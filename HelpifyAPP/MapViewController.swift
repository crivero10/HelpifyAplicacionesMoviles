//
//  MapViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/2/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import CoreLocation

class MapViewController: UIViewController {

    var ref: DatabaseReference! = Database.database().reference()
    @IBOutlet weak var institutionsMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerMapOnLocation(CLLocation(latitude : 19.439331, longitude : -99.2044487), mapView: institutionsMap)
        let insts = DataManager.data.institutionLocations.values
        for user in insts{
            let latitud = user.instLatitud
            let longitud = user.instLongitud
            let annotation = MKPointAnnotation()
            let coord = CLLocationCoordinate2D(latitude : Double(latitud)!, longitude : Double(longitud)!)
            annotation.coordinate = coord
            annotation.title = user.fullname as String
            self.institutionsMap.addAnnotation(annotation)
        }
        // Do any additional setup after loading the view.
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        guard let annotation = view.annotation else{
            return
        }
        let urlString = "http://maps.apple.com/?sll=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        guard let url = URL(string: urlString) else{
            return
        }
        print(url)
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


