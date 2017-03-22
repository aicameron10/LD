//
//  DoctorSubRecord.swift
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


class DoctorSubRecord: UIViewController, WWCalendarTimeSelectorProtocol,UITextViewDelegate{
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bpDate: ErrorTextField!
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBOutlet weak var ReasonText: UITextView!
    
    @IBOutlet weak var docName: ErrorTextField!
    @IBOutlet weak var docNum: ErrorTextField!
    @IBOutlet weak var docSpecial: ErrorTextField!
    @IBOutlet weak var TreatText: UITextView!
    @IBOutlet weak var hideButton: UIButton!
    
    @IBOutlet weak var errorReason: UILabel!
    @IBOutlet weak var errorTreat: UILabel!
    
    @IBOutlet weak var wordCount: UILabel!
    @IBOutlet weak var wordCount1: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var clearButton1: UIButton!
    
    @IBOutlet weak var bpCalendar: UIButton!
    fileprivate var singleDate: Date = Date()
    
    fileprivate var multipleDates: [Date] = []
    
    var messageStr : String = String()
    
    var idDiastolic : String = String()
    
    var NewDate : Bool = Bool()
    
    var NewCheck : Bool = Bool()
    
    var deleteRecord : Bool = Bool()
    
    
    var fromDoc : Bool = Bool()
    
    var hideBool : Bool = Bool()
    var fields : Array<String> = Array()
    
    var somethingChanged : Bool = Bool()
    
    var add : Array<String> = Array()
    
    var hideImage : Bool = Bool()
    
    var subRecords : Array<String> = Array()
    
    var deletedList : Array<String> = Array()
    
    var editDateTime = ""
    
    var editDate = ""
    
    var editReason = ""
    var editTreat = ""
    var editDocName = ""
    var editDocNum = ""
    var editDocSpecial = ""
    
    var recordValue = ""
    
    var editFromDoc = ""
    
    var lastdate = ""
    
    var dropDownOption = ""
    
    var countAttachments = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DoctorSubRecord.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Edit Doctor visit"
        
        deleteRecord = false
        NewDate = false
        hideBool = false
        somethingChanged = false
        
        NewCheck = false
        
