//
//  Constants.swift
//  CarParking
//
//  Created by Bonz on 7/17/17.
//  Copyright © 2017 Bonz. All rights reserved.
//

import Foundation

struct Constants {
    
    //static let SERVER_HOST = "http://52.15.194.52:5000"
    //static let SERVER_HOST = "http://192.168.1.8:5000"
    static let SERVER_HOST = "http://127.0.0.1:5000"
    
    struct GoogleMapApi {
        static let kPlacesAPIKey = "AIzaSyDzl1j7XaQhpqDl7hr_w7Ae5iv9XfXKEhA"
        static let kMapsAPIKey = "AIzaSyDzl1j7XaQhpqDl7hr_w7Ae5iv9XfXKEhA"
    }
    
    struct Account {
        static let REQUEST_LOGIN_WITH_EMAIL_AND_PASS = "check_email_and_password"
        static let REQUEST_CREATE_NEW_ACCOUNT = "request_create_account"
        static let REQUEST_RESET_PASSWORD = "request_reset_password"
        static let REQUEST_CHANGE_PASSWORD = "request_change_password"
        static let REQUEST_CHECK_TOKEN = "request_check_token"
        static let REQUEST_COMPARE_CODE = "request_compare_code"
        static let REQUEST_GET_ACCOUNT_ID_BY_EMAIL = "request_get_account_id_by_email"
        static let REQUEST_REMOVE_ACCOUNT_BY_ID = "request_remove_account_by_id"
        static let RESPONSE_REMOVE_ACCOUNT_BY_ID = "response_remove_account_by_id"
        
        static let RESPONSE_COMPARE_CODE = "response_compare_code"
        static let RESPONSE_CHECK_TOKEN = "response_check_token"
        static let RESPONSE_GET_SALT = "response_get_salt"
        static let RESPONSE_LOGIN_WITH_EMAIL_AND_PASS = "result_login"
        static let RESPONSE_CREATE_NEW_ACCOUNT  = "response_create_account"
        static let RESPONSE_RESET_PASSWORD = "response_reset_password"
        static let RESPONSE_CHANGE_PASSWORD = "response_change_password"
        static let RESPONSE_GET_ACCOUNT_ID_BY_EMAIL = "response_get_account_id_by_email"
        
        static let REQUEST_CREATE_ACCOUNT_SECURITY = "request_create_new_account_for_security"
        static let RESPONSE_CREATE_ACCOUNT_SECURITY = "response_create_new_account_for_security"
        
        static let REQUEST_LOG_OUT = "request_log_out"
        static let RESPONSE_LOG_OUT = "response_log_out"
    }
    
    struct Garage {
        static let REQUEST_ADD_NEW_GARAGE = "request_add_new_garage"
        static let REQUEST_GET_ALL_GARAGES = "request_all_garages"
        static let REQUEST_GET_GARAGE_BY_ID = "request_get_garage_by_id"
        static let REQUEST_GET_GARAGE_BY_ACCOUNT_ID = "request_get_garage_by_account_id"
        static let REQUEST_EDIT_GARAGE_BY_ID = "request_edit_garage_by_id"
        static let REQUEST_EDIT_STATUS_GARAGE_BY_ID = "request_edit_status_garage_by_id"
        static let REQUEST_GET_ALL_GARAGES_AND_ADMIN = "request_all_garages_and_admin"
        
        static let RESPONSE_ADD_NEW_GARAGE = "response_add_new_garage"
        static let RESPONSE_GET_ALL_GARAGE = "response_all_garages"
        static let RESPONSE_GET_GARAGE_BY_ID = "response_get_garage_by_id"
        static let RESPONSE_GET_GARAGE_BY_ACCOUNT_ID = "response_get_garage_by_account_id"
        static let RESPONSE_EDIT_GARAGE_BY_ID = "response_edit_garage_by_id"
        static let RESPONSE_GET_ALL_GARAGES_AND_ADMIN = "response_all_garages_and_admin"
        static let RESPONSE_EDIT_STATUS_GARAGE_BY_ID = "response_edit_staus_garage_by_id"
        static let RESPONSE_GARAGE_UPDATED = "response_garage_updated"
    }
    
    struct Car {
        static let REQUEST_ADD_NEW_CAR = "request_add_new_car"
        static let REQUEST_REMOVE_CAR = "request_remove_car_by_vehicle_number"
        static let REQUEST_FIND_CAR_BY_ACCOUNT_ID = "request_find_car_by_account_id"
        static let REQUEST_FIND_CAR_BY_ID = "request_find_car_by_id"
        static let REQUEST_EDIT_VEHICLE_BY_NUMBER = "request_change_vehicle_by_number"
        static let REQUEST_REMOVE_CAR_BY_ID = "request_remove_car_by_id"
        
