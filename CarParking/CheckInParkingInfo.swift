//
//  CheckInParkingInfo.swift
//  CarParking
//
//  Created by Bonz on 8/21/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import Foundation

class CheckInParkingInfo {
    
    var id: Int
    var carID: Int
    var garageID: Int
    var timeBooked: String
    var timeGoIn: String
    var timeGoOut: String
    var parkingStatus: Int
    var vehicleNumber: String
    
    
    init(id: Int,
        carID: Int,
        garageID: Int,
        timeBooked: String,
        timeGoIn: String,
        timeGoOut: String,
        parkingStatus: Int,
        vehicleNumber: String){
        self.id = id
        self.carID = carID
        self.garageID = garageID
        self.timeBooked = timeBooked
        self.timeGoIn = timeGoIn
        self.timeGoOut = timeGoOut
        self.parkingStatus = parkingStatus
        self.vehicleNumber = vehicleNumber
    }
}
