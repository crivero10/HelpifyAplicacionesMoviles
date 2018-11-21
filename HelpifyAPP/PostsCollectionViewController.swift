//
//  PostsCollectionViewController.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/2/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

private let reuseIdentifier = "celdaPosts"

class PostsCollectionViewController: UICollectionViewController {
    
    var ref: DatabaseReference! = Database.database().reference()
    let storage = Storage.storage()
    let refresher = UIRefreshControl()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(goodRefresh), for: UIControl.Event.valueChanged)
        refresher.attributedTitle = NSAttributedString(string: "Refresh Collection View", attributes: nil)
        refresher.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresher.attributedTitle = NSAttributedString(string: "Fetching Posts ...", attributes: nil)
        self.tabBarController?.navigationItem.hidesBackButton = true

    }
    
    @objc func goodRefresh(){
        DataManager.data.loadPosts { (didFinish) in}
        collectionView.reloadData()
        refresher.endRefreshing()
    }
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var indexPaths: [NSIndexPath] = []
        for i in 0..<collectionView!.numberOfItems(inSection: 0) {
            indexPaths.append(NSIndexPath(item: i, section: 0))
        }
        collectionView?.reloadItems(at: indexPaths as [IndexPath])
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

        
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return DataManager.data.currentPosts.count
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        if let index = indexPath {
            DataManager.data.clickedPost = indexPath!.item
            print("Clicked")
            self.performSegue(withIdentifier: "postClicked", sender: self)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaPosts", for: indexPath) as! PostCollectionViewCell
        let itemNumber = indexPath.item
        let thisPost = DataManager.data.currentPosts[itemNumber]
        
        celda.institutionLabel.text = thisPost.fullname
        celda.postDescription.text = thisPost.description
        celda.postDescription.setContentOffset(.zero, animated: true)
        celda.dateLabel.text = thisPost.date
        
        if DataManager.data.profileImageCache[thisPost.profileimage as NSString] != nil{
            celda.institutionImage.image = UIImage(data: DataManager.data.profileImageCache[thisPost.profileimage as NSString]! as Data)
        }
        else{
            print("NOT LOADED YET")
        }
        
        print(itemNumber)
        if DataManager.data.postImageCache[thisPost.postimage as NSString] != nil{
            celda.postImage.image = UIImage(data: DataManager.data.postImageCache[thisPost.postimage as NSString]! as Data)
        }
        else{
            print("NOT LOADED YET")
        }
        celda.postDescription.text = thisPost.description
        celda.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
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
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        celda.postDescription.layer.borderWidth = 0.5
        celda.postDescription.layer.borderColor = borderColor.cgColor
        celda.postDescription.layer.cornerRadius = 5.0
        
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