        static let RESPONSE_ADD_NEW_CAR = "response_add_new_car"
        static let RESPONSE_REMOVE_CAR = "response_remove_car_by_vehicle_number"
        static let RESPONSE_FIND_CAR_BY_ACCOUNT_ID = "response_find_car_by_account_id"
        static let RESPONSE_FIND_CAR_BY_ID = "response_find_car_by_id"
        static let RESPONSE_EDIT_VEHICLE_BY_NUMBER = "response_change_vehicle_by_number"
        static let RESPONSE_REMOVE_CAR_BY_ID = "response_remove_car_by_id"
    }
    
    struct USER {
        static let REQUEST_ADD_NEW_USER = "request_add_new_user"
        static let REQUEST_ADD_NEW_USER_BY_ACCOUNT_ID = "request_add_new_user_by_account_id"
        static let REQUEST_REMOVE_USER_BY_ID = "request_remove_user_by_id"
        static let REQUEST_FIND_USER_BY_ID = "request_find_user_by_id"
        static let REQUEST_FIND_USER_BY_ACCOUNT_ID = "request_find_user_by_account_id"
        static let REQUEST_EDIT_USER_BY_ID = "request_edit_user_by_id"
        
        static let RESPONSE_ADD_NEW_USER = "response_add_new_user"
        static let RESPONSE_ADD_NEW_USER_BY_ACCOUNT_ID = "request_add_new_user_by_account_id"
        static let RESPONSE_REMOVE_USER_BY_ID = "response_remove_user_by_id"
        static let RESPONSE_FIND_USER_BY_ID = "response_find_user_by_id"
        static let RESPONSE_FIND_USER_BY_ACCOUNT_ID = "response_find_user_by_account_id"
        static let RESPONSE_EDIT_USER_BY_ID = "response_edit_user_by_id"
        
    }
    
    struct BOOKING {
        static let REQUEST_ADD_NEW_BOOKING = "request_add_new_booking"
        static let REQUEST_REMOVE_BOOKING_BY_ID = "request_remove_booking_by_id"
        static let REQUEST_FIND_BOOKING_BY_ID = "request_find_booking_by_id"
        static let REQUEST_FIND_BOOKING_BY_CAR_ID = "request_find_booking_by_car_id"
        static let REQUEST_FIND_BOOKING_BY_GARAGE_ID = "request_find_booking_by_garage_id"
        static let REQUEST_EDIT_BOOKING_TIME_GO_IN_BY_ID = "request_edit_booking_time_go_in_by_id"
        static let REQUEST_EDIT_BOOKING_TIME_GO_OUT_BY_ID = "request_edit_booking_time_go_out_by_id"
        static let REQUEST_BOOKING_BY_ACCOUNT_ID = "request_booking_account_id"
        
        static let RESPONSE_ADD_NEW_BOOKING = "response_add_new_booking"
        static let RESPONSE_REMOVE_BOOKING_BY_ID = "response_remove_booking_by_id"
        static let RESPONSE_FIND_BOOKING_BY_ID = "response_find_booking_by_id"
        static let RESPONSE_FIND_BOOKING_BY_CAR_ID = "response_find_booking_by_car_id"
        static let RESPONSE_FIND_BOOKING_BY_GARAGE_ID = "response_find_booking_by_garage_id"
        static let RESPONSE_EDIT_BOOKING_TIME_GO_IN_BY_ID = "response_edit_booking_time_go_in_by_id"
        static let RESPONSE_EDIT_BOOKING_TIME_GO_OUT_BY_ID = "response_edit_booking_time_go_out_by_id"
        static let RESPONSE_BOOKING_BY_ACCOUNT_ID = "response_booking_account_id"
    }
    
    struct PARKING_INFO {
        static let REQUEST_ADD_NEW_PARKING_INFO = "request_add_new_booking"
        static let REQUEST_ADD_NEW_PARKING_INFO_BY_USER = "request_add_new_booking_by_user"
        static let REQUEST_REMOVE_PARKING_INFO_BY_ID = "request_remove_booking_by_id"
        static let REQUEST_FIND_PARKING_INFO_BY_ID = "request_find_booking_by_id"
        static let REQUEST_FIND_PARKING_INFO_BY_CAR_ID = "request_find_booking_by_car_id"
        static let REQUEST_FIND_PARKING_INFO_BY_GARAGE_ID = "request_find_booking_by_garage_id"
        static let REQUEST_EDIT_PARKING_INFO_TIME_GO_IN_BY_ID = "request_edit_booking_time_go_in_by_id"
        static let REQUEST_EDIT_PARKING_INFO_TIME_GO_OUT_BY_ID = "request_edit_booking_time_go_out_by_id"
        static let REQUEST_PARKING_INFO_HISTORY_BY_ACCOUNT_ID = "request_booking_history_account_id"
        static let REQUEST_PARKING_INFO_BY_ACCOUNT_ID = "request_booking_account_id"
        static let REQUEST_EDIT_PARKING_INFO_BY_ID_STATUS = "request_edit_parking_info_id_status"
        static let REQUEST_REFRESH_BOOKING_TIMEOUT = "request_refresh_booking_timeout"
        
