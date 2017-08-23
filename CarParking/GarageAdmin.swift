//
//  GarageAdmin.swift
//  CarParking
//
//  Created by Bonz on 8/22/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class GarageAdmin {
    
    var id: Int
    var name: String
    var address: String
    var totalSlot: Int
    var busySlot: Int
    var locationX: Double
    var locationY: Double
    var accountID: Int
    var timeStart: String
    var timeEnd: String
    var xStatus: Int
    var email: String
    
    
    init() {
        self.id = -1
        self.name = ""
        self.address = ""
        self.totalSlot = 0
        self.busySlot = 0
        self.locationX = -1
        self.locationY = -1
        self.accountID = -1
        self.timeStart = ""
        self.timeEnd = ""
        self.xStatus = -1
        self.email = ""
    }
    
    init(id: Int, name: String, address:String, totalSlot:Int, busySlot:Int, locationX:Double, locationY:Double, accountID:Int, timeStart:String, timeEnd:String, xStatus: Int, email: String){
        self.id = id
        self.name = name
        self.address = address
        self.totalSlot = totalSlot
        self.busySlot = busySlot
        self.locationX = locationX
        self.locationY = locationY
        self.accountID = accountID
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.xStatus = xStatus
        self.email = email
    }
}