        fromDoc = true
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "DocEdit") != nil){
            loadDataSingle()
            
        }
        
        errorTreat.isHidden = true
        errorReason.isHidden = true
        clearButton.isHidden = true
        clearButton1.isHidden = true
        
        
        prepareCloseButton()
        prepareCalendarButton()
        prepareSaveButton()
        prepareHideButton()
        prepareDeleteButton()
        prepareTreat()
        prepareDate()
        prepareDateView()
        prepareClearButton()
        prepareClearButton1()
        prepareDocName()
        prepareDocSpecail()
        prepareDocNum()
        
        prepareReason()
        
        
        
        
    }
    
    
    
    
    public func loadJSONSingle() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "DocEdit") != nil){
            
            return JSON.parse(prefs.string(forKey: "DocEdit")!)
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
        let docName = json[posIndex!]["Name of doctor"].stringValue
        let docNum = json[posIndex!]["Contact number"].stringValue
        let docSpecail = json[posIndex!]["Doctor type/specialization"].stringValue
        let reason = json[posIndex!]["Diagnosis/Reason for visit?"].stringValue
        let desc = json[posIndex!]["What treatment was given?"].stringValue
        let updatedDate = json[posIndex!]["lastUpdated"].stringValue
        
        
        
        
        let Date = json[posIndex!]["Date visited"].stringValue
        
        if (json[posIndex!]["_hide"].stringValue == "true"){
            
            hideImage = true
            
        }else{
            hideImage = false
            
        }
        editReason = reason
        editTreat = desc
        editDocName = docName
        
        prefs.set(docName, forKey: "globalDoctor")
        editDocSpecial = docSpecail
        editDocNum = docNum
        recordValue = recordId
        
        //editFromDoc = fromDoc
        editDate = Date
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
        scrollView.contentSize = CGSize(width: 300, height: 1000)
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
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DoctorSubRecord.showDatePicker))
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTable"), object: nil)
        
        if(somethingChanged == true){
            changed()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    
    
    
    
    private func prepareDate() {
        
        bpDate.placeholder = "Date of visit"
        bpDate.resignFirstResponder()
        bpDate.detailLabel.numberOfLines = 0
        bpDate.delegate = self
        bpDate.addTarget(self, action: #selector(myTargetFunctionDate), for: UIControlEvents.touchDown)
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "DocEdit") != nil){
            bpDate.text = editDate
        }else{
            bpDate.text = dateToday.stringFromFormat("dd-MM-yyyy")
        }
        
        
    }
    
    
    
    func myTargetFunctionDate(textField: UITextField) {
        NewDate = true
        showCal()
    }
    
    
    
    private func prepareDocName() {
        
        docName.placeholder = "Doctor Name"
        docName.detail = Constants.err_msg_name_medi_doc
        docName.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        
        
        if (prefs.string(forKey: "DocEdit") != nil){
            docName.text = editDocName
            
        }else{
            docName.text = ""
        }
        
        
        docName.detailLabel.numberOfLines = 0
        
        docName.delegate = self
        
        docName.addTarget(self,action: #selector(textFieldDidChange),for: UIControlEvents.editingDidEnd)
        docName.addTarget(self,action: #selector(textFieldDidChangeLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        let Str: String = docName.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                docName.isErrorRevealed = true
                docName.detail = Constants.err_msg_name_medi_doc
            } else{
                docName.isErrorRevealed = false
                
            }
        }else{
            docName.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLength(textField: UITextField) {
        
        
        checkMaxLength(textField: docName,maxLength: 70)
        
    }
    
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (docName.text!.characters.count > maxLength) {
            docName.deleteBackward()
        }
    }
    
    
    private func prepareDocNum() {
        
        docNum.placeholder = "Contact Number"
        //docNum.detail = Constants.err_msg_name_path
        docNum.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "DocEdit") != nil){
            docNum.text = editDocNum
            
        }else{
            docNum.text = ""
        }
        
        
        docNum.detailLabel.numberOfLines = 0
        
        docNum.delegate = self
        
        //docNum.addTarget(self,action: #selector(textFieldDidChangeNum),for: UIControlEvents.editingDidEnd)
        docNum.addTarget(self,action: #selector(textFieldDidChangeLengthNum),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeNum(textField: UITextField) {
        
        let Str: String = docNum.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                docNum.isErrorRevealed = true
                //docNum.detail = Constants.err_msg_name_path
            } else{
                docNum.isErrorRevealed = false
                
            }
        }else{
            docNum.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLengthNum(textField: UITextField) {
        
        
        checkMaxLengthNum(textField: docNum,maxLength: 20)
        
    }
    
    
    func checkMaxLengthNum(textField: UITextField!, maxLength: Int) {
        if (docNum.text!.characters.count > maxLength) {
            docNum.deleteBackward()
        }
    }
    
    private func prepareDocSpecail() {
        
        docSpecial.placeholder = "Doctor Specialisation"
        //docSpecial.detail = Constants.err_msg_name_path
        docSpecial.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "DocEdit") != nil){
            docSpecial.text = editDocSpecial
            
        }else{
            docSpecial.text = ""
        }
        
        
        docSpecial.detailLabel.numberOfLines = 0
        
        docSpecial.delegate = self
        
        //docSpecial.addTarget(self,action: #selector(textFieldDidChangeSpecial),for: UIControlEvents.editingDidEnd)
        docSpecial.addTarget(self,action: #selector(textFieldDidChangeLengthSpecial),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeSpecial(textField: UITextField) {
        
        let Str: String = docSpecial.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                docSpecial.isErrorRevealed = true
                //docSpecial.detail = Constants.err_msg_name_path
            } else{
                docSpecial.isErrorRevealed = false
                
            }
        }else{
            docSpecial.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLengthSpecial(textField: UITextField) {
        
        
        checkMaxLengthSpecial(textField: docName,maxLength: 200)
        
    }
    
    
    func checkMaxLengthSpecial(textField: UITextField!, maxLength: Int) {
        if (docSpecial.text!.characters.count > maxLength) {
            docSpecial.deleteBackward()
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
        if (prefs.string(forKey: "DocEdit") != nil){
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
        
        if (prefs.string(forKey: "DocEdit") != nil){
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
        rightNavItem?.action = #selector(DoctorSubRecord.buttonTapAction)
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "DocEdit") != nil){
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
        if (prefs.string(forKey: "DocEdit") != nil) {
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
        
        
        deleteButton.addTarget(self, action: #selector(buttonDeleteAction), for: .touchUpInside)
        
    }
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        if(NewCheck == false){
            
            if(docName.text?.trimmed.isEmpty)!{
                docName.isErrorRevealed = true
                docName.detail = Constants.err_msg_name_path
                self.docName.becomeFirstResponder()
                
                return
            }
        }
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "DocEdit") != nil) {
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
    
    
    
    private func save() {
        
        
        
        let strDate: String = bpDate.text!
        
        let reason: String = ReasonText.text!
        
        let treat: String = TreatText.text!
        
        let docName: String = self.docName.text!
        let docNum: String = self.docNum.text!
        let docSpecial: String = self.docSpecial.text!
        
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "DocEdit") != nil){
            jsonObject.setValue(lastdate, forKey: "lastUpdated")
            jsonObject.setValue(recordValue, forKey: "recordId")
        }else{
            jsonObject.setValue("", forKey: "lastUpdated")
            jsonObject.setValue("", forKey: "recordId")
        }
        
        
        jsonObject.setValue("DoctorVisitSubrecord", forKey: "_type")
        jsonObject.setValue(true, forKey: "_save")
        jsonObject.setValue(false, forKey: "_delete")
        jsonObject.setValue(strDate, forKey: "Date visited")
        jsonObject.setValue(hideBool, forKey: "_hide")
        jsonObject.setValue(docName, forKey: "Name of doctor")
        jsonObject.setValue(docNum, forKey: "Contact number")
        jsonObject.setValue(docSpecial, forKey: "Doctor type/specialization")
        jsonObject.setValue(reason, forKey: "Diagnosis/Reason for visit?")
        jsonObject.setValue(treat, forKey: "What treatment was given?")
        
        let jsonData: NSData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
            //print("json string = \(jsonString)")
            
            var jj = ""
            
            if (prefs.string(forKey: "Doctors") != nil){
                let j = prefs.string(forKey: "Doctors")?.replacingOccurrences(of: "[", with: "")
                let k = j?.replacingOccurrences(of: "]", with: "")
                
                jj = "[" + k!  + "," + jsonString + "]"
                
            }else{
                jj = "[" + jsonString + "]"
            }
            
            print(jj)
            
            let prefs = UserDefaults.standard
            prefs.set(jj, forKey: "Doctors")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
            
            self.dismissView();
            
            
            
            
        } catch _ {
            print ("JSON Failure")
        }
        
        
        
        
        self.dismissView();
        
        
    }
    
    public func loadJSON() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Doctors") != nil){
            
            return JSON.parse(prefs.string(forKey: "Doctors")!)
        }else{
            return nil
        }
        
    }
    
    public func saveJSON(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "Doctors")
        
        // here I save my JSON as a string
    }
    
    
    
    private func delete() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSON()
        
        if (prefs.string(forKey: "Doctors") != nil){
            
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
        
        if (prefs.string(forKey: "Doctors") != nil){
            
            json[posIndex!]["Date visited"].stringValue = bpDate.text!
            json[posIndex!]["Diagnosis/Reason for visit?"].stringValue = ReasonText.text!
            json[posIndex!]["What treatment was given?"].stringValue = TreatText.text!
            json[posIndex!]["Name of doctor"].stringValue = docName.text!
            json[posIndex!]["Contact number"].stringValue = docNum.text!
            json[posIndex!]["Doctor type/specialization"].stringValue = docSpecial.text!
            json[posIndex!]["_hide"].boolValue = hideBool
            json[posIndex!]["_save"].boolValue = true
            
            
            
            self.saveJSON(j: json)
            
            print(json)
            
        }
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
        self.dismissView();
        
        
    }
    
    
    
    func loadDataDelete(){
        
        let json = self.loadJSON()
        
        //print(json)
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        
        print(json[posIndex!]["value"].stringValue)
        
        let recordId = json[posIndex!]["recordId"].stringValue
        let Notes = json[posIndex!]["Notes"].stringValue
        let updatedDate = json[posIndex!]["lastUpdated"].stringValue
        
        
        let Date = json[posIndex!]["Date"].stringValue
        
        if (json[posIndex!]["_hide"].stringValue == "true"){
            
            hideImage = true
            
        }else{
            hideImage = false
            
        }
        editTreat = Notes
        recordValue = recordId
        editDate = Date
        lastdate = updatedDate
        deletedList.append(json[posIndex!]["recordId"].stringValue)
        
        
        
        
        
        
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


extension DoctorSubRecord: TextFieldDelegate {
    
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
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        let prefs = UserDefaults.standard
        
        prefs.set(docName.text, forKey: "globalDoctor")
    }
    
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        
        if(bpDate.isEditing){
            return false
        }else if(docNum.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
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
