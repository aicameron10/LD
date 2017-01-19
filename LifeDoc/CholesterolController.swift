//
//  CholesterolController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/12/12.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire
import Toast_Swift

class CholesterolController: UIViewController, WWCalendarTimeSelectorProtocol  {
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cholesterolDate: ErrorTextField!
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var cholesterolTime: ErrorTextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var cholesterolTrig: ErrorTextField!
    @IBOutlet weak var cholesterolLDL: ErrorTextField!
    @IBOutlet weak var cholesterolHDL: ErrorTextField!
    @IBOutlet weak var cholesterolTotal: ErrorTextField!
    @IBOutlet weak var cholesterolCalendar: UIButton!
    fileprivate var singleDate: Date = Date()
    
    fileprivate var multipleDates: [Date] = []
    
    var messageStr : String = String()
    
    var idTotal : String = String()
    var idHdl : String = String()
    var idLdl : String = String()
    var idTrig : String = String()
    
    
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CholesterolController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Edit Cholesterol"
        idTotal = "0"
        idHdl = "0"
        idLdl = "0"
        idTrig = "0"
   
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
        prepareDeleteButton()
        preparecholesterolHDL()
        preparecholesterolLDL()
        preparecholesterolTrig()
        preparecholesterolTotal()
        preparecholesterolDate()
        preparecholesterolTime()
        prepareHideButton()
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
            
           
            cholesterolTotal.isEnabled = false
            cholesterolHDL.isEnabled = false
            cholesterolLDL.isEnabled = false
            cholesterolTrig.isEnabled = false
            
