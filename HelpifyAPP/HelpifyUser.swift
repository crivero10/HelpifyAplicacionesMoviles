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
        if dict["InstitutionID"] != nil{
            self.InstitutionID = dict["InstitutionID"] as! String
        }
        else{
            self.InstitutionID = "null"
        }
        
        if dict["country"] != nil{
            self.country = dict["country"] as! String
        }
        else{
            self.country = ""
        }
        
        if dict["fullname"] != nil{
            self.fullname = dict["fullname"] as! String
        }
        else{
            self.fullname = ""
        }
        
        if dict["instLatitud"] != nil{
            self.instLatitud = dict["instLatitud"] as! String
        }
        else{
            self.instLatitud = ""
        }
        
        if dict["instLongitud"] != nil{
            self.instLongitud = dict["instLongitud"] as! String
        }
        else{
            self.instLongitud = ""
        }

        if dict["profileimage"] != nil{
            self.profileimage = dict["profileimage"] as! String
        }
        else{
            self.profileimage = ""
        }
        
        if dict["username"] != nil{
            self.username = dict["username"] as! String
        }
        else{
            self.username = ""
        }

        self.userID = ""
    }


}
