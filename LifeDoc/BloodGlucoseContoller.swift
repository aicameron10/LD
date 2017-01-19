//
//  BloodGlucoseController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/12/12.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire
import Toast_Swift

class BloodGlucoseContoller: UIViewController, WWCalendarTimeSelectorProtocol  {
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgDate: ErrorTextField!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var bgTime: ErrorTextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var bgFasting: ErrorTextField!
    @IBOutlet weak var bgHb1ac: ErrorTextField!
    @IBOutlet weak var bgRandom: ErrorTextField!
    
    @IBOutlet weak var bgCalendar: UIButton!
    fileprivate var singleDate: Date = Date()
    
    fileprivate var multipleDates: [Date] = []
    
    var messageStr : String = String()
    
    var idRandom : String = String()
    var idHb1ac : String = String()
    var idFasting : String = String()
    
   
    var NewDate : Bool = Bool()
    
    var NewTime : Bool = Bool()
    
    var hideBool : Bool = Bool()
    var fields : Array<String> = Array()
    
    var add : Array<String> = Array()
    
    var hideImage : Bool = Bool()
    
    var deletedList : Array<String> = Array()
    
    var editDateTime = ""
    var editTime = ""
    var editDate = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BloodGlucoseContoller.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Edit Blood Glucose"
        idRandom = "0"
        idHb1ac = "0"
        idFasting = "0"

        
        NewDate = false
        NewTime = false
        hideBool = false
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            loadDataSingle()
            
            if (prefs.string(forKey: "isHiddenValue") != nil && prefs.string(forKey: "isHiddenValue") == "true"){
                
                hideImage = true
                
                
            }else{
                hideImage = false
                
            }
            
