//
//  ChangePasswordController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/01/06.
//  Copyright © 2017 MediSwitch. All rights reserved.
//

import Foundation
import Material
import Alamofire

import Toast_Swift


class ChangePasswordController: UIViewController  {
    @IBOutlet weak var oldPassword: ErrorTextField!
    @IBOutlet weak var newPassword: ErrorTextField!
    @IBOutlet weak var confirmPassword: ErrorTextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var messageStr : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        prepareOldPasswordField()
        preparePasswordField()
        preparePasswordConfirmField()
        prepareCloseButton()
        prepareSubmitButton()
        
        
        view.addSubview(scrollView)
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
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 300, height: 700)
    }
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(ChangePasswordController.buttonTapActionClose)
        
        
    }
    
    func buttonTapActionClose() {
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func prepareOldPasswordField() {
        
        oldPassword.placeholder = "Current Password"
        oldPassword.detail = Constants.err_msg_password_match
        oldPassword.clearButtonMode = .whileEditing
        oldPassword.isVisibilityIconButtonEnabled = true
        oldPassword.detailLabel.numberOfLines = 0
        
        // Setting the visibilityIconButton color.
        oldPassword.visibilityIconButton?.tintColor = Color.gray.withAlphaComponent(oldPassword.isSecureTextEntry ? 0.38 : 0.54)
        
        oldPassword.delegate = self
        
        oldPassword.addTarget(self,action: #selector(textFieldDidChangePassOld),for: UIControlEvents.editingDidEnd)
        oldPassword.addTarget(self,action: #selector(textFieldDidChangePassLengthOld),for: UIControlEvents.editingChanged)
        
    }
    
    
    private func preparePasswordField() {
        
        newPassword.placeholder = "New Password"
        newPassword.detail = Constants.err_msg_password_match
        newPassword.clearButtonMode = .whileEditing
        newPassword.isVisibilityIconButtonEnabled = true
        newPassword.detailLabel.numberOfLines = 0
        
        // Setting the visibilityIconButton color.
        newPassword.visibilityIconButton?.tintColor = Color.gray.withAlphaComponent(newPassword.isSecureTextEntry ? 0.38 : 0.54)
        
        newPassword.delegate = self
        
        newPassword.addTarget(self,action: #selector(textFieldDidChangePass),for: UIControlEvents.editingDidEnd)
        newPassword.addTarget(self,action: #selector(textFieldDidChangePassLength),for: UIControlEvents.editingChanged)
        
        
        
        
    }
    
    func textFieldDidChangePass(textField: UITextField) {
        
        let passwordStr: String = newPassword.text!
        
        if(!passwordStr.isEmpty){
            
            if(!validatePassword(testStr: passwordStr)){
                
                newPassword.isErrorRevealed = true
            }else{
                newPassword.isErrorRevealed = false
            }
        }else{
            newPassword.isErrorRevealed = false
        }
        
        checkMaxLengthPass(textField: newPassword,maxLength: 20)
        
        
    }
    
    func textFieldDidChangePassLength(textField: UITextField) {
        
        
        checkMaxLengthPass(textField: newPassword,maxLength: 20)
        
    }
    
    func checkMaxLengthPass(textField: UITextField!, maxLength: Int) {
        if (newPassword.text!.characters.count > maxLength) {
            newPassword.deleteBackward()
        }
    }
    
    
    func textFieldDidChangePassOld(textField: UITextField) {
        
        let passwordStr: String = oldPassword.text!
        
        if(!passwordStr.isEmpty){
            
            if(!validatePasswordOld(testStr: passwordStr)){
                
                oldPassword.isErrorRevealed = true
            }else{
                oldPassword.isErrorRevealed = false
            }
        }else{
            oldPassword.isErrorRevealed = false
        }
        
        checkMaxLengthPass(textField: oldPassword,maxLength: 20)
        
        
    }
    
    func textFieldDidChangePassLengthOld(textField: UITextField) {
        
        
        checkMaxLengthPassOld(textField: oldPassword,maxLength: 20)
        
    }
    
    func checkMaxLengthPassOld(textField: UITextField!, maxLength: Int) {
        if (oldPassword.text!.characters.count > maxLength) {
            oldPassword.deleteBackward()
        }
    }
    
    
    private func preparePasswordConfirmField() {
        
        confirmPassword.placeholder = "Confirm Password"
        confirmPassword.detail = Constants.err_msg_password_match
        confirmPassword.clearButtonMode = .whileEditing
        confirmPassword.isVisibilityIconButtonEnabled = true
        confirmPassword.detailLabel.numberOfLines = 0
        
        // Setting the visibilityIconButton color.
        confirmPassword.visibilityIconButton?.tintColor = Color.gray.withAlphaComponent(confirmPassword.isSecureTextEntry ? 0.38 : 0.54)
        
        confirmPassword.delegate = self
        
        confirmPassword.addTarget(self,action: #selector(textFieldDidChangePassConfirm),for: UIControlEvents.editingDidEnd)
        confirmPassword.addTarget(self,action: #selector(textFieldDidChangePassConfirmLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangePassConfirm(textField: UITextField) {
        
        let passwordStr: String = confirmPassword.text!
        
        if(!passwordStr.isEmpty){
            
            if(!validatePasswordConfirm(testStr: passwordStr)){
                
                confirmPassword.isErrorRevealed = true
            }else{
                confirmPassword.isErrorRevealed = false
            }
        }else{
            confirmPassword.isErrorRevealed = false
        }
        
        checkMaxLengthPassConfirm(textField: confirmPassword,maxLength: 20)
        
        
    }
    
    func textFieldDidChangePassConfirmLength(textField: UITextField) {
        
        
        checkMaxLengthPassConfirm(textField: confirmPassword,maxLength: 20)
        
    }
    
    func checkMaxLengthPassConfirm(textField: UITextField!, maxLength: Int) {
        if (confirmPassword.text!.characters.count > maxLength) {
            confirmPassword.deleteBackward()
        }
    }
    
    func validatePassword(testStr:String) -> Bool {
        
        let regex = Constants.regex
        let passwordStr =  newPassword.text!
        
        if (testStr.isEmpty || !((passwordStr.range(of: regex, options: .regularExpression) != nil))) {
            return false
        }
        return true
        
    }
    
    func validatePasswordOld(testStr:String) -> Bool {
        
        let regex = Constants.regex
        let passwordStr =  oldPassword.text!
        
        if (testStr.isEmpty || !((passwordStr.range(of: regex, options: .regularExpression) != nil))) {
            return false
        }
        return true
        
    }
    
    
    func validatePasswordConfirm(testStr:String) -> Bool {
        
        let regex = Constants.regex
        let passwordStr =  confirmPassword.text!
        
        if (testStr.isEmpty || !((passwordStr.range(of: regex, options: .regularExpression) != nil))) {
            return false
        }
        return true
        
    }
    
    
    func validatePasswordMatch(testStr:String) -> Bool {
        
        let passwordStr =  newPassword.text!
        let passwordStrConfirm =  confirmPassword.text!
        
        if (passwordStr != passwordStrConfirm){
            confirmPassword.detail = Constants.err_msg_passwordconfirm
            return false
        }
        return true
        
    }
    
    
    private func prepareSubmitButton() {
        submitButton.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        
    }
    
    func buttonTapAction(sender: UIButton!) {
        
        
        
        let passwordStrOld: String = oldPassword.text!
        let passwordStr: String = newPassword.text!
        
        let confirmPasswordStr: String = confirmPassword.text!
        
        if(!validatePasswordOld(testStr: passwordStrOld)){
            oldPassword.isErrorRevealed = true
            self.oldPassword.becomeFirstResponder()
            return
        }
        
        if(!validatePassword(testStr: passwordStr)){
            newPassword.isErrorRevealed = true
            self.newPassword.becomeFirstResponder()
            return
        }
        
        if(!validatePasswordConfirm(testStr: confirmPasswordStr)){
            confirmPassword.isErrorRevealed = true
            self.confirmPassword.becomeFirstResponder()
            return
        }
        
        if(!validatePasswordMatch(testStr: confirmPasswordStr)){
            confirmPassword.isErrorRevealed = true
            self.confirmPassword.becomeFirstResponder()
            return
        }
        
        
        
        changePassword()
        
    }
    
    private func changePassword() {
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        let passwordOld: String = oldPassword.text!
        
        let password: String = newPassword.text!
        
        
        submitButton.isEnabled = false
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "changePassword"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "old": passwordOld,
            "new": password
            
            
        ]
        
        
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        ChangePasswordController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            print(response)
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(json)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                
                if status == "SUCCESS"{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    appDelegate.showToast()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    
                    self.submitButton.isEnabled = true
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
                self.submitButton.isEnabled = true
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
    
    
    
}

extension ChangePasswordController: TextFieldDelegate {
    
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
        
        
        if(newPassword.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!&#$%^/=*+-@~|\n\\").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }
        else if(confirmPassword.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!&#$%^/=*+-@~|\n\\").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(oldPassword.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!&#$%^/=*+-@~|\n\\").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }
            
        else{
            
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

