//
//  MainChronic.swift
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


class MainChronic: UIViewController, WWCalendarTimeSelectorProtocol, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bpDate: ErrorTextField!
    
    @IBOutlet weak var dropDownButton: NiceButton!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var condition: ErrorTextField!
    @IBOutlet weak var attach: UIButton!
    
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
    
    var serverityValue = "Status of condition"
    var recordValue = ""
    
    var dropDownOption = ""
    
    
    let chooseDropDown = DropDown()
    
    var options = ["Notes", "Doctor Visits", "Medication", "Hospital Visits", "Pathology Results", "Attachments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BloodPresssureContoller.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Edit Chronic Condition"
        
        deleteRecord = false
        NewDate = false
        hideBool = false
        somethingChanged = false
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergy") != nil){
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
        
        preparedropdown()
        
        
        
    }
    
    
    
    
    public func loadJSONSingle() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "mainAllergy") != nil){
            
            return JSON.parse(prefs.string(forKey: "mainAllergy")!)
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
            
            if(description == "Allergy"){
                condition.text = value
            }
            
            if(description == "Severity"){
                dropDownOption = value
            }
            if(description == "Date first observed"){
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 6; //However many static cells you want
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = MainRecordCustomCell()
        
        //let cell:HealthAssessmentCustomCell = self.tableViewAssess.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HealthAssessmentCustomCell
        // Don't forget to enter this in IB also
        //let cellReuseIdentifier = "CellAssess\(indexPath.row-2)"
        
        cell = tableView.dequeueReusableCell(withIdentifier: "CellMainRecordChronic", for: indexPath) as! MainRecordCustomCell
        
        cell.separatorInset.left = 20.0
        cell.separatorInset.right = 20.0
        cell.separatorInset.top = 20.0
        cell.separatorInset.bottom = 20.0
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.white.cgColor
        
        
        cell.name.text = options[indexPath.row]
        
        cell.count.layer.cornerRadius = 11.0
        cell.count.clipsToBounds = true
        
        return cell
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        /*
         let cholesterolController: CholesterolController = {
         return UIStoryboard.viewController(identifier: "CholesterolController") as! CholesterolController
         }()
         self.present(cholesterolController, animated: true, completion: nil)
         */
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 40
        
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    private func preparedropdown() {
        
        chooseDropDown.anchorView = dropDownButton
        
        // Will set a custom with instead of anchor view width
        //		dropDown.width = 100
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: dropDownButton.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDropDown.dataSource = ["Mild", "Severe", "Life Threatening"]
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergy") != nil){
            
            self.dropDownButton.setTitle(self.dropDownOption, for: .normal)
            self.serverityValue = dropDownOption
        }
        
        
        // Action triggered on selection
        chooseDropDown.selectionAction = { [unowned self] (index, item) in
            
            self.somethingChanged = true
            
            self.dropDownButton.setTitle(item, for: .normal)
            self.serverityValue = item
            
        }
        
        
        
        chooseDropDown.direction = .any
        
        // Action triggered on dropdown cancelation (hide)
        //		dropDown.cancelAction = { [unowned self] in
        //			// You could for example deselect the selected item
        //			self.dropDown.deselectRowAtIndexPath(self.dropDown.indexForSelectedRow)
        //			self.actionButton.setTitle("Canceled", forState: .Normal)
        //		}
        
        // You can manually select a row if needed
        //		dropDown.selectRowAtIndex(3)
        
    }
    
    @IBAction func chooseArticle(_ sender: AnyObject) {
        chooseDropDown.show()
    }
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(MainAllergy.buttonTapActionClose)
        
        
    }
    
    func showDatePicker() {
        
        NewDate = true
        
        showCal()
    }
    
    
    
    private func prepareDateView() {
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainAllergy.showDatePicker))
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
        
        bpDate.placeholder = "Date first diagnosed"
        bpDate.resignFirstResponder()
        bpDate.detailLabel.numberOfLines = 0
        bpDate.delegate = self
        bpDate.addTarget(self, action: #selector(myTargetFunctionDate), for: UIControlEvents.touchDown)
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergy") != nil){
            bpDate.text = editDate
        }else{
            bpDate.text = dateToday.stringFromFormat("dd-MM-yyyy")
        }
        
        
        
        
    }
    
    
    
    func myTargetFunctionDate(textField: UITextField) {
        NewDate = true
        showCal()
    }
    private func prepareDesc() {
        
        condition.placeholder = "Condition"
        condition.detail = Constants.err_msg_chronic
        condition.isClearIconButtonEnabled = true
        
        condition.detailLabel.numberOfLines = 0
        
        
        condition.delegate = self
        
        condition.addTarget(self,action: #selector(textFieldDidChange),for: UIControlEvents.editingDidEnd)
        condition.addTarget(self,action: #selector(textFieldDidChangeLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        let Str: String = condition.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                condition.isErrorRevealed = true
                condition.detail = Constants.err_msg_chronic
            } else{
                condition.isErrorRevealed = false
                
            }
        }else{
            condition.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLength(textField: UITextField) {
        
        
        checkMaxLength(textField: condition,maxLength: 50)
        
    }
    
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (condition.text!.characters.count > maxLength) {
            condition.deleteBackward()
        }
    }
    
    
    
    
    private func prepareSaveButton() {
        
        let rightNavItem = saveButton
        rightNavItem?.action = #selector(BloodPresssureContoller.buttonTapAction)
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergy") != nil){
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
        let ac = UIAlertController(title: "Message", message: "Are you sure you wish to delete this information? Please note that all the Sub-records will also be deleted", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
        })
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            self.deleteRecord = true
            self.sendMainAllergy()
        })
        present(ac, animated: true)
    }
    
    
    
    private func prepareDeleteButton() {
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergy") != nil) {
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
        
        
        deleteButton.addTarget(self, action: #selector(buttonDeleteAction), for: .touchUpInside)
        
    }
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        
        let str1: String = condition.text!.trimmed
        
        if(str1.isEmpty){
            condition.isErrorRevealed = true
            condition.detail = Constants.err_msg_chronic
            self.condition.becomeFirstResponder()
            return
        }
        
        if(serverityValue == "Status of condition"){
            self.view.makeToast("Please select a status of condition", duration: 3.0, position: .center)
            return
        }
        
        
        
        
        
        
        sendMainAllergy()
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
    
    
    
    private func sendMainAllergy() {
        
        
        let strDate: String = bpDate.text!
        
        let strDesc: String = condition.text!
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        saveButton.isEnabled = false
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "healthProfiles/allergies"
        
        print(urlString)
        
        let date = strDate
        let dec = strDesc
        
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
            "description": dec,
            "recordId": recordValue,
            "severity": serverityValue,
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
        
        
        
        MainChronic.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
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


extension MainChronic: TextFieldDelegate {
    
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
