//
//  HelpifyUser.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/5/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import Foundation


class HelpifyUser{
    var InstitutionID : String
    var userID : String
    var country : String
    var fullname: String
    var instLatitud: String
    var instLongitud: String
    var profileimage: String
    var username: String
    init(){
        self.InstitutionID = ""
        self.country = ""
        self.fullname = ""
        self.instLatitud = "10.333333"
        self.instLongitud = "-15.666666"
        self.profileimage = ""
        self.username = ""
        self.userID = ""
    }
    init(dict : NSDictionary){
        self.InstitutionID = dict["InstitutionID"] as! String
        self.country = dict["country"] as! String
        self.fullname = dict["fullname"] as! String
        self.instLatitud = dict["instLatitud"] as! String
        self.instLongitud = dict["instLongitud"] as! String
        self.profileimage = dict["profileimage"] as! String
        self.username = dict["username"] as! String
        self.userID = ""
    }


}