            for (_, object) in json {
                
                
                
                if (object["type"].stringValue == "Total") {
                    
                    let newString = object["value"].stringValue.replacingOccurrences(of: ".", with: ",")
                    cholesterolTotal.text = newString
                    idTotal = object["id"].stringValue
                    cholesterolTotal.isEnabled = true
                    deletedList.append(object["id"].stringValue)
                    
                }
                
                if (object["type"].stringValue == "HDL") {
                    
                    let newString = object["value"].stringValue.replacingOccurrences(of: ".", with: ",")
                    cholesterolHDL.text = newString
                    idHdl = object["id"].stringValue
                    cholesterolHDL.isEnabled = true
                    deletedList.append(object["id"].stringValue)
                    
                }
                if (object["type"].stringValue == "LDL") {
                    
                    let newString = object["value"].stringValue.replacingOccurrences(of: ".", with: ",")
                    cholesterolLDL.text = newString
                    idLdl = object["id"].stringValue
                    cholesterolLDL.isEnabled = true
                    deletedList.append(object["id"].stringValue)
                }
                
                if (object["type"].stringValue == "Triglycerides") {
                    
                    let newString = object["value"].stringValue.replacingOccurrences(of: ".", with: ",")
                    cholesterolTrig.text = newString
                    idTrig = object["id"].stringValue
                    cholesterolTrig.isEnabled = true
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
        scrollView.contentSize = CGSize(width: 300, height: 700)
    }
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(CholesterolController.buttonTapActionClose)
        
        
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
        cholesterolCalendar.addTarget(self, action: #selector(buttonCalendarAction), for: .touchUpInside)
        
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
    
    
    private func preparecholesterolDate() {
        
        cholesterolDate.placeholder = "Date"
        cholesterolDate.resignFirstResponder()
        cholesterolDate.detailLabel.numberOfLines = 0
        cholesterolDate.delegate = self
        cholesterolDate.addTarget(self, action: #selector(myTargetFunctionDate), for: UIControlEvents.touchDown)
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            cholesterolDate.text = editDate
        }else{
            cholesterolDate.text = dateToday.stringFromFormat("dd-MM-yyyy")
        }
        
        
        
    }
    
    private func preparecholesterolTime() {
        
        cholesterolTime.placeholder = "Time"
        
        cholesterolTime.detailLabel.numberOfLines = 0
        cholesterolTime.resignFirstResponder()
        
        cholesterolTime.delegate = self
        
        cholesterolTime.addTarget(self, action: #selector(myTargetFunction), for: UIControlEvents.touchDown)
        
        let dateToday = Date()
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            cholesterolTime.text = editTime
        }else{
            cholesterolTime.text = dateToday.stringFromFormat("HH:mm")
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
    private func preparecholesterolTotal() {
        
        cholesterolTotal.placeholder = "Total (mmol/L)"
        cholesterolTotal.detail = Constants.err_msg_cholesterol
        cholesterolTotal.isClearIconButtonEnabled = true
        
        cholesterolTotal.detailLabel.numberOfLines = 0
        
        
        cholesterolTotal.delegate = self
        
        cholesterolTotal.addTarget(self,action: #selector(textFieldDidChangeTotal),for: UIControlEvents.editingDidEnd)
        cholesterolTotal.addTarget(self,action: #selector(textFieldDidChangeTotalLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeTotal(textField: UITextField) {
        
        let Str: String = cholesterolTotal.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str)){
                
                cholesterolTotal.isErrorRevealed = true
                cholesterolTotal.detail = Constants.err_msg_cholesterol
            }else if(!validateValueDecimal(testStr: Str)){
                cholesterolTotal.isErrorRevealed = true
                cholesterolTotal.detail = Constants.err_msg_two_decimal
                
            }
            else{
                cholesterolTotal.isErrorRevealed = false
                
            }
        }else{
            cholesterolTotal.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeTotalLength(textField: UITextField) {
        
        
        checkMaxLengthTotal(textField: cholesterolTotal,maxLength: 5)
        
    }
    
    
    func checkMaxLengthTotal(textField: UITextField!, maxLength: Int) {
        if (cholesterolTotal.text!.characters.count > maxLength) {
            cholesterolTotal.deleteBackward()
        }
    }
    
    private func preparecholesterolHDL() {
        
        cholesterolHDL.placeholder = "HDL (mmol/L)"
        cholesterolHDL.detail = Constants.err_msg_cholesterol
        cholesterolHDL.isClearIconButtonEnabled = true
        cholesterolHDL.detailLabel.numberOfLines = 0
        cholesterolHDL.delegate = self
        
        cholesterolHDL.addTarget(self,action: #selector(textFieldDidChangeHDL),for: UIControlEvents.editingDidEnd)
        cholesterolHDL.addTarget(self,action: #selector(textFieldDidChangeHDLLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeHDL(textField: UITextField) {
        
        let Str: String = cholesterolHDL.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str)){
                
                cholesterolHDL.isErrorRevealed = true
                cholesterolHDL.detail = Constants.err_msg_cholesterol
            }else if(!validateValueDecimal(testStr: Str)){
                cholesterolHDL.isErrorRevealed = true
                cholesterolHDL.detail = Constants.err_msg_two_decimal
                
            }
            else{
                cholesterolHDL.isErrorRevealed = false
                
            }
        }else{
            cholesterolHDL.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeHDLLength(textField: UITextField) {
        
        
        checkMaxLengthHDL(textField: cholesterolTotal,maxLength: 5)
        
    }
    
    
    func checkMaxLengthHDL(textField: UITextField!, maxLength: Int) {
        if (cholesterolHDL.text!.characters.count > maxLength) {
            cholesterolHDL.deleteBackward()
        }
    }
    
    
    
    
    private func preparecholesterolLDL() {
        
        cholesterolLDL.placeholder = "LDL (mmol/L)"
        cholesterolLDL.detail = Constants.err_msg_cholesterol
        cholesterolLDL.isClearIconButtonEnabled = true
        cholesterolLDL.detailLabel.numberOfLines = 0
        cholesterolLDL.delegate = self
        
        cholesterolLDL.addTarget(self,action: #selector(textFieldDidChangeLDL),for: UIControlEvents.editingDidEnd)
        cholesterolLDL.addTarget(self,action: #selector(textFieldDidChangeLDLLength),for: UIControlEvents.editingChanged)
        
        
        
        
    }
    
    func textFieldDidChangeLDL(textField: UITextField) {
        
        let Str: String = cholesterolLDL.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str)){
                
                cholesterolLDL.isErrorRevealed = true
                cholesterolLDL.detail = Constants.err_msg_cholesterol
            }else if(!validateValueDecimal(testStr: Str)){
                cholesterolLDL.isErrorRevealed = true
                cholesterolLDL.detail = Constants.err_msg_two_decimal
                
            }
            else{
                cholesterolLDL.isErrorRevealed = false
                
            }
        }else{
            cholesterolLDL.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLDLLength(textField: UITextField) {
        
        
        checkMaxLengthLDL(textField: cholesterolLDL,maxLength: 5)
        
    }
    
    
    func checkMaxLengthLDL(textField: UITextField!, maxLength: Int) {
        if (cholesterolLDL.text!.characters.count > maxLength) {
            cholesterolLDL.deleteBackward()
        }
    }
    
    
    
    private func preparecholesterolTrig() {
        
        cholesterolTrig.placeholder = "Triglycerides (mmol/L)"
        cholesterolTrig.detail = Constants.err_msg_cholesterol
        cholesterolTrig.isClearIconButtonEnabled = true
        cholesterolTrig.detailLabel.numberOfLines = 0
        cholesterolTrig.delegate = self
        
        cholesterolTrig.addTarget(self,action: #selector(textFieldDidChangeTrig),for: UIControlEvents.editingDidEnd)
        cholesterolTrig.addTarget(self,action: #selector(textFieldDidChangeTrigLength),for: UIControlEvents.editingChanged)
        
        
        
    }
    
    func textFieldDidChangeTrig(textField: UITextField) {
        
        let Str: String = cholesterolTrig.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str)){
                
                cholesterolTrig.isErrorRevealed = true
                cholesterolTrig.detail = Constants.err_msg_cholesterol
            }else if(!validateValueDecimal(testStr: Str)){
                cholesterolTrig.isErrorRevealed = true
                cholesterolTrig.detail = Constants.err_msg_two_decimal
                
            }
            else{
                cholesterolTrig.isErrorRevealed = false
                
            }
        }else{
            cholesterolTrig.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeTrigLength(textField: UITextField) {
        
        
        checkMaxLengthTrig(textField: cholesterolTrig,maxLength: 5)
        
    }
    
    
    func checkMaxLengthTrig(textField: UITextField!, maxLength: Int) {
        if (cholesterolTrig.text!.characters.count > maxLength) {
            cholesterolTrig.deleteBackward()
        }
    }
    
    
    private func prepareSaveButton() {
        
        let rightNavItem = saveButton
        rightNavItem?.action = #selector(CholesterolController.buttonTapAction)
        
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
        
        
        let strTotal: String = cholesterolTotal.text!
        let strTrig: String = cholesterolTrig.text!
        let strHDL: String = cholesterolHDL.text!
        let strLDL: String = cholesterolLDL.text!
        
        
        
        if (strTotal.isEmpty && strTrig.isEmpty && strHDL.isEmpty && strLDL.isEmpty) {
            
            
            self.view.makeToast("At least one field is to be filled in", duration: 3.0, position: .bottom)
            return
        }
        
        if(!strTotal.isEmpty){
            
            if(strTotal.isEmpty || !validateValue(testStr: strTotal)){
                cholesterolTotal.isErrorRevealed = true
                cholesterolTotal.detail = Constants.err_msg_cholesterol
                self.cholesterolTotal.becomeFirstResponder()
                return
            }
            
            if(!validateValueDecimal(testStr: strTotal)){
                cholesterolTotal.isErrorRevealed = true
                cholesterolTotal.detail = Constants.err_msg_two_decimal
                self.cholesterolTotal.becomeFirstResponder()
                return
            }
            
            fields.append("Total-" + cholesterolTotal.text! + "-" + idTotal)
        }
        
        if(!strHDL.isEmpty){
            
            if(strHDL.isEmpty || !validateValue(testStr: strHDL)){
                cholesterolHDL.isErrorRevealed = true
                cholesterolHDL.detail = Constants.err_msg_cholesterol
                self.cholesterolHDL.becomeFirstResponder()
                return
            }
            
            if(!validateValueDecimal(testStr: strHDL)){
                cholesterolHDL.isErrorRevealed = true
                cholesterolHDL.detail = Constants.err_msg_two_decimal
                self.cholesterolHDL.becomeFirstResponder()
                return
            }
            
            fields.append("HDL-" + cholesterolHDL.text! + "-" + idHdl)
        }
        if(!strLDL.isEmpty){
            
            if(strLDL.isEmpty || !validateValue(testStr: strLDL)){
                cholesterolLDL.isErrorRevealed = true
                cholesterolLDL.detail = Constants.err_msg_cholesterol
                self.cholesterolLDL.becomeFirstResponder()
                return
            }
            
            if(!validateValueDecimal(testStr: strLDL)){
                cholesterolLDL.isErrorRevealed = true
                cholesterolLDL.detail = Constants.err_msg_two_decimal
                self.cholesterolLDL.becomeFirstResponder()
                return
            }
            
            fields.append("LDL-" + cholesterolLDL.text! + "-" + idLdl)
        }
        
        if(!strTrig.isEmpty){
            
            if(strTrig.isEmpty || !validateValue(testStr: strTrig)){
                cholesterolTrig.isErrorRevealed = true
                cholesterolTrig.detail = Constants.err_msg_cholesterol
                self.cholesterolTrig.becomeFirstResponder()
                return
            }
            
            if(!validateValueDecimal(testStr: strTrig)){
                cholesterolTrig.isErrorRevealed = true
                cholesterolTrig.detail = Constants.err_msg_two_decimal
                self.cholesterolTrig.becomeFirstResponder()
                return
            }
            
            fields.append("Triglycerides-" + cholesterolTrig.text! + "-" + idTrig)
        }
        
        sendHealthAssessment()
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
        if (!isValidRange(testStr: testStr)) {
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
    
    
    
    func isValidRange(testStr:String) -> Bool {
        
        if (!isValidDecimal(testStr: testStr)) {
            return true
        }else{
            let formatter = NumberFormatter()
            let Svalue = formatter.number(from: (testStr as NSString) as String)
            let s:String = String(format:"%.2f", Svalue!.doubleValue)
            let myDouble = (s as NSString).doubleValue
            
            let valueNew = myDouble * 100
            
            
            if (valueNew  >= (0*100) && valueNew  <= (20*100)) {
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
                
                cholesterolDate.text = date.stringFromFormat("dd-MM-yyyy")
            }
        }
        if(NewTime == true){
            cholesterolTime.text = date.stringFromFormat("HH:mm")
        }
        
        NewDate = false
        NewTime = false
        
    }
    
    func showFutureDate() {
        let ac = UIAlertController(title: "Message", message: "You cannot select a future date, please select a current or past date.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    func jsonToString(json: AnyObject) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString!  // <-- here is ur string
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
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
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        CholesterolController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
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
        
        
        let strDate: String = cholesterolDate.text!
        let strTime: String = cholesterolTime.text!
        
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
            "records": savedFiles,
            "_hide": hideBool,
            "loggedInUserDetailsId": String(loggedInUserDetailsId),
            "currentActiveUserDetailsId": String(currentActiveUserDetailsId),
            "type": "Cholesterol",
            "dateAndTime": dateAndTime
        ]
        
        
       
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json",
            "Content-Type": "application/json"
            
        ]
        
        
        CholesterolController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
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

extension String {
    var floatValue: Float {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.floatValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
}

extension CholesterolController: TextFieldDelegate {
    
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
        
        if(cholesterolTime.isEditing){
            return false
        }else if(cholesterolDate.isEditing){
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
