//
//  HelpifyDonation.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/15/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import Foundation

class HelpifyDonation{
    var donationID : String
    var Fecha_realizado : String
    var Fecha_solicitud : String
    var InstitutionID : String
    var Status : String
    var Numero : String
    var postKey : String
    var userID : String
    var institutionName : String

    init(){
        self.donationID = String(Int.random(in: 0 ..< 100000))+String(Int.random(in: 0 ..< 100000))
        self.Fecha_realizado = "null"
        self.Fecha_solicitud = ""
        self.InstitutionID = "null"
        self.Numero = "0"
        self.Status = "pendiente"
        self.postKey = ""
        self.userID = ""
        self.institutionName = ""
    }
    init(dict : NSDictionary, id : String){
        self.donationID = id
        self.Fecha_solicitud = dict["Fecha_solicitud"] as! String
        self.InstitutionID = dict["InsitutionID"] as! String
        self.Numero = dict["Numero"] as! String
        self.Status = dict["Status"] as! String
        self.postKey = dict["postKey"] as! String
        self.userID = dict["userID"] as! String
        self.institutionName = dict["InstitutionName"] as! String
        self.Fecha_realizado = dict["Fecha_realizdo"] as! String
    }
    func getDict() -> NSDictionary{
        var dict : Dictionary<String, String> = Dictionary<String, String>()
        dict["Fecha_realizdo"] = self.Fecha_realizado
        dict["Fecha_solicitud"] = self.Fecha_solicitud
        dict["InsitutionID"] = self.InstitutionID
        dict["Numero"] = self.Numero
        dict["Status"] = self.Status
        dict["postKey"] = self.postKey
        dict["userID"] = self.userID
        dict["InstitutionName"] = self.institutionName
        return dict as NSDictionary
    }
}
