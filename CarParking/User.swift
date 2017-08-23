//
//  User.swift
//  CarParking
//
//  Created by Bonz on 8/17/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import Foundation

class User {
    var id:Int
    var firstName:String
    var lastName:String
    var phone:String
    var dateOfBirth:String
    var account:Account
    var address:String
    
    init() {
        self.id = -1
        self.firstName = ""
        self.lastName = ""
        self.phone = ""
        self.dateOfBirth = ""
        self.account = Account()
        self.address = ""
    }
    
    init(id:Int,firstName:String,lastName:String,phone:String,dateOfBirth:String,account:Account,address:String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        self.account = account
        self.address = address
    }
    
}
