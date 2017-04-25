//
//  Constants.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/15.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import Foundation


struct Constants {
    
    //SSL
    //static let appSSL: String = "rvp-utility.mediswitch.co.za"
    static let appSSL: String = "secure.lifedoc.co.za"
    //static let appSSL: String = "csa-utility.mediswitch.co.za"
    
    //Base URL
    //static let baseURL: String = "https://rvp-utility.mediswitch.co.za:8443/ldmgw/"
    static let baseURL: String = "https://secure.lifedoc.co.za/ldmgw/"
    //static let baseURL: String = "https://csa-utility.mediswitch.co.za:8443/ldmgw/"
 
    
    //Production
    static let termsUrl: String = "https://secure.lifedoc.co.za/C0m9wcQbO76LAE5O3K4jYxJZgLs7aWgXWJMlZlarKQPERCENT3DPERCENT3DEncryptUtil"
    //Dev
    //static let termsUrl: String = "https://rvp-utility.mediswitch.co.za:8443/bIlMix7LPB6PCqQSRenuLlKq9qcV7gsGwKBNR4R8HgPERCENT3DPERCENT3DEncryptUtil"
    
    static let appName: String = "LifeDoc"
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
    static let msg_lifedoc_terms: String = "The LifeDoc terms and conditions have been updated. Your continual use of the app implies your acceptance of these terms and conditions."
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
    static let err_msg_date_note: String = "Please enter a date"
    static let err_msg_desc_note: String = "Please enter a note"
    static let err_msg_date_hos: String = "Please enter a date"
    static let err_msg_date_hos_ad: String = "Date cannot be before the Admission date"
    static let err_msg_date_medi_end: String = "Date cannot be before the start date"
    static let err_msg_date_medi_start: String = "Please enter a date"
    static let err_msg_name_hos: String = "Please enter a Hospital Name"
    static let err_msg_name_hos_treat: String = "Please enter a Doctor Name"
    static let err_msg_name_medi_doc: String = "Please enter a Doctor Name"
    static let err_msg_medi_repeat: String = "Please enter the number of repeats"
    static let err_msg_medi_repeat_error: String = "Cannot be a negative number or zero. Minimum = 1, Maximum = 12"
    static let err_msg_name_medi: String = "Please enter a Medicine Name"
    static let err_msg_date_medi: String = "Date cannot be before the start date"
    static let err_msg_date_path: String = "Please enter a date"
    static let err_msg_name_path: String = "Please enter a Doctor Name"
    static let err_msg_name_path_desc: String = "Please enter a test description"
    static let err_msg_filename: String = "Please enter a filename"
    static let err_msg_file_desc: String = "Please enter a description"
    static let err_msg_file_type: String = "Please select an attachment type"
    static let err_msg_profile_first_name: String = "Please enter your first name"
    static let err_msg_profile_last_name: String = "Please enter your surname."
    static let err_msg_profile_dob: String = "Please enter your date of birth."
    static let err_msg_profile_id: String = "Please enter a valid 13-digit South African ID number."
    static let welcome_nodata: String = "Welcome to LifeDoc. Start adding records by clicking on the + icon at the bottom right of your screen."
    static let regex: String = "^(?=(.*\\d){1})(?=.*[a-zA-Z])(?=.*[!@#$%^/|=&*?~\\^])[0-9a-zA-Z!@#$%^/|=&*?~\\^]{8,20}"
    static let err_msg_cholesterol: String = "Please capture between 0.00 and 20.00"
    
    
}
