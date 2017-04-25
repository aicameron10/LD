//
//  ForgotPasswordController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/14.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire

class ForgotPasswordController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var emailField: ErrorTextField!
    
    var messageStr : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareEmailField()
        prepareCloseButton()
        prepareNextButton()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
 
        
        view.addGestureRecognizer(tap)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    private func prepareEmailField() {
        
        
        emailField.placeholder = "Email"
        emailField.detail = Constants.err_msg_email_forgot
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
    
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(ForgotPasswordController.buttonTapActionClose)
        
        
    }
    private func prepareNextButton() {
        submitButton.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        
    }
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        
        let emailStr: String = emailField.text!
        if(validateEmail(testStr: emailStr)){
            sendPassword()
        }else{
            emailField.isErrorRevealed = true
            self.emailField.becomeFirstResponder()
        }
        
        
        
        
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
    
    
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        self.dismiss(animated: true, completion: nil)
        
        let pageViewController: PageViewController = {
            return UIStoryboard.viewController(identifier: "PageViewController") as! PageViewController
        }()
        
        self.present(pageViewController, animated: true, completion: nil)
        
        
    }
    
    private func sendPassword() {
        
        
        submitButton.isEnabled = false
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        
        let emailStr: String = emailField.text!
        
        //var petitions = [[String: String]]()
        
        let urlString: String
        
        urlString = Constants.baseURL + "resetPassword" + "?email=" + emailStr
        
        print(urlString)
        
        
        
        let headers: HTTPHeaders = [
            //"Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        
        
        // Both calls are equivalent
        ForgotPasswordController.Manager.request(urlString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
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
                    
                    self.submitButton.isEnabled = true
                    // get a reference to the app delegate
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    self.showError()
                }
                
            }
            
            if let error = response.result.error as? AFError {
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
                
            } else {
                
                self.submitButton.isEnabled = true
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                
                
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

extension ForgotPasswordController: TextFieldDelegate {
    
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
    
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-(){}[]*^%$#@!?,._'/;:\\&amp;&quot;&lt;&gt;\n").inverted
        let components = string.components(separatedBy: inverseSet)
        
        let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
        
        return string == filtered
    }
    
    
    public func textField(textField: UITextField, willClear text: String?) {
        print("will clear", text ?? "")
    }
    
    public func textField(textField: UITextField, didClear text: String?) {
        print("did clear", text ?? "")
        (textField as? ErrorTextField)?.isErrorRevealed = false
        
    }
    
    
    
}

