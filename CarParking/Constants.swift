//
//  Constants.swift
//  CarParking
//
//  Created by Bonz on 7/17/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import Foundation

struct Constants {
    
    static let SERVER_HOST = "http://192.168.1.11:5000"
    
    struct GoogleMapApi {
        static let kPlacesAPIKey = "AIzaSyDbLHMOOmVqSNVPeR548e6PQZzJkNZylCw"
        static let kMapsAPIKey = "AIzaSyDQDUR7sRTUrnoTTRRip1iETg7gNJazxXk"
    }
    
    struct Account {
        static let REQUEST_LOGIN_WITH_EMAIL_AND_PASS = "check_email_and_password"
        static let REQUEST_CREATE_NEW_ACCOUNT = "request_create_account"
        static let REQUEST_RESET_PASSWORD = "request_reset_password"
        static let REQUEST_CHANGE_PASSWORD = "request_change_password"
        static let REQUEST_GET_SALT = "request_get_salt"
        static let RESPONSE_GET_SALT = "response_get_salt"
        
        static let RESPONSE_LOGIN_WITH_EMAIL_AND_PASS = "result_login"
        static let RESPONSE_CREATE_NEW_ACCOUNT  = "response_create_account"
        static let RESPONSE_RESET_PASSWORD = "response_reset_password"
        static let RESPONSE_CHANGE_PASSWORD = "response_change_password"
    }
    
    
    
}
