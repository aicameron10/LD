//
//  HospitalSubRecord.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/02/07.
//  Copyright © 2017 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire
import Toast_Swift
import DropDown


class HospitalSubRecord: UIViewController, WWCalendarTimeSelectorProtocol,UITextViewDelegate{
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateView1: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bpDate: ErrorTextField!
    @IBOutlet weak var bpDate1: ErrorTextField!
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBOutlet weak var ReasonText: UITextView!
    
    @IBOutlet weak var hosName: ErrorTextField!
    @IBOutlet weak var hosDoctorName: ErrorTextField!
    
    @IBOutlet weak var TreatText: UITextView!
    @IBOutlet weak var hideButton: UIButton!
    
    @IBOutlet weak var errorReason: UILabel!
    @IBOutlet weak var errorTreat: UILabel!
    
    @IBOutlet weak var wordCount: UILabel!
    @IBOutlet weak var wordCount1: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var clearButton1: UIButton!
    
    @IBOutlet weak var bpCalendar: UIButton!
    @IBOutlet weak var bpCalendar1: UIButton!
    fileprivate var singleDate: Date = Date()
    
    fileprivate var multipleDates: [Date] = []
    
    var messageStr : String = String()
    
    
    var NewDate : Bool = Bool()
    
    var NewCheck : Bool = Bool()
    
    var deleteRecord : Bool = Bool()
     var dischargeDate : Bool = Bool()
    
    var fromDoc : Bool = Bool()
    
    var hideBool : Bool = Bool()
    var fields : Array<String> = Array()
    
    var somethingChanged : Bool = Bool()
    
    var add : Array<String> = Array()
    
    var hideImage : Bool = Bool()
    
    var subRecords : Array<String> = Array()
    
    var deletedList : Array<String> = Array()
    
    var editDateTime = ""
    
    var editDatead = ""
     var editDatedis = ""
    var editReason = ""
    var editTreat = ""
    var edithosName = ""
 
    var edithosDoc = ""
    
    var recordValue = ""
    
    var editFromDoc = ""
    
    var lastdate = ""
    
    var dropDownOption = ""
    
    var countAttachments = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HospitalSubRecord.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Edit Hospital visit"
        
        deleteRecord = false
        NewDate = false
        hideBool = false
        somethingChanged = false
        
        dischargeDate = false
        
        NewCheck = false
        
