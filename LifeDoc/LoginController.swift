//
//  LoginController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/15.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire

class LoginController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: ErrorTextField!
    @IBOutlet weak var passwordField: ErrorTextField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    var switchOn = false
    
    var messageStr : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareEmailField()
        preparePasswordField()
        prepareNextButton()
        prepareCloseButton()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        rememberSwitch.addTarget(self, action: #selector(switchIsChanged), for: .valueChanged)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func switchIsChanged() {
        if rememberSwitch.isOn {
            print("UISwitch is ON")
            switchOn = true
        } else {
            print("UISwitch is OFF")
            switchOn = false
        }
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
    
    
    
    
    
    
    private func prepareNextButton() {
        loginButton.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        
    }
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(LoginController.buttonTapActionClose)
        
        
    }
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        self.dismiss(animated: true, completion: nil)
        
        //let pageViewController: PageViewController = {
        //    return UIStoryboard.viewController(identifier: "PageViewController") as! PageViewController
        // }()
        
        // self.present(pageViewController, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        let emailStr: String = emailField.text!
        
        let passwordStr: String = passwordField.text!
        
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
        sendLogin()
        
    }
    
    
    
    func validatePassword(testStr:String) -> Bool {
        
        let regex = Constants.regex
        let passwordStr =  passwordField.text!
        
        if (testStr.isEmpty || !((passwordStr.range(of: regex, options: .regularExpression) != nil))) {
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
    
    
    
    private func sendLogin() {
        
        let emailStr: String = emailField.text!
        
        let passwordStr: String = passwordField.text!
        
        loginButton.isEnabled = false
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "login"
        
        print(urlString)
        
        
        let parameters: Parameters = [
            "username": emailStr,
            "password": passwordStr,
            "accountType": "LifeDoc"
            
        ]
        
        
        let headers: HTTPHeaders = [
            //"Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        LoginController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            //print(response)
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(json)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                let userDetailsId = json["userDetailsId"].int!
                
                
                
                if status == "SUCCESS"{
                    
                    let authToken = json["authToken"].string!
                    
                    let firstName = json["detail"]["firstName"].string!
                    let lastName = json["detail"]["lastName"].string!
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    let prefs = UserDefaults.standard
                    prefs.set(userDetailsId, forKey: "loggedInUserDetailsId")
                    prefs.set(userDetailsId, forKey: "currentActiveUserDetailsId")
                    prefs.set(authToken, forKey: "authToken")
                    prefs.set(firstName, forKey: "firstName")
                    prefs.set(lastName, forKey: "lastName")
                    
                    
                    let profilePictureData = json["detail"]["profilePictureData"].string
                    
                    
                    
                    if(profilePictureData != nil){
                        
                        let prefs = UserDefaults.standard
                        prefs.set(profilePictureData, forKey: "attachBase64Profile")
                        
                        
                        
                    }
                    
                    
                    
                    if(self.switchOn == true){
                        prefs.set("true", forKey: "userloggedin")
                    }else{
                        prefs.set("false", forKey: "userloggedin")
                    }
                    
                    // get a reference to the app delegate
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.mainView()
                    
                    
                    
                }else{
                    
                    self.loginButton.isEnabled = true
                    // get a reference to the app delegate
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    self.showError()
                }
                
            }
            if let error = response.result.error as? AFError{
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
                self.loginButton.isEnabled = true
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                self.showNetworkError()
                
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
    
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        // Disable copy, select all, paste
        if action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        // Default
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    
}



extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}


extension LoginController: TextFieldDelegate {
    
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
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        
        if(passwordField.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!&#$%^/=*@~+-|\n\\").inverted
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