            if (prefs.string(forKey: "dateValue") != nil){
                
                editDateTime = prefs.string(forKey: "dateValue")!
                var myStringArr = editDateTime.components(separatedBy: " ")
                
                
                editDate = myStringArr [0]
                editTime = myStringArr [1]
            
                
            }
            
        }

        
        prepareCloseButton()
        prepareCalendarButton()
        prepareSaveButton()
        prepareHideButton()
        prepareDeleteButton()
        prepareHb1ac()
        prepareRandom()
        prepareFasting()
        prepareDate()
        prepareTime()
        
        prepareDateView()
        prepareTimeView()
        
        
    }
    
    public func loadJSONSingle() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "singleMeasurement") != nil){
            
            return JSON.parse(prefs.string(forKey: "singleMeasurement")!)
        }else{
            return nil
        }
        
    }
    
    
    func loadDataSingle(){
        
        let json = self.loadJSONSingle()
        
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            
       
            bgFasting.isEnabled = false
            bgHb1ac.isEnabled = false
            bgRandom.isEnabled = false
            
            
            for (_, object) in json {
                
                
                
                if (object["type"].stringValue == "Random Blood Glucose") {
                    
                    let newString = object["value"].stringValue.replacingOccurrences(of: ".", with: ",")
                    bgRandom.text = newString
                    idRandom = object["id"].stringValue
                    bgRandom.isEnabled = true
                    deletedList.append(object["id"].stringValue)
                    
                }
                
                if (object["type"].stringValue == "HB1AC") {
                    
                    let newString = object["value"].stringValue.replacingOccurrences(of: ".", with: ",")
                    bgHb1ac.text = newString
                    idHb1ac = object["id"].stringValue
                    bgHb1ac.isEnabled = true
                    deletedList.append(object["id"].stringValue)
                    
                }
                if (object["type"].stringValue == "Fasting Blood Sugar") {
                    
                    let newString = object["value"].stringValue.replacingOccurrences(of: ".", with: ",")
                    bgFasting.text = newString
                    idFasting = object["id"].stringValue
                    bgFasting.isEnabled = true
                    deletedList.append(object["id"].stringValue)
                }
                
                
                
            }
        }
        
        
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
        leftNavItem?.action = #selector(BloodGlucoseContoller.buttonTapActionClose)
        
        
    }
    
    
    func showDatePicker() {
        
        NewDate = true
        NewTime = false
        showCal()
    }
    
    func showTimePicker() {
        
        NewTime = true
        NewDate = false
        showTime()
    }
    
    
    private func prepareDateView() {
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CholesterolController.showDatePicker))
        dateView.addGestureRecognizer(tapDateView)
    }
    
    private func prepareTimeView() {
        
        let tapTimeView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CholesterolController.showTimePicker))
        timeView.addGestureRecognizer(tapTimeView)
    }
    
    
    
    private func prepareCalendarButton() {
        bgCalendar.addTarget(self, action: #selector(buttonCalendarAction), for: .touchUpInside)
        
    }
    
    func buttonCalendarAction(sender: UIButton!) {
        print("Button tapped")
        NewDate = true
        NewTime = false
        showCal()
    }
    
    
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    
    private func prepareDate() {
        
        bgDate.placeholder = "Date"
        bgDate.resignFirstResponder()
        bgDate.detailLabel.numberOfLines = 0
        bgDate.delegate = self
        bgDate.addTarget(self, action: #selector(myTargetFunctionDate), for: UIControlEvents.touchDown)
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            bgDate.text = editDate
        }else{
            bgDate.text = dateToday.stringFromFormat("dd-MM-yyyy")
        }

        
        
    }
    
    private func prepareTime() {
        
        bgTime.placeholder = "Time"
        
        bgTime.detailLabel.numberOfLines = 0
        bgTime.resignFirstResponder()
        
        bgTime.delegate = self
        
        bgTime.addTarget(self, action: #selector(myTargetFunction), for: UIControlEvents.touchDown)
        
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            bgTime.text = editTime
        }else{
            bgTime.text = dateToday.stringFromFormat("HH:mm")
        }

        
        
        
        
    }
    
    func myTargetFunction(textField: UITextField) {
        NewTime = true
        showTime()
    }
    func myTargetFunctionDate(textField: UITextField) {
        NewDate = true
        showCal()
    }
    private func prepareFasting() {
        
        bgFasting.placeholder = "Fasting Blood Sugar (mmol/L)"
        bgFasting.detail = Constants.err_msg_Fasting
        bgFasting.isClearIconButtonEnabled = true
        
        bgFasting.detailLabel.numberOfLines = 0
        
        
        bgFasting.delegate = self
        
        bgFasting.addTarget(self,action: #selector(textFieldDidChangeFast),for: UIControlEvents.editingDidEnd)
        bgFasting.addTarget(self,action: #selector(textFieldDidChangeFastLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeFast(textField: UITextField) {
        
        let Str: String = bgFasting.text!
        if(!Str.isEmpty){
            
            if(!validateValueFasting(testStr: Str)){
                
                bgFasting.isErrorRevealed = true
                bgFasting.detail = Constants.err_msg_Fasting
            }else if(!validateValueDecimal(testStr: Str)){
                bgFasting.isErrorRevealed = true
                bgFasting.detail = Constants.err_msg_two_decimal
                
            }
            else{
                bgFasting.isErrorRevealed = false
                
            }
        }else{
            bgFasting.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeFastLength(textField: UITextField) {
        
        
        checkMaxLengthFast(textField: bgFasting,maxLength: 6)
        
    }
    
    
    func checkMaxLengthFast(textField: UITextField!, maxLength: Int) {
        if (bgFasting.text!.characters.count > maxLength) {
            bgFasting.deleteBackward()
        }
    }
    
    private func prepareHb1ac() {
        
        bgHb1ac.placeholder = "HB1AC (%)"
        bgHb1ac.detail = Constants.err_msg_HB1AC
        bgHb1ac.isClearIconButtonEnabled = true
        bgHb1ac.detailLabel.numberOfLines = 0
        bgHb1ac.delegate = self
        
        bgHb1ac.addTarget(self,action: #selector(textFieldDidChangeHb1ac),for: UIControlEvents.editingDidEnd)
        bgHb1ac.addTarget(self,action: #selector(textFieldDidChangeHb1acLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeHb1ac(textField: UITextField) {
        
        let Str: String = bgHb1ac.text!
        if(!Str.isEmpty){
            
            if(!validateValueHb1ac(testStr: Str)){
                
                bgHb1ac.isErrorRevealed = true
                bgHb1ac.detail = Constants.err_msg_HB1AC
            }else if(!validateValueDecimal(testStr: Str)){
                bgHb1ac.isErrorRevealed = true
                bgHb1ac.detail = Constants.err_msg_two_decimal
                
            }
            else{
                bgHb1ac.isErrorRevealed = false
                
            }
        }else{
            bgHb1ac.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeHb1acLength(textField: UITextField) {
        
        
        checkMaxLengthHb1ac(textField: bgHb1ac,maxLength: 6)
        
    }
    
    
    func checkMaxLengthHb1ac(textField: UITextField!, maxLength: Int) {
        if (bgHb1ac.text!.characters.count > maxLength) {
            bgHb1ac.deleteBackward()
        }
    }
    
    
    
    
    private func prepareRandom() {
        
        bgRandom.placeholder = "Random Blood Glucose (mmol/L)"
        bgRandom.detail = Constants.err_msg_Random
        bgRandom.isClearIconButtonEnabled = true
        bgRandom.detailLabel.numberOfLines = 0
        bgRandom.delegate = self
        
        bgRandom.addTarget(self,action: #selector(textFieldDidChangeRandom),for: UIControlEvents.editingDidEnd)
        bgRandom.addTarget(self,action: #selector(textFieldDidChangeRandomLength),for: UIControlEvents.editingChanged)
        
        
        
        
    }
    
    func textFieldDidChangeRandom(textField: UITextField) {
        
        let Str: String = bgRandom.text!
        if(!Str.isEmpty){
            
            if(!validateValueRandom(testStr: Str)){
                
                bgRandom.isErrorRevealed = true
                bgRandom.detail = Constants.err_msg_Random
            }else if(!validateValueDecimal(testStr: Str)){
                bgRandom.isErrorRevealed = true
                bgRandom.detail = Constants.err_msg_two_decimal
                
            }
            else{
                bgRandom.isErrorRevealed = false
                
            }
        }else{
            bgRandom.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeRandomLength(textField: UITextField) {
        
        
        checkMaxLengthRandom(textField: bgRandom,maxLength: 6)
        
    }
    
    
    func checkMaxLengthRandom(textField: UITextField!, maxLength: Int) {
        if (bgRandom.text!.characters.count > maxLength) {
            bgRandom.deleteBackward()
        }
    }
    
    
    
    
    private func prepareSaveButton() {
        
        let rightNavItem = saveButton
        rightNavItem?.action = #selector(BloodGlucoseContoller.buttonTapAction)
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
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
            self.view.makeToast("Record has been hidden, please apply to save", duration: 3.0, position: .bottom)
            
        }else if (hideBool == true){
            let image = UIImage(named: "blue_unhide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = false
            self.view.makeToast("Record has been made visible, please apply to save", duration: 3.0, position: .bottom)
            
        }
    }
    
    
    
    func buttonDeleteAction(sender: UIButton!) {
        print("Button tapped")
        
        showAreYouSure()
        
    }

    
    func showAreYouSure() {
        let ac = UIAlertController(title: "Message", message: "Are you sure you wish to delete this information?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
        })
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            
            self.deleteRecord()
        })
        present(ac, animated: true)
    }
    
    
    private func prepareDeleteButton() {
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil) {
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
        
        
        deleteButton.addTarget(self, action: #selector(buttonDeleteAction), for: .touchUpInside)
        
    }


    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        
        let str1: String = bgFasting.text!
        let str2: String = bgHb1ac.text!
        let str3: String = bgRandom.text!
        
        
        
        
        if (str1.isEmpty && str2.isEmpty && str3.isEmpty) {
          
              self.view.makeToast("At least one field is to be filled in", duration: 3.0, position: .bottom)
            return
        }
        if(!str1.isEmpty){
            
            if(str1.isEmpty || !validateValueFasting(testStr: str1)){
                bgFasting.isErrorRevealed = true
                bgFasting.detail = Constants.err_msg_Fasting
                self.bgFasting.becomeFirstResponder()
                return
            }
            
            if(!validateValueDecimal(testStr: str1)){
                bgFasting.isErrorRevealed = true
                bgFasting.detail = Constants.err_msg_two_decimal
                self.bgFasting.becomeFirstResponder()
                return
            }
            
            fields.append("Fasting Blood Sugar-" + bgFasting.text! + "-" + idFasting);
        }
        
        if(!str2.isEmpty){
            
            if(str2.isEmpty || !validateValueHb1ac(testStr: str2)){
                bgHb1ac.isErrorRevealed = true
                bgHb1ac.detail = Constants.err_msg_HB1AC
                self.bgHb1ac.becomeFirstResponder()
                return
            }
            
            if(!validateValueDecimal(testStr: str2)){
                bgHb1ac.isErrorRevealed = true
                bgHb1ac.detail = Constants.err_msg_two_decimal
                self.bgHb1ac.becomeFirstResponder()
                return
            }
            
            fields.append("HB1AC-" + bgHb1ac.text! + "-" + idHb1ac);
        }
        if(!str3.isEmpty){
            
            if(str3.isEmpty || !validateValueRandom(testStr: str3)){
                bgRandom.isErrorRevealed = true
                bgRandom.detail = Constants.err_msg_Random
                self.bgRandom.becomeFirstResponder()
                return
            }
            
            if(!validateValueDecimal(testStr: str3)){
                bgRandom.isErrorRevealed = true
                bgRandom.detail = Constants.err_msg_two_decimal
                self.bgRandom.becomeFirstResponder()
                return
            }
            
            fields.append("Random Blood Glucose-" + bgRandom.text! + "-" + idRandom);
        }
        
        
        sendHealthAssessment()
    }
    
    func showDate() {
        let ac = UIAlertController(title: "Message", message: "Please select your date of birth.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    
    func validateValueFasting(testStr:String) -> Bool {
        
        
        if (testStr.isEmpty) {
            return false
        }
        if (!isValidRangeFasting(testStr: testStr)) {
            return false
        }
        return true
    }
    func validateValueRandom(testStr:String) -> Bool {
        
        
        if (testStr.isEmpty) {
            return false
        }
        if (!isValidRangeRandom(testStr: testStr)) {
            return false
        }
        return true
    }
    
    func validateValueHb1ac(testStr:String) -> Bool {
        
        
        if (testStr.isEmpty) {
            return false
        }
        if (!isValidRangeHb1ac(testStr: testStr)) {
            return false
        }
        return true
    }
    
    
    
    func validateValueDecimal(testStr:String) -> Bool {
        
        
        
        if (!isValidDecimal(testStr: testStr)) {
            return false
        }
        
        return true
    }
    
    
    
    func isValidRangeRandom(testStr:String) -> Bool {
        if (!isValidDecimal(testStr: testStr)) {
            return true
        }else{
            let formatter = NumberFormatter()
            let Svalue = formatter.number(from: (testStr as NSString) as String)
            let s:String = String(format:"%.2f", Svalue!.doubleValue)
            let myDouble = (s as NSString).doubleValue
            
            let valueNew = myDouble * 100
            
            
            if (valueNew  >= (0*100) && valueNew  <= (150*100)) {
                return true
            }
        }
        
        
        return false
    }
    
    func isValidRangeFasting(testStr:String) -> Bool {
        
        
        if (!isValidDecimal(testStr: testStr)) {
            return true
        }else{
            let formatter = NumberFormatter()
            let Svalue = formatter.number(from: (testStr as NSString) as String)
            let s:String = String(format:"%.2f", Svalue!.doubleValue)
            let myDouble = (s as NSString).doubleValue
            
            let valueNew = myDouble * 100
            
            
            if (valueNew  >= (0*100) && valueNew  <= (150*100)) {
                return true
            }
        }
        
        
        return false
    }
    
    func isValidRangeHb1ac(testStr:String) -> Bool {
        if (!isValidDecimal(testStr: testStr)) {
            return true
        }else{
            let formatter = NumberFormatter()
            let Svalue = formatter.number(from: (testStr as NSString) as String)
            let s:String = String(format:"%.2f", Svalue!.doubleValue)
            let myDouble = (s as NSString).doubleValue
            
            let valueNew = myDouble * 100
            
            
            if (valueNew  >= (0*100) && valueNew  <= (100*100)) {
                return true
            }
        }
        
        
        return false
    }
    
    
    func isValidDecimal(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let RegEx = "^[0-9]+(\\,[0-9]{1,2})?$"
        
        
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: testStr)
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
    
    private func showTime() {
        
        singleDate = Date()
        
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(true)
        
        
        
        
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
                
                self.view.makeToast("You cannot select a future date, please select a current or past date.", duration: 3.0, position: .bottom)
                
            }else{
                
                bgDate.text = date.stringFromFormat("dd-MM-yyyy")
            }
        }
        if(NewTime == true){
            bgTime.text = date.stringFromFormat("HH:mm")
        }
        
        NewDate = false
        NewTime = false
        
    }
    
    
    func showFutureDate() {
        let ac = UIAlertController(title: "Message", message: "You cannot select a future date, please select a current or past date.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func deleteRecord() {
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        deleteButton.isEnabled = false
        
        let urlString: String
        
        urlString = Constants.baseURL + "healthAssessments/remove"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "ids": deletedList
            
            
        ]
        
      
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        BloodGlucoseContoller.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //appDelegate.hideActivityIndicator(uiView: self.view)
                    //self.showSuccess()
                    
                    appDelegate.gethealthAssessments()
                    //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTable"), object: nil)
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    //Toast(text: self.messageStr, duration: Delay.long).show()
                    //self.dismiss(animated: true, completion: nil)
                    
                }else{
                    self.deleteButton.isEnabled = true
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
                self.deleteButton.isEnabled = true
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                self.showNetworkError()
                
                
            } else {
               
                
            }
        }
        
        
    }

    
    private func sendHealthAssessment() {
        
        
        let strDate: String = bgDate.text!
        let strTime: String = bgTime.text!
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        saveButton.isEnabled = false
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "healthAssessments"
        
        print(urlString)
        
        let dateAndTime = strDate + " " + strTime
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        let authToken = prefs.string(forKey: "authToken")
        
        
        var savedFiles: [[String: AnyObject]] = []
        
        for i in 0 ..< fields.count  {
            var add : [String: String] = [:]
            
            let line = fields[i]
            let fullArr = line.components(separatedBy: "-")
            let name    = fullArr[0]
            let value = fullArr[1]
            let idd = fullArr[2]
            
            let formatter = NumberFormatter()
            let Svalue = formatter.number(from: value)
            
            
            let s:String = String(format:"%f", Svalue!.doubleValue)
            
            add["healthIndicatorElementName"] = name
            add["healthIndicatorValue"] = s
            add["UserResViewConditionId"] = idd
            
            
            savedFiles.append(add as [String : AnyObject])
            
        }
        
        
        
        let parameters: Parameters = [
            "loggedInUserDetailsId": String(loggedInUserDetailsId),
            "currentActiveUserDetailsId": String(currentActiveUserDetailsId),
            "_hide": hideBool,
            "type": "Blood Glucose",
            "dateAndTime": dateAndTime,
            "records": savedFiles
            
            
        ]
        
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        BloodGlucoseContoller.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
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
                    
                    appDelegate.gethealthAssessments()
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
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension BloodGlucoseContoller: TextFieldDelegate {
    
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
        
        if(bgTime.isEditing){
            return false
        }else if(bgDate.isEditing){
            return false
        }else{
            let inverseSet = NSCharacterSet(charactersIn:"0123456789,.").inverted
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
