//
//  DataManager.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/15/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import CoreData

class DataManager{
    static let data = DataManager()
    var userID : String
    var user : HelpifyUser
    var currentPosts : Array<HelpifyPost>
    var tempPosts : Array<HelpifyPost>
    var MYtempPosts : Array<HelpifyPost>
    var userDonations : Array<HelpifyDonation>
    var usedKeys : Array<String>
    var profileImageCache : Dictionary<NSString, NSData>
    var postImageCache : Dictionary<NSString, NSData>
    var clickedPost : Int
    var latestDonationCode : String
    var latestRetrievedDonation : HelpifyDonation
    var latestPostVisitedInstID : String
    var latestPostVisitedInstPP : String
    var latestInstLatitude : String
    var latestInstLongitude : String
    var institutionLocations : Dictionary<String, HelpifyUser>
    
    init(){
        userID = ""
        user = HelpifyUser()
        userDonations = Array<HelpifyDonation>()
        tempPosts = Array<HelpifyPost>()
        MYtempPosts = Array<HelpifyPost>()
        currentPosts = Array<HelpifyPost>()
        profileImageCache = Dictionary<NSString, NSData>()
        postImageCache = Dictionary<NSString, NSData>()
        clickedPost = 0
        usedKeys = Array<String>()
        latestDonationCode = ""
        latestRetrievedDonation = HelpifyDonation()
        latestPostVisitedInstID = ""
        latestPostVisitedInstPP = ""
        latestInstLatitude = "10.33"
        latestInstLongitude = "99.33"
        institutionLocations = Dictionary<String, HelpifyUser>()
    }
    
