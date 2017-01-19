//
//  Constants.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/15.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import Foundation


struct Constants {
    
    //https://csa-utility.mediswitch.co.za:8443/ldmgw/
    //https://secure.lifedoc.co.za/ldmgw/
    //https://rvp-utility.mediswitch.co.za:8443/ldmgw/
    
    
    static let appSSL: String = "rvp-utility.mediswitch.co.za"
    //static let appRVP: String = "rvp-utility.mediswitch.co.za"
    //static let appProd: String = "secure.lifedoc.co.za"
    //static let appRVP: String = "csa-utility.mediswitch.co.za"
    
    static let appName: String = "LifeDoc"
    static let baseURL: String = "https://rvp-utility.mediswitch.co.za:8443/ldmgw/"
    
    static let err_msg_email_forgot: String = "Please enter a valid email address."
    
    static let err_msg_email: String = "Please enter your email address."
    static let err_msg_email_valid: String = "Please enter a valid email address."
    static let err_msg_name: String = "Please enter your first name."
    static let err_msg_lastname: String = "Please enter your surname."
    static let err_msg_password: String = "Your password does not meet the password requirements. The password must be between 8 – 20 characters long, with at least one special character (e.g. *@#~) and one number."
    static let err_msg_password_match: String = "Your password must be 8–20 characters long, with one special character (e.g. *@) and one number."
    static let err_msg_passwordconfirm: String = "Your passwords do not match."
    
    static let err_msg_dob: String = "Please enter your date of birth."
    
    static let err_msg_two_decimal: String = "Please ensure input starts with a digit and only has two decimal places"
    
    static let err_msg_Fasting: String = "Please capture between 0.00 and 150.00"
    static let err_msg_HB1AC: String = "Please capture between 0.00 and 100.00"
    static let err_msg_Random: String = "Please capture between 0.00 and 150.00"
    
    static let err_msg_Systolic: String = "Please capture between 10.00 and 300.00"
    static let err_msg_Diastolic: String = "Please capture between 10.00 and 250.00"
    
    static let err_msg_height: String = "Please capture between 0.01 and 2.50"
    static let err_msg_weight: String = "Please capture between 1.00 and 500.00"
    
    static let err_msg_Temperature: String = "Please capture between 12.00 and 45.00"
    
    static let err_msg_Pulse: String = "Please capture between 10.00 and 300.00"
    
    static let err_msg_date: String = "Select the date that test was performed."
    static let err_msg_time: String = "Select the time that test was performed"
    static let err_msg_allergy: String = "Please enter an allergy description"
    static let err_msg_chronic: String = "Please enter a chronic condition"
    
    
    
    static let regex: String = "^(?=(.*\\d){1})(?=.*[a-zA-Z])(?=.*[!@#$%^/|=&*?~\\^])[0-9a-zA-Z!@#$%^/|=&*?~\\^]{8,20}"
    
    static let err_msg_cholesterol: String = "Please capture between 0.00 and 20.00"
    
    
    struct Colors {
        
        
        
    }
    
    struct Data {
        
        static var myStrings = [String]()
        
    }
    
}
