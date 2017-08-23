//
//  Profile.swift
//  CarParking
//
//  Created by Bonz on 8/6/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit

class Instances {
    static let sharedInstance = Instances()
    
    var accountID = -1
    var email = ""
    var role = 0
    var selectedGarageID = -1
    var garageID = -1
    var newAdmin = ""
    var newAdminId = -1
    var garageIDBooking = -1
    var bookingInfoID = -1
    private init() {}

}
