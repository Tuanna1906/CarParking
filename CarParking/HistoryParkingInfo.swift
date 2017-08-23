//
//  HistoryParkingInfo.swift
//  CarParking
//
//  Created by Bonz on 8/16/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class HistoryParkingInfo {
    
    var id: Int
    var car: Car
    var garage: Garage
    var timeBooked: String
    var timeGoIn: String
    var timeGoOut: String
    var parkingStatus: Int
    
    init(id: Int,
         car: Car,
         garage: Garage,
         timeBooked: String,
         timeGoIn: String,
         timeGoOut: String,
         parkingStatus: Int){
        self.id = id
        self.car = car
        self.garage = garage
        self.timeBooked = timeBooked
        self.timeGoIn = timeGoIn
        self.timeGoOut = timeGoOut
        self.parkingStatus = parkingStatus
    }
}
