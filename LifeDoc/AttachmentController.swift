//
//  AttachmentController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/02/20.
//  Copyright © 2017 MediSwitch. All rights reserved.
//

import Foundation
import Material
import Alamofire
import Toast_Swift
import DropDown
import UserNotifications



class AttachmentController: UIViewController,UITextViewDelegate{
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: ErrorTextField!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var dropDown: NiceButton!
    @IBOutlet weak var errorNote: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    var messageStr : String = String()
    var idDiastolic : String = String()
    var NewDate : Bool = Bool()
    var deleteRecord : Bool = Bool()
    var hideBool : Bool = Bool()
    var fields : Array<String> = Array()
    var somethingChanged : Bool = Bool()
    var add : Array<String> = Array()
    var hideImage : Bool = Bool()
    var subRecords : Array<String> = Array()
    var deletedList : Array<String> = Array()
    var editDateTime = ""
    var editDate = ""
    var editNote = ""
    var recordValue = ""
    var lastdate = ""
    var dropDownOption = ""
    let chooseDropDown = DropDown()
    var countAttachments = 0
    var ddValue = "Image"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AttachmentController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Attachment"
        
        deleteRecord = false
        NewDate = false
        hideBool = false
        somethingChanged = false

        errorNote.isHidden = true
        clearButton.isHidden = true
        
        
        prepareCloseButton()
        prepareSaveButton()
        prepareDesc()
        prepareFileName()
        preparedropdown()
        prepareClearButton()
        
        
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
        scrollView.contentSize = CGSize(width: 300, height: 650)
    }
    
    private func preparedropdown() {
        
        chooseDropDown.anchorView = dropDown
        
       
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: dropDown.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDropDown.dataSource = ["Image", "Document", "Medical Certificate","X-rays","Radiology Report","Pathology Report"]

        chooseDropDown.selectionAction = { [unowned self] (index, item) in
            
            
            self.dropDown.setTitle(item, for: .normal)
            self.ddValue = item
            
        }
        
        
        chooseDropDown.direction = .any
        
        
    }
    
    @IBAction func chooseArticle(_ sender: AnyObject) {
        chooseDropDown.show()
    }
    
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(MainChronic.buttonTapActionClose)
        
        
    }
    
    
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        
        
        
        changed()
        
        
        
    }
    
    
    private func prepareFileName() {
        
        name.placeholder = "Filename"
        name.resignFirstResponder()
        name.detailLabel.numberOfLines = 0
        name.delegate = self
        
        name.isClearIconButtonEnabled = true
        
        
        
        
        
        name.addTarget(self,action: #selector(textFieldDidChange),for: UIControlEvents.editingDidEnd)
        name.addTarget(self,action: #selector(textFieldDidChangeLength),for: UIControlEvents.editingChanged)
        
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        let Str: String = name.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                name.isErrorRevealed = true
                name.detail = Constants.err_msg_filename
            } else{
                name.isErrorRevealed = false
                
            }
        }else{
            name.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLength(textField: UITextField) {
        
        
        checkMaxLength(textField: name,maxLength: 30)
        
    }
    
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (name.text!.characters.count > maxLength) {
            name.deleteBackward()
        }
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-(){}[]*^%$#@!?,._'/;:\\&\"<>\n ").inverted
        let components = text.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        
        
        if(numberOfChars > 200){
            return numberOfChars <= 200
        }else{
            
        }
        
        return text == filtered
        
        
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text); //the textView parameter is the textView where text was changed
    }
    
    private func prepareDesc() {
        
        //self.noteText.contentInset = UIEdgeInsetsMake(2, -2, 2, -10)
        //noteText.isScrollEnabled = false
        noteText.delegate = self
        
        
        
        
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        clearButton.isHidden = false
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if noteText.text.isEmpty || noteText.text == "" {
            errorNote.isHidden = false
        }
        else{
            errorNote.isHidden = true
        }
        clearButton.isHidden = true
    }
    
    
    
    
    private func prepareClearButton() {
        
        
        clearButton.addTarget(self, action: #selector(buttonClearAction), for: .touchUpInside)
        
        
    }
    
    func buttonClearAction(sender: UIButton!) {
        print("Button tapped")
        noteText.text = ""
        
        
    }
    
    
    
    private func prepareSaveButton() {
        
        let rightNavItem = saveButton
        rightNavItem?.action = #selector(AttachmentController.buttonTapAction)
        
        
    }
    
    
    
    
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        let str1: String = name.text!.trimmed
        
        if(str1.isEmpty){
            name.isErrorRevealed = true
            name.detail = Constants.err_msg_filename
            self.name.becomeFirstResponder()
            return
        }
        
        
        if noteText.text.isEmpty || noteText.text == "" || noteText.text.trimmed == "" {
            errorNote.isHidden = false
            noteText.becomeFirstResponder()
        }else{
            
            Upload()
            
        }
        
    }
    
    
    
    
    func validateValue(testStr:String) -> Bool {
        
        
        if (testStr.isEmpty) {
            return false
        }
        
        return true
    }
    
    
    
    
    
    
    private func Upload() {
        
        let strName: String = name.text!
        
        let note: String = noteText.text!
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        self.view.makeToast("Upload started...", duration: 1.0, position: .bottom)
        
        let urlString: String
        
        urlString = Constants.baseURL + "records/addAttachment"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        let type = prefs.string(forKey: "attachType")!
        let idd = prefs.string(forKey: "attachId")!
        let base = prefs.string(forKey: "attachBase64")!
        
        let nameValue = strName.trimmed + ".jpg"
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "attachmentName": nameValue,
            "attachmentType": ddValue,
            "description": note,
            "type":  type,
            "recordId": idd,
            "data": base
            
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        AttachmentController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    
                    
                    
                    self.messageStr =  strName  + ".jpg" + " uploaded successfully"
                    
                    
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    
                    //Toast(text: self.messageStr, duration: Delay.long).show()
                    
                    self.showAttachMessage()
                    
                    
                }else{
                    
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
                
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                self.showNetworkError()
                
                
            }
        }
        
        
    }
    
    public func showAttachMessage(){
        
        let prefs = UserDefaults.standard
        var msg = ""
        if (prefs.string(forKey: "savedServerMessage") != nil){
            
            msg = prefs.string(forKey: "savedServerMessage")!
            
        }
        
        let ac = UIAlertController(title: "LifeDoc", message: msg, preferredStyle: .alert)
        
        
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        { action -> Void in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadAttach"), object: nil)
            self.dismiss(animated: true, completion: nil)
        })
        
        
        
        present(ac, animated: true)
        
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
    
    
    func changed() {
        let ac = UIAlertController(title: "Message", message: "The file upload will be cancelled, do you want to continue?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
        })
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            self.dismissView()
        })
        present(ac, animated: true)
        
    }
    
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}



extension AttachmentController: TextFieldDelegate {
    
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
        
        //somethingChanged = true
    }
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        
        
        
        let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789(){}[]-_\n ").inverted
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