        static let REQUEST_CAR_GO_IN = "request_car_go_in"
        static let REQUEST_CAR_GO_OUT = "request_car_go_out"
        static let REQUEST_CAR_IN_ID = "request_one_car_in_by_id"
        static let REQUEST_CAR_IN_NUMBER = "request_one_car_in_by_vehicle_number"
        static let REQUEST_CAR_OUT = "request_one_car_out"
        
        static let RESPONSE_ADD_NEW_PARKING_INFO = "response_add_new_booking"
        static let RESPONSE_ADD_NEW_PARKING_INFO_BY_USER = "response_add_new_booking_by_user"
        static let RESPONSE_REMOVE_PARKING_INFO_BY_ID = "response_remove_booking_by_id"
        static let RESPONSE_FIND_PARKING_INFO_BY_ID = "response_find_booking_by_id"
        static let RESPONSE_FIND_PARKING_INFO_BY_CAR_ID = "response_find_booking_by_car_id"
        static let RESPONSE_FIND_PARKING_INFO_BY_GARAGE_ID = "response_find_booking_by_garage_id"
        static let RESPONSE_EDIT_PARKING_INFO_TIME_GO_IN_BY_ID = "response_edit_booking_time_go_in_by_id"
        static let RESPONSE_EDIT_PARKING_INFO_TIME_GO_OUT_BY_ID = "response_edit_booking_time_go_out_by_id"
        static let RESPONSE_PARKING_INFO_HISTORY_BY_ACCOUNT_ID = "response_booking_history_account_id"
        static let RESPONSE_PARKING_INFO_BY_ACCOUNT_ID = "response_booking_account_id"
        static let RESPONSE_EDIT_PARKING_INFO_BY_ID_STATUS = "response_edit_parking_info_id_status"
        static let RESPONSE_REFRESH_BOOKING_TIMEOUT = "response_refresh_booking_timeout"
        
        static let RESPONSE_CAR_GO_IN = "response_car_go_in"
        static let RESPONSE_CAR_GO_OUT = "response_car_go_out"
        static let RESPONSE_CAR_IN = "response_one_car_in"
        static let RESPONSE_CAR_OUT = "response_one_car_out"
        
    }
    
    struct SECURITY {
        static let REQUEST_ADD_NEW_SECURITY = "request_add_new_security"
        static let REQUEST_REMOVE_SECURITY = "request_remove_security"
        static let REQUEST_FIND_SECURITY_BY_GARAGE_ID = "request_find_security_by_garage_id"
        static let REQUEST_FIND_SECURITY_BY_ACCOUNT_ID = "request_find_security_by_account_id"
        static let REQUEST_EDIT_SECURITY_BY_ID = "request_edit_security_by_id"
        
        static let RESPONSE_ADD_NEW_SECURITY = "response_add_new_security"
        static let RESPONSE_REMOVE_SECURITY = "response_remove_security"
        static let RESPONSE_FIND_SECURITY_BY_GARAGE_ID = "response_find_security_by_garage_id"
        static let RESPONSE_FIND_SECURITY_BY_ACCOUNT_ID = "response_find_security_by_account_id"
        static let RESPONSE_EDIT_SECURITY_BY_ID = "response_edit_security_by_id"
        
        static let REQUEST_ALL_SECURITY = "request_all_security"
        static let RESPONSE_ALL_SECURITY = "response_all_security"
        
        static let RB_GARAGE_STATUS = "request_find_booking_by_garage_id_and_status"
    }
    
    struct ROLE {
        static let REQUEST_ADD_NEW_ROLE = "request_add_new_role"
        static let REQUEST_FIND_ROLE_BY_ID = "request_find_role_by_id"
        static let REQUEST_EDIT_ROLE_BY_ID = "request_edit_role_by_id"
        
        static let RESPONSE_ADD_NEW_ROLE = "response_add_new_security"
        static let RESPONSE_FIND_ROLE_BY_ID = "response_remove_security"
        static let RESPONSE_FIND_ROLE_BY_GARAGE_ID = "response_find_role_by_id"
    }
    
    
    
}
