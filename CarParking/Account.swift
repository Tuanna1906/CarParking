//
//  Account.swift
//  CarParking
//
//  Created by Bonz on 8/17/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import Foundation

class Account {
    var id: Int
    var email:String
    var roleID:Int
    
    init() {
        self.id = -1
        self.email = ""
        self.roleID = 0
    }
    
    init(id: Int,email:String,roleID:Int) {
        self.id = id
        self.email = email
        self.roleID = roleID
    }
}
