//
//  InsDetailViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/20/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import MapKit

class InsDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImagw: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.profileImagw.layer.cornerRadius = self.profileImagw.frame.size.width / 2;
        self.profileImagw.clipsToBounds = true;
        if DataManager.data.profileImageCache[DataManager.data.latestPostVisitedInstPP as NSString] != nil{
            profileImagw.image = UIImage(data: DataManager.data.profileImageCache[DataManager.data.latestPostVisitedInstPP as NSString]! as Data)
        }
        else{
            print("NOT LOADED YET")
        }
        nameLabel.text = DataManager.data.latestPostVisitedInstID
    }
    
    @IBAction func getDirectionsActionButton(_ sender: UIButton) {
        let thisuser = DataManager.data.institutionLocations[DataManager.data.latestPostVisitedInstID]
        let latitude = thisuser?.instLatitud
        let longitude = thisuser?.instLongitud
        let coordinate = CLLocationCoordinate2DMake(Double(latitude!)!, Double(longitude!)!)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.02))
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
        mapItem.name = thisuser?.fullname
        mapItem.openInMaps(launchOptions: options)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return DataManager.data.tempPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "abrigedPost", for: indexPath) as! AbrigedPostCollectionViewCell
        let itemNumber = indexPath.item
        let thisPost = DataManager.data.tempPosts[itemNumber]
        
        celda.dateLabel.text = thisPost.date
        celda.detailText.text = thisPost.description
        
        if DataManager.data.postImageCache[thisPost.postimage as NSString] != nil{
            celda.postImage.image = UIImage(data: DataManager.data.postImageCache[thisPost.postimage as NSString]! as Data)
        }
        else{
            print("NOT LOADED YET")
        }
        
        
        /*celda.contentView.layer.cornerRadius = 10
         celda.contentView.layer.borderWidth = 1.0
         celda.contentView.layer.borderColor = UIColor.clear.cgColor
         celda.contentView.layer.masksToBounds = true
         celda.layer.shadowColor = UIColor.gray.cgColor
         celda.layer.shadowOffset = CGSize(width: 0, height: 2.0)
         celda.layer.shadowRadius = 3.0
         celda.layer.shadowOpacity = 1.0
         celda.layer.masksToBounds = false
         celda.layer.shadowPath = UIBezierPath(roundedRect:celda.bounds, cornerRadius:celda.contentView.layer.cornerRadius).cgPath*/
        
        celda.contentView.layer.cornerRadius = 10
        celda.contentView.layer.borderWidth = 3
        celda.contentView.layer.borderColor = UIColor.clear.cgColor
        celda.contentView.layer.masksToBounds = true
        celda.layer.shadowColor = UIColor.lightGray.cgColor
        celda.layer.shadowOffset = CGSize(width: 2, height: 2.0)
        celda.layer.shadowRadius = 2.0
        celda.layer.shadowOpacity = 4
        celda.layer.masksToBounds = false
        celda.layer.shadowPath = UIBezierPath(roundedRect: celda.bounds, cornerRadius: celda.contentView.layer.cornerRadius).cgPath
        
        
        
        
        
        /*ref.child("Posts").queryOrdered(byChild: "date").observeSingleEvent(of: .value) { (snapshot) in
         var counter = 0
         for child in snapshot.children.reversed() {
         let snap = child as! DataSnapshot
         let value = snap.value as! NSDictionary
         if itemNumber == counter{
         celda.institutionLabel.text = value["fullname"] as? String
         celda.postDescription.text = value["description"] as? String
         celda.dateLabel.text = value["date"] as? String
         let profileImageRef = self.storage.reference(forURL: value["profileimage"] as! String)
         let postImageRef = self.storage.reference(forURL: value["postimage"] as! String)
         profileImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
         if let error = error {
         // Uh-oh, an error occurred!
         } else {
         // Data for "images/island.jpg" is returned
         let image = UIImage(data: data!)
         celda.institutionImage.image = image
         }
         }
         postImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
         if let error = error {
         // Uh-oh, an error occurred!
         } else {
         // Data for "images/island.jpg" is returned
         let image = UIImage(data: data!)
         celda.postImage.image = image
         }
         }
         }
         counter = counter + 1
         }
         }*/
        
        return celda
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
