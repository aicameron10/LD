//
//  SignUpController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/14.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire

import Toast_Swift


class SignUpController: UIViewController, WWCalendarTimeSelectorProtocol  {
    
    
    @IBOutlet weak var genderFemale: ISRadioButton!
    @IBOutlet weak var genderMale: ISRadioButton!
    @IBOutlet weak var newsLetter: ISRadioButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var confirmPasswordField: ErrorTextField!
    @IBOutlet weak var passwordField: ErrorTextField!
    @IBOutlet weak var emailField: ErrorTextField!
    @IBOutlet weak var firstNameField: ErrorTextField!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var dobField: ErrorTextField!
    @IBOutlet weak var showCalendar: UIButton!
    @IBOutlet weak var lastNameField: ErrorTextField!
    
    fileprivate var singleDate: Date = Date()
    
    fileprivate var multipleDates: [Date] = []
    
    var messageStr : String = String()
    
    var GenderStr = String()
    var NewsStr : Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NewsStr = false
        
        prepareEmailField()
        preparePasswordField()
        prepareCloseButton()
        prepareCalendarButton()
        prepareNextButton()
        prepareNameField()
        prepareNameLastField()
        preparePasswordConfirmField()
        prepareRadioGenderMale()
        prepareRadioGenderFemale()
        prepareRadioNewsLetter()
        view.addSubview(scrollView)
    }
    
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 300, height: 1200)
    }
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(SignUpController.buttonTapActionClose)
        
        
    }
    
    private func prepareRadioGenderMale() {
        
        
        let radiogender:ISRadioButton = genderMale
        radiogender.addTarget(self, action: #selector(logSelectedButtonGenderMale), for:.touchUpInside)
    }
    private func prepareRadioGenderFemale() {
        
        
        let radiogender:ISRadioButton = genderFemale
        radiogender.addTarget(self, action: #selector(logSelectedButtonGenderFemale), for:.touchUpInside)
    }
    
    private func prepareRadioNewsLetter() {
        
        let radio:ISRadioButton = newsLetter
        radio.addTarget(self, action: #selector(logSelectedButtonNews), for:.touchUpInside)
        
        
    }
    
    func logSelectedButtonGenderMale(sender: ISRadioButton){
        
        if genderMale.isEqual(self.genderMale) {
            
            print("male")
            GenderStr = "Male"
        }
        
        
    }
    func logSelectedButtonGenderFemale(sender: ISRadioButton){
        
        if genderFemale.isEqual(self.genderFemale) {
            
            print("female")
            GenderStr = "Female"
        }
        
        
    }
    
    
    func logSelectedButtonNews(sender: ISRadioButton){
        
        if newsLetter.isEqual(self.newsLetter) {
            
            if(NewsStr == false){
                print("true")
                NewsStr = true
            }else{
                print("false")
                NewsStr = false
            }
            
        }
        
        
    }
    
    
    
    private func prepareCalendarButton() {
        showCalendar.addTarget(self, action: #selector(buttonCalendarAction), for: .touchUpInside)
        
    }
    
    func buttonCalendarAction(sender: UIButton!) {
        print("Button tapped")
        showCal()
    }
    
    
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        self.dismiss(animated: true, completion: nil)
        
        //let pageViewController: PageViewController = {
         //   return UIStoryboard.viewController(identifier: "PageViewController") as! PageViewController
        //}()
        
        //self.present(pageViewController, animated: true, completion: nil)
        
        
    }
    
    
    private func prepareEmailField() {
        
        emailField.placeholder = "Email"
        emailField.detail = Constants.err_msg_email_valid
        emailField.isClearIconButtonEnabled = true
        emailField.detailLabel.numberOfLines = 0
        emailField.delegate = self
        
        
        emailField.addTarget(self,action: #selector(textFieldDidChangeEmail),for: UIControlEvents.editingDidEnd)
        emailField.addTarget(self,action: #selector(textFieldDidChangeEmailLength),for: UIControlEvents.editingChanged)
        
        
    }
    func textFieldDidChangeEmail(textField: UITextField) {
        
        let emailStr: String = emailField.text!
        if(!emailStr.isEmpty){
            
            if(!validateEmail(testStr: emailStr)){
                
                emailField.isErrorRevealed = true
            }else{
                emailField.isErrorRevealed = false
            }
        }else{
            emailField.isErrorRevealed = false
        }
        
        checkMaxLengthEmail(textField: emailField,maxLength: 30)
        
    }
    
    func textFieldDidChangeEmailLength(textField: UITextField) {
        
        
        checkMaxLengthEmail(textField: emailField,maxLength: 30)
        
    }
    
    
    func checkMaxLengthEmail(textField: UITextField!, maxLength: Int) {
        if (emailField.text!.characters.count > maxLength) {
            emailField.deleteBackward()
        }
    }
    
    
    private func preparePasswordField() {
        
        passwordField.placeholder = "Password"
        passwordField.detail = Constants.err_msg_password_match
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.detailLabel.numberOfLines = 0
        
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.gray.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        
        passwordField.delegate = self
        
        passwordField.addTarget(self,action: #selector(textFieldDidChangePass),for: UIControlEvents.editingDidEnd)
        passwordField.addTarget(self,action: #selector(textFieldDidChangePassLength),for: UIControlEvents.editingChanged)
        
        
        
        
    }
    
    func textFieldDidChangePass(textField: UITextField) {
        
        let passwordStr: String = passwordField.text!
        
        if(!passwordStr.isEmpty){
            
            if(!validatePassword(testStr: passwordStr)){
                
                passwordField.isErrorRevealed = true
            }else{
                passwordField.isErrorRevealed = false
            }
        }else{
            passwordField.isErrorRevealed = false
        }
        
        checkMaxLengthPass(textField: passwordField,maxLength: 20)
        
        
    }
    
    func textFieldDidChangePassLength(textField: UITextField) {
        
        
        checkMaxLengthPass(textField: passwordField,maxLength: 20)
        
    }
    
    func checkMaxLengthPass(textField: UITextField!, maxLength: Int) {
        if (passwordField.text!.characters.count > maxLength) {
            passwordField.deleteBackward()
        }
    }
    
    private func preparePasswordConfirmField() {
        
        confirmPasswordField.placeholder = "Confirm Password"
        confirmPasswordField.detail = Constants.err_msg_password_match
        confirmPasswordField.clearButtonMode = .whileEditing
        confirmPasswordField.isVisibilityIconButtonEnabled = true
        confirmPasswordField.detailLabel.numberOfLines = 0
        
        // Setting the visibilityIconButton color.
        confirmPasswordField.visibilityIconButton?.tintColor = Color.gray.withAlphaComponent(confirmPasswordField.isSecureTextEntry ? 0.38 : 0.54)
        
        confirmPasswordField.delegate = self
        
        confirmPasswordField.addTarget(self,action: #selector(textFieldDidChangePassConfirm),for: UIControlEvents.editingDidEnd)
        confirmPasswordField.addTarget(self,action: #selector(textFieldDidChangePassConfirmLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangePassConfirm(textField: UITextField) {
        
        let passwordStr: String = confirmPasswordField.text!
        
        if(!passwordStr.isEmpty){
            
            if(!validatePasswordConfirm(testStr: passwordStr)){
                
                confirmPasswordField.isErrorRevealed = true
            }else{
                confirmPasswordField.isErrorRevealed = false
            }
        }else{
            confirmPasswordField.isErrorRevealed = false
        }
        
        checkMaxLengthPassConfirm(textField: confirmPasswordField,maxLength: 20)
        
        
    }
    
    func textFieldDidChangePassConfirmLength(textField: UITextField) {
        
        
        checkMaxLengthPassConfirm(textField: confirmPasswordField,maxLength: 20)
        
    }
    
    func checkMaxLengthPassConfirm(textField: UITextField!, maxLength: Int) {
        if (confirmPasswordField.text!.characters.count > maxLength) {
            confirmPasswordField.deleteBackward()
        }
    }
    
    private func prepareDOBField() {
        
        dobField.placeholder = "Date of Birth"
        dobField.detail = Constants.err_msg_dob
        dobField.detailLabel.numberOfLines = 0
        dobField.delegate = self
        
        
        
    }
    
    
    
    private func prepareNameField() {
        
        firstNameField.placeholder = "First Name"
        firstNameField.detail = Constants.err_msg_name
        firstNameField.isClearIconButtonEnabled = true
        firstNameField.detailLabel.numberOfLines = 0
        firstNameField.delegate = self
        
        
        firstNameField.addTarget(self,action: #selector(textFieldDidChangeName),for: UIControlEvents.editingDidEnd)
        firstNameField.addTarget(self,action: #selector(textFieldDidChangeNameLength),for: UIControlEvents.editingChanged)
        
        
        
    }
    
    
    
    
    func textFieldDidChangeName(textField: UITextField) {
        
        let Str: String = firstNameField.text!
        if(!Str.isEmpty){
            
            if(Str.isEmpty){
                
                firstNameField.isErrorRevealed = true
            }else{
                firstNameField.isErrorRevealed = false
            }
        }else{
            firstNameField.isErrorRevealed = false
        }
        
        checkMaxLengthName(textField: firstNameField,maxLength: 50)
        
    }
    
    func textFieldDidChangeNameLength(textField: UITextField) {
        
        
        checkMaxLengthName(textField: firstNameField,maxLength: 50)
        
    }
    
    func checkMaxLengthName(textField: UITextField!, maxLength: Int) {
        if (firstNameField.text!.characters.count > maxLength) {
            firstNameField.deleteBackward()
        }
    }
    
    private func prepareNameLastField() {
        
        lastNameField.placeholder = "Last Name"
        lastNameField.detail = Constants.err_msg_lastname
        lastNameField.isClearIconButtonEnabled = true
        lastNameField.detailLabel.numberOfLines = 0
        lastNameField.delegate = self
        
        
        lastNameField.addTarget(self,action: #selector(textFieldDidChangeNameLast),for: UIControlEvents.editingDidEnd)
        lastNameField.addTarget(self,action: #selector(textFieldDidChangeNameLastLength),for: UIControlEvents.editingChanged)
        
        
    }
    
    func textFieldDidChangeNameLast(textField: UITextField) {
        
        let Str: String = lastNameField.text!
        
        if(!Str.isEmpty){
            
            if(Str.isEmpty){
                
                lastNameField.isErrorRevealed = true
            }else{
                lastNameField.isErrorRevealed = false
            }
        }else{
            lastNameField.isErrorRevealed = false
        }
        
        checkMaxLengthNameLast(textField: lastNameField,maxLength: 50)
        
    }
    
    func textFieldDidChangeNameLastLength(textField: UITextField) {
        
        
        checkMaxLengthNameLast(textField: lastNameField,maxLength: 50)
        
    }
    
    func checkMaxLengthNameLast(textField: UITextField!, maxLength: Int) {
        if (lastNameField.text!.characters.count > maxLength) {
            lastNameField.deleteBackward()
        }
    }
    
    
    
    
    private func prepareNextButton() {
        signUpButton.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        
    }
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        
        let emailStr: String = emailField.text!
        let passwordStr: String = passwordField.text!
        let firstNameStr: String = firstNameField.text!
        let dobStr: String = dobField.text!
        let lastNameStr: String = lastNameField.text!
        let confirmPasswordStr: String = confirmPasswordField.text!
        
        if (firstNameStr.isEmpty) {
            firstNameField.isErrorRevealed = true
            self.firstNameField.becomeFirstResponder()
            return
        }
        
        if (lastNameStr.isEmpty) {
            lastNameField.isErrorRevealed = true
            self.lastNameField.becomeFirstResponder()
            
            return
        }
        
        
        if(!validateEmail(testStr: emailStr)){
            emailField.isErrorRevealed = true
            self.emailField.becomeFirstResponder()
            return
        }
        
        if(!validatePassword(testStr: passwordStr)){
            passwordField.isErrorRevealed = true
            self.passwordField.becomeFirstResponder()
            return
        }
        
        if(!validatePasswordConfirm(testStr: confirmPasswordStr)){
            confirmPasswordField.isErrorRevealed = true
            self.confirmPasswordField.becomeFirstResponder()
            return
        }
        
        if(!validatePasswordMatch(testStr: confirmPasswordStr)){
            confirmPasswordField.isErrorRevealed = true
            self.confirmPasswordField.becomeFirstResponder()
            return
        }
        
        if (GenderStr == "") {
            showGender()
            
            return
        }
        
        if (dobStr.isEmpty) {
            showDate()
            
            return
        }
        
        
        
        
        
        checkEmail()
        
    }
    
    func showDate() {
        let ac = UIAlertController(title: "Message", message: "Please select your date of birth.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showGender() {
        let ac = UIAlertController(title: "Message", message: "Please select your gender.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func validatePassword(testStr:String) -> Bool {
        
        let regex = Constants.regex
        let passwordStr =  passwordField.text!
        
        if (testStr.isEmpty || !((passwordStr.range(of: regex, options: .regularExpression) != nil))) {
            return false
        }
        return true
        
    }
    
    func validatePasswordConfirm(testStr:String) -> Bool {
        
        let regex = Constants.regex
        let passwordStr =  confirmPasswordField.text!
        
        if (testStr.isEmpty || !((passwordStr.range(of: regex, options: .regularExpression) != nil))) {
            return false
        }
        return true
        
    }
    
    
    func validatePasswordMatch(testStr:String) -> Bool {
        
        let passwordStr =  passwordField.text!
        let passwordStrConfirm =  confirmPasswordField.text!
        
        if (passwordStr != passwordStrConfirm){
            confirmPasswordField.detail = Constants.err_msg_passwordconfirm
            return false
        }
        return true
        
    }
    
    
    
    
    
    func validateEmail(testStr:String) -> Bool {
        
        
        if (testStr.isEmpty || !isValidEmailString(testStr: testStr)) {
            return false
        }
        return true
    }
    
    func isValidEmailString(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    private func showCal() {
        
        singleDate = Date()
        
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(true)
        selector.optionStyles.showTime(false)
        selector.optionCalendarFontColorFutureDates = UIColor.lightGray
        
        
        
        
        /*
         Any other options are to be set before presenting selector!
         */
        present(selector, animated: true, completion: nil)
    }
    
    
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        singleDate = date
        let dateToday = Date()
        
        if date > dateToday {
            print("future date")
            
          
            self.view.makeToast("Date of birth cannot be a future date", duration: 3.0, position: .bottom)
            
            
        }else{
            dobField.text = date.stringFromFormat("dd-MM-yyyy")
        }
        
    }
    
    func showFutureDate() {
        let ac = UIAlertController(title: "Message", message: "Date of birth cannot be a future date", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    private func sendSignUp() {
        
        let email: String = emailField.text!
        
        let password: String = passwordField.text!
        
        let passwordConfirm: String = confirmPasswordField.text!
        
        let first: String = firstNameField.text!
        
        let last: String = lastNameField.text!
        
        let dob: String = dobField.text!
        
        
        
        signUpButton.isEnabled = false
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "register"
        
        print(urlString)
        
        
        let parameters: Parameters = [
            "E-mailaddress": email,
            "Password": password,
            "ConfirmPassword": passwordConfirm,
            "AccountType": "LifeDoc",
            "FirstName": first,
            "LastName": last,
            "Gender": GenderStr,
            "DateOfBirth": dob,
            "ReceiveNews": NewsStr
            
        ]
        
        
        let headers: HTTPHeaders = [
            //"Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        
        
        SignUpController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            print(response)
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(json)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                
                if status == "SUCCESS"{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    self.showSuccess()
                    
                }else{
                    
                    self.signUpButton.isEnabled = true
                    // get a reference to the app delegate
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    self.showError()
                }
                
            }
            
            if let error = response.result.error  as? AFError {
                switch error {
                case .invalidURL(let url):
                    print("Invalid URL: \(url) - \(error.localizedDescription)")
                case .parameterEncodingFailed(let reason):
                    print("Parameter encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .multipartEncodingFailed(let reason):
                    print("Multipart encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .responseValidationFailed(let reason):
                    print("Response validation failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                    
                    switch reason {
                    case .dataFileNil, .dataFileReadFailed:
                        print("Downloaded file could not be read")
                    case .missingContentType(let acceptableContentTypes):
                        print("Content Type Missing: \(acceptableContentTypes)")
                    case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                        print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                    case .unacceptableStatusCode(let code):
                        print("Response status code was unacceptable: \(code)")
                    }
                case .responseSerializationFailed(let reason):
                    print("Response serialization failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                }
                
                print("Underlying error: \(error.underlyingError)")
            } else if let error = response.result.error  as? URLError {
                print("URLError occurred: \(error)")
                self.signUpButton.isEnabled = true
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                self.showNetworkError()
                
            } else {
                
                
            }
            
        }
        
        
    }
    
    
    private func checkEmail() {
        
        
        let emailStr: String = emailField.text!
        
        signUpButton.isEnabled = false
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        
        //var petitions = [[String: String]]()
        
        let urlString: String
        
        urlString = Constants.baseURL + "validateEmail" + "?email=" + emailStr
        
        print(urlString)
        
        
        
        let headers: HTTPHeaders = [
            //"Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        
        
        // Both calls are equivalent
        SignUpController.Manager.request(urlString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            print(response)
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(json)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                if status == "SUCCESS"{
                    
                    self.sendSignUp()
                    
                }else{
                    
                    self.signUpButton.isEnabled = true
                    // get a reference to the app delegate
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    self.showError()
                }
                
            }
            
            if let error = response.result.error  as? AFError {
                switch error {
                case .invalidURL(let url):
                    print("Invalid URL: \(url) - \(error.localizedDescription)")
                case .parameterEncodingFailed(let reason):
                    print("Parameter encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .multipartEncodingFailed(let reason):
                    print("Multipart encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .responseValidationFailed(let reason):
                    print("Response validation failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                    
                    switch reason {
                    case .dataFileNil, .dataFileReadFailed:
                        print("Downloaded file could not be read")
                    case .missingContentType(let acceptableContentTypes):
                        print("Content Type Missing: \(acceptableContentTypes)")
                    case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                        print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                    case .unacceptableStatusCode(let code):
                        print("Response status code was unacceptable: \(code)")
                    }
                case .responseSerializationFailed(let reason):
                    print("Response serialization failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                }
                
                print("Underlying error: \(error.underlyingError)")
            } else if let error = response.result.error as? URLError {
                print("URLError occurred: \(error)")
                self.signUpButton.isEnabled = true
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                self.showNetworkError()
                
            } else {
                
                               
                
            }
            
        }
        
        
    }
    
    private static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            Constants.appSSL: .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
    func showError() {
        let ac = UIAlertController(title: "Error", message: messageStr, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showNetworkError() {
        let ac = UIAlertController(title: "Error", message:  "Your device is unable to connect,  Please check your device internet settings or contact 0800 695 433 (0800 My Life) for further assistance", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showSuccess() {
        let ac = UIAlertController(title: "Success", message: messageStr, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            self.dismissView()
        })
        present(ac, animated: true)
    }
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SignUpController: TextFieldDelegate {
    
    /// Executed when the 'return' key is pressed when using the emailField.
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //(textField as? ErrorTextField)?.isErrorRevealed = true
        view.endEditing(true)
        return true
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        
        
        if(passwordField.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!&#$%^/=*+-@~|\n\\").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }
        else if(confirmPasswordField.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!&#$%^/=*+-@~|\n\\").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(firstNameField.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n ").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }
        else if(lastNameField.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n ").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else{
            
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-(){}[]*^%$#@!?,._'/;:\\&amp;&quot;&lt;&gt;\n").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
            
        }
        
        
        
    }
    
    public func textField(textField: UITextField, willClear text: String?) {
        print("will clear", text ?? "")
        
    }
    
    public func textField(textField: UITextField, didClear text: String?) {
        print("did clear", text ?? "")
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    
}