        fromDoc = true
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "HosEdit") != nil){
            loadDataSingle()
            
        }
        
        errorTreat.isHidden = true
        errorReason.isHidden = true
        clearButton.isHidden = true
        clearButton1.isHidden = true
        
        
        prepareCloseButton()
        prepareCalendarButton()
        prepareCalendarButton1()
        prepareSaveButton()
        prepareHideButton()
        prepareDeleteButton()
        prepareTreat()
        prepareDate()
        prepareDateView()
               prepareDateView1()
        prepareClearButton()
        prepareClearButton1()
        preparehosName()
        preparehosDoc()
        prepareDate1()
        prepareReason()
        
        
        
        
    }
    
    
    
    
    public func loadJSONSingle() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "HosEdit") != nil){
            
            return JSON.parse(prefs.string(forKey: "HosEdit")!)
        }else{
            return nil
        }
        
    }
    
    
    func loadDataSingle(){
        
        let json = self.loadJSONSingle()
        
        //print(json)
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        
        print(json[posIndex!]["value"].stringValue)
        
        let recordId = json[posIndex!]["recordId"].stringValue
        let hosName = json[posIndex!]["Hospital name"].stringValue

        let hosDoc = json[posIndex!]["Who was the treating doctor?"].stringValue
        let reason = json[posIndex!]["Diagnosis/Reason for visit?"].stringValue
        let desc = json[posIndex!]["What treatment did you receive?"].stringValue
        let updatedDate = json[posIndex!]["lastUpdated"].stringValue
        
        
        
        
        let adDate = json[posIndex!]["Admission date"].stringValue
        let disDate = json[posIndex!]["Discharge date"].stringValue
        
        if (json[posIndex!]["_hide"].stringValue == "true"){
            
            hideImage = true
            
        }else{
            hideImage = false
            
        }
        editReason = reason
        editTreat = desc
        edithosName = hosName
        
        
        edithosDoc = hosDoc
    
        recordValue = recordId
       
        editDatead = adDate
        editDatedis = disDate
        lastdate = updatedDate
        deletedList.append(json[posIndex!]["recordId"].stringValue)
        
        
        
        
        
        
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
        scrollView.contentSize = CGSize(width: 300, height: 950)
    }
    
    
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(HospitalSubRecord.buttonTapActionClose)
        
        
    }
    
    func showDatePicker() {
        
        NewDate = true
        
        showCal()
    }
    
    
    
    private func prepareDateView() {
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HospitalSubRecord.showDatePicker))
        dateView.addGestureRecognizer(tapDateView)
        
        dischargeDate = false
    }
    
    private func prepareDateView1() {
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HospitalSubRecord.showDatePicker))
        dateView1.addGestureRecognizer(tapDateView)
        
        dischargeDate = true
    }

    
    
    private func prepareCalendarButton() {
        bpCalendar.addTarget(self, action: #selector(buttonCalendarAction), for: .touchUpInside)
        
    }
    
    private func prepareCalendarButton1() {
        bpCalendar1.addTarget(self, action: #selector(buttonCalendarAction1), for: .touchUpInside)
        
    }
    
    func buttonCalendarAction(sender: UIButton!) {
        print("Button tapped")
        NewDate = true
        dischargeDate = false
        showCal()
    }
    func buttonCalendarAction1(sender: UIButton!) {
        print("Button tapped")
        NewDate = true
        dischargeDate = true
        
        showCal()
    }

    
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTable"), object: nil)
        
        if(somethingChanged == true){
            changed()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    
    
    
    
    private func prepareDate() {
        
        bpDate.placeholder = "Admission date"
        bpDate.resignFirstResponder()
        bpDate.detailLabel.numberOfLines = 0
        bpDate.delegate = self
        bpDate.addTarget(self, action: #selector(myTargetFunctionDate), for: UIControlEvents.touchDown)
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "HosEdit") != nil){
            bpDate.text = editDatead
        }else{
            bpDate.text = dateToday.stringFromFormat("dd-MM-yyyy")
        }
        
        
    }
    
    
    
    func myTargetFunctionDate(textField: UITextField) {
        NewDate = true
        showCal()
    }
    
    
    private func prepareDate1() {
        
        bpDate1.placeholder = "Discharge date"
        bpDate1.resignFirstResponder()
        bpDate1.detailLabel.numberOfLines = 0
        bpDate1.delegate = self
        bpDate1.addTarget(self, action: #selector(myTargetFunctionDate1), for: UIControlEvents.touchDown)
        bpDate1.addTarget(self,action: #selector(textFieldDidChangedate),for: UIControlEvents.editingDidEnd)
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "HosEdit") != nil){
            bpDate1.text = editDatedis
        }else{
            bpDate1.text = ""
        }
        
        
    }
    
    func textFieldDidChangedate(textField: UITextField) {
        
        let Str: String = bpDate1.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                bpDate1.isErrorRevealed = true
                bpDate1.detail = Constants.err_msg_date_hos
            } else{
                bpDate1.isErrorRevealed = false
                
            }
        }else{
            bpDate1.isErrorRevealed = false
            
        }
        
        
        
    }

    
    func myTargetFunctionDate1(textField: UITextField) {
        NewDate = true
        showCal()
    }

    
    
    private func preparehosName() {
        
        
        hosName.placeholder = "Hospital Name"
        hosName.detail = Constants.err_msg_name_hos
        hosName.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "HosEdit") != nil){
            hosName.text = edithosName
            
        }else{
            hosName.text = ""
        }

        
        
        
        hosName.detailLabel.numberOfLines = 0
        
        hosName.delegate = self
        
        hosName.addTarget(self,action: #selector(textFieldDidChange),for: UIControlEvents.editingDidEnd)
        hosName.addTarget(self,action: #selector(textFieldDidChangeLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        let Str: String = hosName.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                hosName.isErrorRevealed = true
                hosName.detail = Constants.err_msg_name_hos
            } else{
                hosName.isErrorRevealed = false
                
            }
        }else{
            hosName.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLength(textField: UITextField) {
        
        
        checkMaxLength(textField: hosName,maxLength: 50)
        
    }
    
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (hosName.text!.characters.count > maxLength) {
            hosName.deleteBackward()
        }
    }
    
    
    private func preparehosDoc() {
        
        hosDoctorName.placeholder = "Treating doctor name"
        hosDoctorName.detail = Constants.err_msg_name_hos_treat
        hosDoctorName.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
       
        
        
        if (prefs.string(forKey: "HosEdit") != nil){
            hosDoctorName.text = edithosDoc
            
        } else{
            hosDoctorName.text = ""
        }
        
        
        hosDoctorName.detailLabel.numberOfLines = 0
        
        hosDoctorName.delegate = self
        
       hosDoctorName.addTarget(self,action: #selector(textFieldDidChangeNum),for: UIControlEvents.editingDidEnd)
        hosDoctorName.addTarget(self,action: #selector(textFieldDidChangeLengthNum),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeNum(textField: UITextField) {
        
        let Str: String = hosDoctorName.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                hosDoctorName.isErrorRevealed = true
                hosDoctorName.detail = Constants.err_msg_name_hos_treat
            } else{
                hosDoctorName.isErrorRevealed = false
                
            }
        }else{
            hosDoctorName.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLengthNum(textField: UITextField) {
        
        
        checkMaxLengthNum(textField: hosDoctorName,maxLength: 50)
        
    }
    
    
    func checkMaxLengthNum(textField: UITextField!, maxLength: Int) {
        if (hosDoctorName.text!.characters.count > maxLength) {
            hosDoctorName.deleteBackward()
        }
    }
    
       
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-(){}[]*^%$#@!?,._'/;:\\&\"<>\n ").inverted
        let components = text.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        
        
        
        if(ReasonText.isFirstResponder == true){
            if(numberOfChars > 1000){
                return numberOfChars <= 1000
            }else{
                wordCount.text = String(describing: (1000 - numberOfChars))
                
                if(wordCount.text?.contains("-"))!{
                    wordCount.text = "0"
                }
            }
            
        }
        if(TreatText.isFirstResponder == true){
            if(numberOfChars > 1000){
                return numberOfChars <= 1000
            }else{
                wordCount1.text = String(describing: (1000 - numberOfChars))
                
                if(wordCount1.text?.contains("-"))!{
                    wordCount1.text = "0"
                }
            }
            
        }
        
        
        return text == filtered
        
        
        
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text); //the textView parameter is the textView where text was changed
    }
    
    private func prepareTreat() {
        
        
        TreatText.delegate = self
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "HosEdit") != nil){
            TreatText.text = editTreat
            wordCount1.text = String(describing: (1000 - editTreat.characters.count))
        }else{
            TreatText.text = ""
        }
        
        
        
    }
    
    private func prepareReason() {
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "globalReason") != nil){
            
            ReasonText.text = prefs.string(forKey: "globalReason")!
            wordCount.text = String(describing: (1000 - prefs.string(forKey: "globalReason")!.characters.count))
        }
        
        ReasonText.delegate = self
        
        if (prefs.string(forKey: "HosEdit") != nil){
            ReasonText.text = editReason
            wordCount.text = String(describing: (1000 - editReason.characters.count))
        }
        
        
        
    }
    
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        
        if(ReasonText.isFirstResponder == true){
            clearButton.isHidden = false
        }
        if(TreatText.isFirstResponder == true){
            clearButton1.isHidden = false
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        
        clearButton.isHidden = true
        clearButton1.isHidden = true
    }
    
    
    
    
    private func prepareClearButton1() {
        
        
        clearButton1.addTarget(self, action: #selector(buttonClearAction1), for: .touchUpInside)
        
        
    }
    
    private func prepareClearButton() {
        
        
        clearButton.addTarget(self, action: #selector(buttonClearAction), for: .touchUpInside)
        
        
    }
    
    
    func buttonClearAction(sender: UIButton!) {
        print("Button tapped")
        ReasonText.text = ""
        wordCount.text = "1000"
        
    }
    
    
    func buttonClearAction1(sender: UIButton!) {
        print("Button tapped")
        TreatText.text = ""
        wordCount1.text = "1000"
        
    }
    
    
    
    private func prepareSaveButton() {
        
        let rightNavItem = saveButton
        rightNavItem?.action = #selector(HospitalSubRecord.buttonTapAction)
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "HosEdit") != nil){
            rightNavItem?.title = "Continue"
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
        let ac = UIAlertController(title: "Message", message: "Are you sure you wish to delete this information?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
        })
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            self.delete()
            
        })
        present(ac, animated: true)
    }
    
    
    
    private func prepareDeleteButton() {
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "HosEdit") != nil) {
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
        
        
        deleteButton.addTarget(self, action: #selector(buttonDeleteAction), for: .touchUpInside)
        
    }
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
       
            
            if(hosName.text?.trimmed.isEmpty)!{
                hosName.isErrorRevealed = true
                hosName.detail = Constants.err_msg_name_hos
                self.hosName.becomeFirstResponder()
                
                return
            }
        if(hosDoctorName.text?.trimmed.isEmpty)!{
            hosDoctorName.isErrorRevealed = true
            hosDoctorName.detail = Constants.err_msg_name_hos_treat
            self.hosDoctorName.becomeFirstResponder()
            
            return
        }
        
        if(bpDate1.text?.trimmed.isEmpty)!{
            bpDate1.isErrorRevealed = true
            bpDate1.detail = Constants.err_msg_date_hos
            //self.bpDate1.becomeFirstResponder()
            
            return
        }
        
        let myDateString = bpDate.text!
        let myDateString1 = bpDate1.text!
        
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd-MM-yyyy"
        let myDate = dateFormatter.date(from: myDateString)!
        let myDate1 = dateFormatter.date(from: myDateString1)!
        
       

        if(myDate1 < myDate){
            self.bpDate1.isErrorRevealed = true
            self.bpDate1.detail = Constants.err_msg_date_hos_ad
            
            
            return
        }

        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "HosEdit") != nil) {
            editValues()
        }else{
            save()
        }
        
        
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
            
            if(dischargeDate == false){
            if date > dateToday {
                print("future date")
                
                self.view.makeToast("You cannot select a future date, please select a current or past date.", duration: 3.0, position: .center)
                
            }else{
                
                bpDate.text = date.stringFromFormat("dd-MM-yyyy")
            }
            }else{
                
                
                bpDate1.isErrorRevealed = false
                bpDate1.text = date.stringFromFormat("dd-MM-yyyy")
               
               
            }
        }
        
        
        NewDate = false
        
        
    }
    
    func showFutureDate() {
        let ac = UIAlertController(title: "Message", message: "You cannot select a future date, please select a current or past date.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    private func save() {
        
        
        
        let strDate: String = bpDate.text!
         let strDate1: String = bpDate1.text!
        
        let reason: String = ReasonText.text!
        
        let treat: String = TreatText.text!
        
        let hosName: String = self.hosName.text!
        let docName: String = self.hosDoctorName.text!

        
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "HosEdit") != nil){
            jsonObject.setValue(lastdate, forKey: "lastUpdated")
            jsonObject.setValue(recordValue, forKey: "recordId")
        }else{
            jsonObject.setValue("", forKey: "lastUpdated")
            jsonObject.setValue("", forKey: "recordId")
        }
        
        
        jsonObject.setValue("HospitalVisitSubrecord", forKey: "_type")
        jsonObject.setValue(true, forKey: "_save")
        jsonObject.setValue(false, forKey: "_delete")
        jsonObject.setValue(strDate, forKey: "Admission date")
        jsonObject.setValue(strDate1, forKey: "Discharge date")
        jsonObject.setValue(hideBool, forKey: "_hide")
        jsonObject.setValue(hosName, forKey: "Hospital name")
        jsonObject.setValue(docName, forKey: "Who was the treating doctor?")

        jsonObject.setValue(reason, forKey: "Diagnosis/Reason for visit?")
        jsonObject.setValue(treat, forKey: "What treatment did you receive?")
        
        let jsonData: NSData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
            //print("json string = \(jsonString)")
            
            var jj = ""
            
            if (prefs.string(forKey: "Hospitals") != nil){
                let j = prefs.string(forKey: "Hospitals")?.replacingOccurrences(of: "[", with: "")
                let k = j?.replacingOccurrences(of: "]", with: "")
                
                jj = "[" + k!  + "," + jsonString + "]"
                
            }else{
                jj = "[" + jsonString + "]"
            }
            
            print(jj)
            
            let prefs = UserDefaults.standard
            prefs.set(jj, forKey: "Hospitals")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
            
            self.dismissView();
            
            
            
            
        } catch _ {
            print ("JSON Failure")
        }
        
        
        
        
        self.dismissView();
        
        
    }
    
    public func loadJSON() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Hospitals") != nil){
            
            return JSON.parse(prefs.string(forKey: "Hospitals")!)
        }else{
            return nil
        }
        
    }
    
    public func saveJSON(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "Hospitals")
        
        // here I save my JSON as a string
    }
    
    
    
    private func delete() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSON()
        
        if (prefs.string(forKey: "Hospitals") != nil){
            
            json[posIndex!]["_delete"].boolValue = true
            json[posIndex!]["_save"].boolValue = false
            
            self.saveJSON(j: json)
            
            print(json)
            
        }
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
        self.dismissView();
        
        
    }
    
    private func editValues() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSON()
     
        
        if (prefs.string(forKey: "Hospitals") != nil){
            
            json[posIndex!]["Admission date"].stringValue = bpDate.text!
            json[posIndex!]["Discharge date"].stringValue = bpDate1.text!
            json[posIndex!]["Diagnosis/Reason for visit?"].stringValue = ReasonText.text!
            json[posIndex!]["What treatment did you receive?"].stringValue = TreatText.text!
            json[posIndex!]["Hospital name"].stringValue = hosName.text!
            json[posIndex!]["Who was the treating doctor?"].stringValue = hosDoctorName.text!
            json[posIndex!]["_hide"].boolValue = hideBool
            json[posIndex!]["_save"].boolValue = true
            
            
            
            self.saveJSON(j: json)
            
            print(json)
            
        }
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
        self.dismissView();
        
        
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


extension HospitalSubRecord: TextFieldDelegate {
    
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

