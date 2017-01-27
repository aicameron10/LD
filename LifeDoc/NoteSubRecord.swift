//
//  NoteSubRecord.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/01/19.
//  Copyright © 2017 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire
import Toast_Swift
import DropDown


class NoteSubRecord: UIViewController, WWCalendarTimeSelectorProtocol{
    
      @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bpDate: ErrorTextField!
    
   
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var hideButton: UIButton!
 
    @IBOutlet weak var errorNote: UILabel!
   
    @IBOutlet weak var wordCount: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var bpCalendar: UIButton!
    fileprivate var singleDate: Date = Date()
    
    fileprivate var multipleDates: [Date] = []
    
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
    
    var recordValue = ""
    
    var dropDownOption = ""
    
    var countAttachments = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BloodPresssureContoller.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Edit Note"
        
        deleteRecord = false
        NewDate = false
        hideBool = false
        somethingChanged = false
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergyChronic") != nil){
            loadDataSingle()
            
        }
        
        
        prepareCloseButton()
        prepareCalendarButton()
        prepareSaveButton()
        prepareHideButton()
        prepareDeleteButton()
        prepareDesc()
        prepareDate()
        prepareDateView()
   
        
    }
    
    
    
    
    public func loadJSONSingle() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "mainAllergyChronic") != nil){
            
            return JSON.parse(prefs.string(forKey: "mainAllergyChronic")!)
        }else{
            return nil
        }
        
    }
    
    
    func loadDataSingle(){
        
        let json = self.loadJSONSingle()
        
        print(json)
        
        
        for item in json["attributes"].arrayValue {
            print(item["value"].stringValue)
            let description = item["description"].stringValue
            
            let value = item["value"].stringValue
            
           
            
            if(description == "Status of condition"){
                dropDownOption = value
            }
            if(description == "Date first diagnosed"){
                editDate = value
            }
            
        }
        
        
        if (json["_hide"].stringValue == "true"){
            
            hideImage = true
            
        }else{
            hideImage = false
            
        }
        
        
        recordValue = json["recordId"].stringValue
        deletedList.append(json["recordId"].stringValue)
        
        
        
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
        scrollView.contentSize = CGSize(width: 300, height: 600)
    }
    
   
    
        private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(MainChronic.buttonTapActionClose)
        
        
    }
    
    func showDatePicker() {
        
        NewDate = true
        
        showCal()
    }
    
    
    
    private func prepareDateView() {
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainChronic.showDatePicker))
        dateView.addGestureRecognizer(tapDateView)
    }
    
    
    
    
    private func prepareCalendarButton() {
        bpCalendar.addTarget(self, action: #selector(buttonCalendarAction), for: .touchUpInside)
        
    }
    
    func buttonCalendarAction(sender: UIButton!) {
        print("Button tapped")
        NewDate = true
        
        showCal()
    }
    
    
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        if(somethingChanged == true){
            changed()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    
    private func prepareDate() {
        
        bpDate.placeholder = "Date"
        bpDate.resignFirstResponder()
        bpDate.detailLabel.numberOfLines = 0
        bpDate.delegate = self
        bpDate.addTarget(self, action: #selector(myTargetFunctionDate), for: UIControlEvents.touchDown)
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergyChronic") != nil){
            bpDate.text = editDate
        }else{
            bpDate.text = dateToday.stringFromFormat("dd-MM-yyyy")
        }
        
        
        
        
    }
    
    
    
    func myTargetFunctionDate(textField: UITextField) {
        NewDate = true
        showCal()
    }
    
    
    
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
        print(textView.text); //the textView parameter is the textView where text was changed
    }
    
    private func prepareDesc() {
        
        
        //noteText.delegate = self
        
        //noteText.addTarget(self,action: #selector(textFieldDidChange),for: UIControlEvents.editingDidEnd)
       //noteText.addTarget(self,action: #selector(textFieldDidChangeLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        let Str: String = noteText.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                //noteText.isErrorRevealed = true
               // noteText.detail = Constants.err_msg_chronic
            } else{
               
                
            }
        }else{
           // noteText.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLength(textField: UITextField) {
        
        
        //checkMaxLength(textField: condition,maxLength: 50)
        
    }
    
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
       // if (condition.text!.characters.count > maxLength) {
       //     condition.deleteBackward()
       // }
    }
    
    
    
    
    private func prepareSaveButton() {
        
        let rightNavItem = saveButton
        rightNavItem?.action = #selector(BloodPresssureContoller.buttonTapAction)
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergyChronic") != nil){
            rightNavItem?.title = "Apply"
        }
    }
    
    private func prepareHideButton() {
        
        hideButton.isHidden = false
        hideButton.addTarget(self, action: #selector(buttonHideAction), for: .touchUpInside)
        if(hideImage == false){
            let image = UIImage(named: "blue_unhide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = false
            
        }else if (hideImage == true){
            let image = UIImage(named: "blue_hide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = true
        }
        
        
    }
    
    
    func buttonHideAction(sender: UIButton!) {
        print("Button tapped")
        if(hideBool == false){
            let image = UIImage(named: "blue_hide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = true
            self.view.makeToast("Record has been hidden, please apply to save", duration: 3.0, position: .center)
            
        }else if (hideBool == true){
            let image = UIImage(named: "blue_unhide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = false
            self.view.makeToast("Record has been made visible, please apply to save", duration: 3.0, position: .center)
            
        }
    }
    
    
    func buttonDeleteAction(sender: UIButton!) {
        print("Button tapped")
        
        showAreYouSure()
        
    }
    
    func showAreYouSure() {
        let ac = UIAlertController(title: "Message", message: "Are you sure you wish to delete this information? Please note that all the sub-records will also be deleted", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
        })
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            self.deleteRecord = true
            self.sendMainAllergyChronic()
        })
        present(ac, animated: true)
    }
    
    
    
    private func prepareDeleteButton() {
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergyChronic") != nil) {
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
        
        
        deleteButton.addTarget(self, action: #selector(buttonDeleteAction), for: .touchUpInside)
        
    }
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        
        
        
        sendMainAllergyChronic()
    }
    
    func showDate() {
        let ac = UIAlertController(title: "Message", message: "Please select your date of birth.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    
    func validateValue(testStr:String) -> Bool {
        
        
        if (testStr.isEmpty) {
            return false
        }
        
        return true
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
        
        /*
         Any other options are to be set before presenting selector!
         */
        present(selector, animated: true, completion: nil)
    }
    
    
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        singleDate = date
        let dateToday = Date()
        
        if(NewDate == true){
            if date > dateToday {
                print("future date")
                
                self.view.makeToast("You cannot select a future date, please select a current or past date.", duration: 3.0, position: .center)
                
            }else{
                
                bpDate.text = date.stringFromFormat("dd-MM-yyyy")
            }
        }
        
        
        NewDate = false
        
        
    }
    
    func showFutureDate() {
        let ac = UIAlertController(title: "Message", message: "You cannot select a future date, please select a current or past date.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    private func sendMainAllergyChronic() {
        
        
        let strDate: String = bpDate.text!
        
        //let strDesc: String = condition.text!
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        saveButton.isEnabled = false
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "healthProfiles/chronicConditions"
        
        print(urlString)
        
        let date = strDate
       
        
        var save = true
        var del = false
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        let authToken = prefs.string(forKey: "authToken")
        
        if(deleteRecord == true){
            save = false
            del = true
            
        }
        
        
        let parameters: Parameters = [
            "loggedInUserDetailsId": String(loggedInUserDetailsId),
            "currentActiveUserDetailsId": String(currentActiveUserDetailsId),
            "date": date,
            "condition": "",
            "recordId": recordValue,
            "status": "",
            "_hide": hideBool,
            "_save": save,
            "_delete": del,
            "subRecords": subRecords
        ]
        
        
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json",
            "Content-Type": "application/json"
            
        ]
        
        
        
        NoteSubRecord.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            print(response)
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(json)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                
                if status == "SUCCESS"{
                    
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //appDelegate.hideActivityIndicator(uiView: self.view)
                    //self.showSuccess()
                    
                    appDelegate.gethealthProfile()
                    //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTable"), object: nil)
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    //Toast(text: self.messageStr, duration: Delay.long).show()
                    //self.dismiss(animated: true, completion: nil)
                    
                }else{
                    
                    self.saveButton.isEnabled = true
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
                self.saveButton.isEnabled = true
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
    
    
    func changed() {
        let ac = UIAlertController(title: "Message", message: "Are you sure you wish to cancel? Please note that all information you have captured will be lost.", preferredStyle: .alert)
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


extension NoteSubRecord: TextFieldDelegate {
    
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
        
        somethingChanged = true
    }
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        
        if(bpDate.isEditing){
            return false
        }else{
            
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-(){}[]*^%$#@!?,._'/;:\\&\"<>\n ").inverted
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