    func loadUser(completion: @escaping (Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("Users").child(self.userID).observeSingleEvent(of: .value) { (snapshot) in
            if let usr = snapshot.value as? NSDictionary{
                self.user = HelpifyUser(dict: usr)
                let sref = Storage.storage().reference(forURL: self.user.profileimage)
                sref.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        self.profileImageCache.updateValue(data! as NSData, forKey: self.user.profileimage as NSString)
                        /*let cachedDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                         let filename = self.user.userID + ".jpg"
                         let fileurl = cachedDirectory.appendingPathComponent(filename)
                         if let data = UIImage(data: data!)?.jpegData(compressionQuality: 1),
                         !FileManager.default.fileExists(atPath: fileurl.path) {
                         do {
                         // writes the image data to disk
                         try data.write(to: fileurl)
                         print("file saved")
                         } catch {
                         print("error saving file:", error)
                         }
                         }*/
                        print("LOAD USER FINISHED")
                        completion(true)
                    }
                })
            }
            else{
                /*do {
                    try Auth.auth().signOut()
                    DataManager.data.user = HelpifyUser()
                }
                catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }*/
            }
        }
    }
    func loadPosts(completion : @escaping (Bool) -> Void){
        let ref = Database.database().reference()
        var c = 20
        ref.child("Posts").queryOrdered(byChild: "date").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.reversed(){
                let dict = (child as! DataSnapshot).value as! NSDictionary
                print(dict)
                let key = (child as! DataSnapshot).key
                if !self.usedKeys.contains(key){
                    let thispost = HelpifyPost(dict: dict, postKey: key)
                    self.currentPosts.append(thispost)
                    self.loadProfileAssets(post: thispost)
                    self.loadPostAssets(post: thispost)
                    self.usedKeys.append(key)
                }
                c = c - 1
                if c == 0{
                    break
                }
            }
            completion(true)
        }
    }
    
    func loadProfileAssets(post : HelpifyPost){
        print("DOWNLOADING SOMETHING")
        let s1ref = Storage.storage().reference(forURL: post.profileimage)
        if profileImageCache[post.profileimage as NSString] == nil{
            s1ref.getData(maxSize: 1 * 100000 * 100000, completion: { (data, error) in
                if let error = error {
                    print("ERROR")
                    print(error)
                } else {
                    self.profileImageCache.updateValue(data! as NSData, forKey: post.profileimage as NSString)
                    let cachedDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                    let filename = post.profileimage + ".jpg"
                    let fileurl = cachedDirectory.appendingPathComponent(filename)
                    if let data = UIImage(data: data!)?.jpegData(compressionQuality: 1),
                        !FileManager.default.fileExists(atPath: fileurl.path) {
                        do {
                            // writes the image data to disk
                            try data.write(to: fileurl)
                            print("file saved")
                        } catch {
                            print("error saving file:", error)
                        }
                    }
                }
            })
        }
    }
    
    func loadPostAssets(post : HelpifyPost){
        let s1ref = Storage.storage().reference(forURL: post.postimage)
        if postImageCache[post.postimage as NSString] == nil{
            print("DOWNLOADING SOMETHING")
            s1ref.getData(maxSize: 1 * 100000 * 100000, completion: { (data, error) in
                if let error = error {
                    print("ERROR")
                    print(error)
                } else {
                    self.postImageCache.updateValue(data! as NSData, forKey: post.postimage as NSString)
                    let cachedDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                    let filename = post.postimage + ".jpg"
                    let fileurl = cachedDirectory.appendingPathComponent(filename)
                    if let data = UIImage(data: data!)?.jpegData(compressionQuality: 1),
                        !FileManager.default.fileExists(atPath: fileurl.path) {
                        do {
                            // writes the image data to disk
                            try data.write(to: fileurl)
                            print("file saved")
                        } catch {
                            print("error saving file:", error)
                        }
                    }
                }
            })
        }
    }
    
    func loadDonations(){
        userDonations = Array<HelpifyDonation>()
        let ref = Database.database().reference()
        ref.child("Donaciones").observeSingleEvent(of: .value) { (snapshot) in
            print("LOAD DONATION FINISHED")
            for child in snapshot.children.reversed(){
                let dict = (child as! DataSnapshot).value as! NSDictionary
                //print(dict)
                if dict["userID"] as! String == self.userID{
                    let thisdonation = HelpifyDonation(dict: dict, id: (child as! DataSnapshot).key)
                    self.userDonations.append(thisdonation)
                }
            }
        }
    }
    
    func addDonation(donation : HelpifyDonation, completion: (Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("Donaciones").child(donation.donationID).setValue(donation.getDict())
        completion(true)
    }
    
    func fetchInstitutionPosts(name : String, completion: @escaping (Bool) -> Void){
        tempPosts = Array<HelpifyPost>()
        let ref = Database.database().reference()
        
        ref.child("Posts").queryOrdered(byChild: "fullname").queryEqual(toValue: name).observeSingleEvent(of: .value) { (snapshot) in
            print("aqui")
            for child in snapshot.children.reversed(){
                let dict = (child as! DataSnapshot).value
                let post = HelpifyPost(dict: dict as! NSDictionary, postKey: (child as! DataSnapshot).key)
                self.tempPosts.append(post)
                print("hola")
                print(self.tempPosts)
                self.loadPostAssets(post: post)
            }
            completion(true)
        }
    }
    
    func fetchInstitutionPostsForMe(name : String, completion: @escaping (Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("Posts").queryOrdered(byChild: "fullname").queryEqual(toValue: name).observeSingleEvent(of: .value) { (snapshot) in
            print("aqui")
            for child in snapshot.children.reversed(){
                let dict = (child as! DataSnapshot).value
                let post = HelpifyPost(dict: dict as! NSDictionary, postKey: (child as! DataSnapshot).key)
                self.MYtempPosts.append(post)
                print("hola")
                print(self.MYtempPosts)
                self.loadPostAssets(post: post)
            }
            completion(true)
        }
    }
    
    func fetchInstitutionLocations(){
        let ref = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children{
                let user = (child as! DataSnapshot).value as! NSDictionary
                if user["InstitutionID"] != nil{
                    if user["InstitutionID"] as! String != "null"{
                        self.institutionLocations[user["fullname"] as! String] = HelpifyUser(dict: user)
                    }
                }
                else{
                    self.institutionLocations[user["fullname"] as! String] = HelpifyUser()
                }
            }
        } 
    }
    
}
