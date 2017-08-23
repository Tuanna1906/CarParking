//
//  SecurityOfGarage.swift
//  CarParking
//
//  Created by Bonz on 8/23/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import Foundation

class SecurityOfGarage {
    var id:Int
    var firstName:String
    var lastName:String
    var phone:String
    var dateOfBirth:String
    var email:String
    var address:String
    var roleID:Int
    
    init() {
        self.id = -1
        self.firstName = ""
        self.lastName = ""
        self.phone = ""
        self.dateOfBirth = ""
        self.email = ""
        self.address = ""
        self.roleID = 0
    }
    
    init(id:Int,firstName:String,lastName:String,phone:String,dateOfBirth:String,email:String,address:String, roleID:Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.address = address
        self.roleID = roleID
    }
    
}
