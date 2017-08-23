//
//  NearestGarage.swift
//  CarParking
//
//  Created by Bonz on 8/10/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class NearestGarage: Garage {
    
    var distance: String
    var distanceValue: Int
    var duration: String
    var durationValue: Int
    var url: String
    
    
    init(id: Int, name: String, address:String, totalSlot:Int, busySlot:Int, locationX:Double, locationY:Double, accountID:Int, timeStart:String, timeEnd:String, xStatus: Int, distance: String,distanceValue:Int, duration: String, durationValue:Int, url: String){
        
        self.distance = distance
        self.distanceValue = distanceValue
        self.duration = duration
        self.durationValue = durationValue
        self.url = url
        super.init(id: id, name: name, address: address, totalSlot: totalSlot, busySlot: busySlot, locationX: locationX, locationY: locationY, accountID: accountID, timeStart: timeStart, timeEnd: timeEnd, xStatus: xStatus)
        
    }
}
