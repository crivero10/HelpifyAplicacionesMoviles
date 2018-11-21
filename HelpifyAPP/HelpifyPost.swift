//
//  HelpifyPost.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/15/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import Foundation

class HelpifyPost{
    var postKey : String
    var date : String
    var description : String
    var fullname : String
    var postimage : String
    var profileimage : String
    var time : String
    var uid : String
    init(dict : NSDictionary, postKey: String){
        self.postKey = postKey
        self.date = dict["date"] as! String
        self.description = dict["description"] as! String
        self.fullname = dict["fullname"] as! String
        self.postimage = dict["postimage"] as! String
        self.profileimage = dict["profileimage"] as! String
        self.time = dict["time"] as! String
        self.uid = dict["uid"] as! String
    }
}
