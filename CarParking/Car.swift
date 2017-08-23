//
//  Car.swift
//  CarParking
//
//  Created by Bonz on 8/16/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class Car {
    
    var id: Int
    var accountID: Int
    var vehicleNumber: String
    
    init() {
        self.id = -1
        self.accountID = -1
        self.vehicleNumber = ""
    }
    
    init(id: Int,accountID: Int, vehicleNumber: String){
        self.id = id
        self.accountID = accountID
        self.vehicleNumber = vehicleNumber
       
    }
}
