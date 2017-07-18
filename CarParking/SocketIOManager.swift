//
//  SocketIOManager.swift
//  CarParking
//
//  Created by Bonz on 7/17/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON
import SCLAlertView

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket = SocketIOClient(socketURL: URL(string: Constants.SERVER_HOST)!, config: [.log(false), .forcePolling(false)])
    
    override init() {
        super.init()
        
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }

    
}
