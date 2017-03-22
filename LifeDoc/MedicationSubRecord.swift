//
//  MedicationSubRecord.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/02/08.
//  Copyright © 2017 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire
import Toast_Swift
import DropDown


class MedicationSubRecord: UIViewController, WWCalendarTimeSelectorProtocol,UITextViewDelegate{
    
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
    
    
    @IBOutlet weak var checkBox: ISRadioButton!
    @IBOutlet weak var checkBox1: ISRadioButton!
    
    @IBOutlet weak var ReasonText: UITextView!
    
    @IBOutlet weak var mediName: ErrorTextField!
    @IBOutlet weak var strength: ErrorTextField!
    @IBOutlet weak var dosage: ErrorTextField!
    @IBOutlet weak var freq: ErrorTextField!
    @IBOutlet weak var preDoctor: ErrorTextField!
    @IBOutlet weak var repeats: ErrorTextField!
    
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var hideButton: UIButton!
    
    @IBOutlet weak var errorReason: UILabel!
    @IBOutlet weak var errorNote: UILabel!
    
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
    var NewCheck1 : Bool = Bool()
    
    var deleteRecord : Bool = Bool()
    var endDate : Bool = Bool()
    
    var fromDoc : Bool = Bool()
    var isRepeat : Bool = Bool()
    
    var hideBool : Bool = Bool()
    var fields : Array<String> = Array()
    
    var somethingChanged : Bool = Bool()
    
    var add : Array<String> = Array()
    
    var hideImage : Bool = Bool()
    
    var subRecords : Array<String> = Array()
    
    var deletedList : Array<String> = Array()
    
    var editDateTime = ""
    
    var editDatestart = ""
    var editDateend = ""
    var editReason = ""
    var editNote = ""
    var editmediName = ""
    
    var editstrength = ""
    var editdosage = ""
    var editfreq = ""
    var editpreDoc = ""
    var editrepeats = ""
    
    var recordValue = ""
    
    var editFromDoc = ""
    var editisRepeat = ""
    
    var lastdate = ""
    
    var dropDownOption = ""
    
    var countAttachments = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MedicationSubRecord.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Edit Medication"
        
        deleteRecord = false
        NewDate = false
        hideBool = false
        somethingChanged = false
        
        endDate = false
        
        NewCheck = true
        NewCheck1 = true
        
        fromDoc = false
        isRepeat = false
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "MediEdit") != nil){
            loadDataSingle()
            
        }
        
        errorNote.isHidden = true
        errorReason.isHidden = true
        clearButton.isHidden = true
        clearButton1.isHidden = true
        
        
        prepareCloseButton()
        prepareCalendarButton()
        prepareCalendarButton1()
        prepareSaveButton()
        prepareHideButton()
        prepareDeleteButton()
        prepareNote()
        prepareDate()
        prepareDateView()
        prepareDateView1()
        prepareClearButton()
        prepareClearButton1()
        
        prepareDate1()
        prepareReason()
        
        prepareMediName()
        prepareStrength()
        prepareDosage()
        prepareFreq()
        preparePreDoc()
        prepareRepeat()
        prepareRadio1()
        prepareRadio()
        
        
        
    }
    
    
    
    
    public func loadJSONSingle() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "MediEdit") != nil){
            
            return JSON.parse(prefs.string(forKey: "MediEdit")!)
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
        let mediname = json[posIndex!]["Medicine name"].stringValue
        let dosage = json[posIndex!]["Dosage"].stringValue
        let strength = json[posIndex!]["Strength"].stringValue
        let freq = json[posIndex!]["Frequency"].stringValue
        
        let preDoc = json[posIndex!]["Prescribed by"].stringValue
        let repeats = json[posIndex!]["Number of repeat fills?"].stringValue
        
        let reason = json[posIndex!]["Diagnosis/Reason for visit?"].stringValue
        let desc = json[posIndex!]["Medicine notes"].stringValue
        let updatedDate = json[posIndex!]["lastUpdated"].stringValue
        let startDate = json[posIndex!]["Start date"].stringValue
        let endDate = json[posIndex!]["End date"].stringValue
        
        let fromDoctor = json[posIndex!]["Was this medicine prescribed by a doctor?"].stringValue
        let isRepeat = json[posIndex!]["Is this a repeat prescription?"].stringValue
        
        
        
        
        if (json[posIndex!]["_hide"].stringValue == "true"){
            
            hideImage = true
            
        }else{
            hideImage = false
            
        }
        editReason = reason
        editNote = desc
        
        editmediName = mediname
        
        editstrength = strength
        editdosage = dosage
        editfreq = freq
        editpreDoc = preDoc
        editrepeats = repeats
        
        editFromDoc = fromDoctor
        editisRepeat = isRepeat
        
        recordValue = recordId
        
        editDatestart = startDate
        editDateend = endDate
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
        scrollView.contentSize = CGSize(width: 300, height: 1400)
    }
    
    
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(MedicationSubRecord.buttonTapActionClose)
        
        
    }
    
    func showDatePicker() {
        
        NewDate = true
        
        showCal()
    }
    
    private func prepareRadio() {
        
        let radio:ISRadioButton = checkBox
        
        
        if(editFromDoc == "No" || editFromDoc == "false"){
            checkBox.isSelected = false
            preDoctor.isEnabled = false
            fromDoc = false
        }else if(editFromDoc == "Yes" || editFromDoc == "true"){
            checkBox.isSelected = true
            checkBox1.isEnabled = true
            preDoctor.isEnabled = true
            fromDoc = true
            NewCheck = false
        }else{
            checkBox.isSelected = false
            fromDoc = false
            preDoctor.isEnabled = false
        }
        
        
        
        radio.addTarget(self, action: #selector(logSelectedButton), for:.touchUpInside)
        
        
    }
    
    
    func logSelectedButton(sender: ISRadioButton){
        
        editFromDoc = ""
        editisRepeat = ""
        
        if checkBox.isEqual(self.checkBox) {
            
            print("enabled")
            
            if(NewCheck == false){
                print("disabled")
                preDoctor.isEnabled = false
                preDoctor.text = ""
                NewCheck = true
                fromDoc = false
                isRepeat = false
                checkBox1.isEnabled = false
                repeats.isEnabled = false
                repeats.text = ""
                NewCheck1 = true
            }else{
                print("false")
                NewCheck = false
                preDoctor.isEnabled = true
                fromDoc = true
                checkBox1.isEnabled = true
                checkBox1.isSelected = false
                //repeats.isEnabled = false
                let prefs = UserDefaults.standard
                if (prefs.string(forKey: "globalDoctor") != nil && NewCheck == false){
                    preDoctor.text = prefs.string(forKey: "globalDoctor")!
                    
                }
            }
            
            
        }
        
    }
    
    
    private func prepareRadio1() {
        
        let radio:ISRadioButton = checkBox1
        
        
        if(editisRepeat == "No" || editisRepeat == "false"){
            checkBox1.isEnabled = false
            checkBox1.isSelected = false
            repeats.isEnabled = false
            isRepeat = false
        }else if(editisRepeat == "Yes" || editisRepeat == "true"){
            checkBox1.isEnabled = true
            checkBox1.isSelected = true
            repeats.isEnabled = true
            isRepeat = true
            NewCheck1 = false
            
        }else{
            checkBox1.isEnabled = false
            checkBox1.isSelected = false
            isRepeat = false
            repeats.isEnabled = false
        }
        
        
        
        radio.addTarget(self, action: #selector(logSelectedButton1), for:.touchUpInside)
        
        
    }
    
    
    
    func logSelectedButton1(sender: ISRadioButton){
        
        editisRepeat = ""
        editFromDoc = ""
        
        if(checkBox.isSelected == true){
            
            
            
            if checkBox1.isEqual(self.checkBox1) {
                
                
                
                if(NewCheck1 == false){
                    print("disabled")
                    repeats.isEnabled = false
                    repeats.text = ""
                    NewCheck1 = true
                    isRepeat = false
                }else{
                    print("false")
                    NewCheck1 = false
                    repeats.isEnabled = true
                    isRepeat = true
                }
                
                
            }
        }
        
        
    }
    
    
    private func prepareDateView() {
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MedicationSubRecord.showDatePicker))
        dateView.addGestureRecognizer(tapDateView)
        
        endDate = false
    }
    
    private func prepareDateView1() {
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MedicationSubRecord.showDatePicker))
        dateView1.addGestureRecognizer(tapDateView)
        
        endDate = true
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
        endDate = false
        showCal()
    }
    func buttonCalendarAction1(sender: UIButton!) {
        print("Button tapped")
        NewDate = true
        endDate = true
        
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
        
        bpDate.placeholder = "Start date"
        bpDate.resignFirstResponder()
        bpDate.detailLabel.numberOfLines = 0
        bpDate.delegate = self
        bpDate.addTarget(self, action: #selector(myTargetFunctionDate), for: UIControlEvents.touchDown)
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "MediEdit") != nil){
            bpDate.text = editDatestart
        }else{
            bpDate.text = dateToday.stringFromFormat("dd-MM-yyyy")
        }
        
        
    }
    
    
    
    func myTargetFunctionDate(textField: UITextField) {
        NewDate = true
        showCal()
    }
    
    
    private func prepareDate1() {
        
        bpDate1.placeholder = "End Date"
        bpDate1.resignFirstResponder()
        bpDate1.detailLabel.numberOfLines = 0
        bpDate1.delegate = self
        bpDate1.addTarget(self, action: #selector(myTargetFunctionDate1), for: UIControlEvents.touchDown)
        bpDate1.addTarget(self,action: #selector(textFieldDidChangedate),for: UIControlEvents.editingDidEnd)
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "MediEdit") != nil){
            bpDate1.text = editDateend
        }else{
            bpDate1.text = ""
        }
        
        
    }
    
    func textFieldDidChangedate(textField: UITextField) {
        
        let Str: String = bpDate1.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                bpDate1.isErrorRevealed = true
                bpDate1.detail = Constants.err_msg_date_medi_end
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
    
    
    
    
    private func prepareMediName() {
        
        
        mediName.placeholder = "Medicine Name"
        mediName.detail = Constants.err_msg_name_medi
        mediName.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "MediEdit") != nil){
            mediName.text = editmediName
            
        }else{
            mediName.text = ""
        }
        
        
        
        
        mediName.detailLabel.numberOfLines = 0
        
        mediName.delegate = self
        
        mediName.addTarget(self,action: #selector(textFieldDidChange),for: UIControlEvents.editingDidEnd)
        mediName.addTarget(self,action: #selector(textFieldDidChangeLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        let Str: String = mediName.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                mediName.isErrorRevealed = true
                mediName.detail = Constants.err_msg_name_medi
            } else{
                mediName.isErrorRevealed = false
                
            }
        }else{
            mediName.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLength(textField: UITextField) {
        
        
        checkMaxLength(textField: mediName,maxLength: 50)
        
    }
    
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (mediName.text!.characters.count > maxLength) {
            mediName.deleteBackward()
        }
    }
    
    private func preparePreDoc() {
        
        preDoctor.placeholder = "Doctor Name"
        preDoctor.detail = Constants.err_msg_name_medi_doc
        preDoctor.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "globalDoctor") != nil && NewCheck == false){
            preDoctor.text = prefs.string(forKey: "globalDoctor")!
            
        }else{
            preDoctor.text = ""
        }
        if (prefs.string(forKey: "MediEdit") != nil){
            preDoctor.text = editpreDoc
            
        }
        
        
        preDoctor.detailLabel.numberOfLines = 0
        
        preDoctor.delegate = self
        
        preDoctor.addTarget(self,action: #selector(textFieldDidChangepre),for: UIControlEvents.editingDidEnd)
        preDoctor.addTarget(self,action: #selector(textFieldDidChangeLengthpre),for: UIControlEvents.editingChanged)
        
    }
    
    
    func textFieldDidChangepre(textField: UITextField) {
        
        let Str: String = preDoctor.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                preDoctor.isErrorRevealed = true
                preDoctor.detail = Constants.err_msg_name_medi_doc
                self.preDoctor.becomeFirstResponder()
            } else{
                preDoctor.isErrorRevealed = false
                
            }
        }else{
            preDoctor.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLengthpre(textField: UITextField) {
        
        
        checkMaxLengthpre(textField: preDoctor,maxLength: 80)
        
    }
    
    
    func checkMaxLengthpre(textField: UITextField!, maxLength: Int) {
        if (preDoctor.text!.characters.count > maxLength) {
            preDoctor.deleteBackward()
        }
    }
    
    
    
    private func prepareRepeat() {
        
        repeats.placeholder = "Number of repeats"
        repeats.detail = Constants.err_msg_medi_repeat
        repeats.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "MediEdit") != nil){
            repeats.text = editrepeats
            
        }else{
            repeats.text = ""
        }
        
        
        
        repeats.detailLabel.numberOfLines = 0
        
        repeats.delegate = self
        
        repeats.addTarget(self,action: #selector(textFieldDidChangerep),for: UIControlEvents.editingDidEnd)
        repeats.addTarget(self,action: #selector(textFieldDidChangeLengthrep),for: UIControlEvents.editingChanged)
        
    }
    
    
    func textFieldDidChangerep(textField: UITextField) {
        
        let Str: String = repeats.text!
        
        let value = Int((repeats.text?.trimmed)!)
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                repeats.isErrorRevealed = true
                repeats.detail = Constants.err_msg_medi_repeat
                self.repeats.becomeFirstResponder()
            } else{
                repeats.isErrorRevealed = false
                
            }
            
            if(!(value! >= 1  && value! <= 12)){
                repeats.isErrorRevealed = true
                repeats.detail = Constants.err_msg_medi_repeat_error
                self.repeats.becomeFirstResponder()
                
                
            } else{
                repeats.isErrorRevealed = false
                
            }
            
        }else{
            repeats.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLengthrep(textField: UITextField) {
        
        
        checkMaxLengthrep(textField: repeats,maxLength: 2)
        
    }
    
    
    func checkMaxLengthrep(textField: UITextField!, maxLength: Int) {
        if (repeats.text!.characters.count > maxLength) {
            repeats.deleteBackward()
        }
    }
    
    
    
    private func prepareStrength() {
        
        strength.placeholder = "Strength"
        
        strength.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        
        
        
        if (prefs.string(forKey: "MediEdit") != nil){
            strength.text = editstrength
            
        } else{
            strength.text = ""
        }
        
        
        strength.detailLabel.numberOfLines = 0
        
        strength.delegate = self
        
        
        strength.addTarget(self,action: #selector(textFieldDidChangeLengthNum),for: UIControlEvents.editingChanged)
        
    }
    
    
    func textFieldDidChangeLengthNum(textField: UITextField) {
        
        
        checkMaxLengthNum(textField: strength,maxLength: 20)
        
    }
    
    
    func checkMaxLengthNum(textField: UITextField!, maxLength: Int) {
        if (strength.text!.characters.count > maxLength) {
            strength.deleteBackward()
        }
    }
    
    
    private func prepareDosage() {
        
        dosage.placeholder = "Dosage"
        
        dosage.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        
        
        
        if (prefs.string(forKey: "MediEdit") != nil){
            dosage.text = editdosage
            
        } else{
            dosage.text = ""
        }
        
        
        dosage.detailLabel.numberOfLines = 0
        
        dosage.delegate = self
        
        
        dosage.addTarget(self,action: #selector(textFieldDidChangeLengthdos),for: UIControlEvents.editingChanged)
        
    }
    
    
    func textFieldDidChangeLengthdos(textField: UITextField) {
        
        
        checkMaxLengthdos(textField: dosage,maxLength: 20)
        
    }
    
    
    func checkMaxLengthdos(textField: UITextField!, maxLength: Int) {
        if (dosage.text!.characters.count > maxLength) {
            dosage.deleteBackward()
        }
    }
    
    private func prepareFreq() {
        
        freq.placeholder = "Frequency"
        
        freq.isClearIconButtonEnabled = true
        
        let prefs = UserDefaults.standard
        
        
        
        if (prefs.string(forKey: "MediEdit") != nil){
            freq.text = editfreq
            
        } else{
            freq.text = ""
        }
        
        
        freq.detailLabel.numberOfLines = 0
        
        freq.delegate = self
        
        
        freq.addTarget(self,action: #selector(textFieldDidChangeLengthfreq),for: UIControlEvents.editingChanged)
        
    }
    
    
    func textFieldDidChangeLengthfreq(textField: UITextField) {
        
        
        checkMaxLengthfreq(textField: freq,maxLength: 20)
        
    }
    
    
    func checkMaxLengthfreq(textField: UITextField!, maxLength: Int) {
        if (freq.text!.characters.count > maxLength) {
            freq.deleteBackward()
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
        if(notesText.isFirstResponder == true){
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
    
    private func prepareNote() {
        
        
        notesText.delegate = self
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "MediEdit") != nil){
            notesText.text = editNote
            wordCount1.text = String(describing: (1000 - editNote.characters.count))
        }else{
            notesText.text = ""
        }
        
        
        
    }
    
    private func prepareReason() {
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "globalReason") != nil){
            
            ReasonText.text = prefs.string(forKey: "globalReason")!
            wordCount.text = String(describing: (1000 - prefs.string(forKey: "globalReason")!.characters.count))
        }
        
        ReasonText.delegate = self
        
        if (prefs.string(forKey: "MediEdit") != nil){
            ReasonText.text = editReason
            wordCount.text = String(describing: (1000 - editReason.characters.count))
        }
        
        
        
    }
    
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        
        if(ReasonText.isFirstResponder == true){
            clearButton.isHidden = false
        }
        if(notesText.isFirstResponder == true){
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
        notesText.text = ""
        wordCount1.text = "1000"
        
    }
    
    
    
    private func prepareSaveButton() {
        
        let rightNavItem = saveButton
        rightNavItem?.action = #selector(MedicationSubRecord.buttonTapAction)
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "MediEdit") != nil){
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
        if (prefs.string(forKey: "MediEdit") != nil) {
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
        
        
        deleteButton.addTarget(self, action: #selector(buttonDeleteAction), for: .touchUpInside)
        
    }
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        let value = Int((repeats.text?.trimmed)!)
        
        if(mediName.text?.trimmed.isEmpty)!{
            mediName.isErrorRevealed = true
            mediName.detail = Constants.err_msg_name_medi
            self.mediName.becomeFirstResponder()
            
            return
        }
        if(NewCheck == false){
            if(preDoctor.text?.trimmed.isEmpty)!{
                preDoctor.isErrorRevealed = true
                preDoctor.detail = Constants.err_msg_name_medi_doc
                self.preDoctor.becomeFirstResponder()
                
                return
            }
        }
        
        if(NewCheck1 == false){
            if(repeats.text?.trimmed.isEmpty)!{
                repeats.isErrorRevealed = true
                repeats.detail = Constants.err_msg_medi_repeat
                self.repeats.becomeFirstResponder()
                
                return
            }
            if(!(value! >= 1  && value! <= 12)){
                repeats.isErrorRevealed = true
                repeats.detail = Constants.err_msg_medi_repeat_error
                self.repeats.becomeFirstResponder()
                
                return
            }
        }
        
        
        
        if(!(bpDate1.text?.isEmpty)!){
            let myDateString = bpDate.text!
            let myDateString1 = bpDate1.text!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let myDate = dateFormatter.date(from: myDateString)!
            let myDate1 = dateFormatter.date(from: myDateString1)!
            
            
            
            if(myDate1 < myDate){
                self.bpDate1.isErrorRevealed = true
                self.bpDate1.detail = Constants.err_msg_date_medi
                
                
                return
            }
        }
        
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "MediEdit") != nil) {
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
        //let dateToday = Date()
        
        if(NewDate == true){
            
            if(endDate == false){
                
                //self.view.makeToast("You cannot select a future date, please select a current or past date.", duration: 3.0, position: .center)
                
                
                
                bpDate.text = date.stringFromFormat("dd-MM-yyyy")
                
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
        
        let note: String = notesText.text!
        
        let mediName: String = self.mediName.text!
        let strength: String = self.strength.text!
        let dosage: String = self.dosage.text!
        let freq: String = self.freq.text!
        let preDoc: String = self.preDoctor.text!
        let repeats: String = self.repeats.text!
        
        
        
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "MediEdit") != nil){
            jsonObject.setValue(lastdate, forKey: "lastUpdated")
            jsonObject.setValue(recordValue, forKey: "recordId")
        }else{
            jsonObject.setValue("", forKey: "lastUpdated")
            jsonObject.setValue("", forKey: "recordId")
        }
        
        
        jsonObject.setValue("MedicineSubrecord", forKey: "_type")
        jsonObject.setValue(true, forKey: "_save")
        jsonObject.setValue(false, forKey: "_delete")
        jsonObject.setValue(strDate, forKey: "Start date")
        jsonObject.setValue(strDate1, forKey: "End date")
        jsonObject.setValue(hideBool, forKey: "_hide")
        jsonObject.setValue(mediName, forKey: "Medicine name")
        jsonObject.setValue(strength, forKey: "Strength")
        jsonObject.setValue(dosage, forKey: "Dosage")
        jsonObject.setValue(freq, forKey: "Frequency")
        jsonObject.setValue(preDoc, forKey: "Prescribed by")
        jsonObject.setValue(repeats, forKey: "Number of repeat fills?")
        
        jsonObject.setValue(reason, forKey: "Diagnosis/Reason for visit?")
        jsonObject.setValue(note, forKey: "Medicine notes")
        
        jsonObject.setValue(fromDoc, forKey: "Was this medicine prescribed by a doctor?")
        jsonObject.setValue(isRepeat, forKey: "Is this a repeat prescription?")
        
        
        let jsonData: NSData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
            //print("json string = \(jsonString)")
            
            var jj = ""
            
            if (prefs.string(forKey: "Medication") != nil){
                let j = prefs.string(forKey: "Medication")?.replacingOccurrences(of: "[", with: "")
                let k = j?.replacingOccurrences(of: "]", with: "")
                
                jj = "[" + k!  + "," + jsonString + "]"
                
            }else{
                jj = "[" + jsonString + "]"
            }
            
            print(jj)
            
            let prefs = UserDefaults.standard
            prefs.set(jj, forKey: "Medication")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
            
            self.dismissView();
            
            
            
            
        } catch _ {
            print ("JSON Failure")
        }
        
        
        
        
        self.dismissView();
        
        
    }
    
    public func loadJSON() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Medication") != nil){
            
            return JSON.parse(prefs.string(forKey: "Medication")!)
        }else{
            return nil
        }
        
    }
    
    public func saveJSON(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "Medication")
        
        // here I save my JSON as a string
    }
    
    
    
    private func delete() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSON()
        
        if (prefs.string(forKey: "Medication") != nil){
            
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
        
        
        if (prefs.string(forKey: "Medication") != nil){
            
            json[posIndex!]["Start date"].stringValue = bpDate.text!
            json[posIndex!]["End date"].stringValue = bpDate1.text!
            json[posIndex!]["Diagnosis/Reason for visit?"].stringValue = ReasonText.text!
            json[posIndex!]["Medicine notes"].stringValue = notesText.text!
            json[posIndex!]["Medicine name"].stringValue = mediName.text!
            json[posIndex!]["Strength"].stringValue = strength.text!
            json[posIndex!]["Dosage"].stringValue = dosage.text!
            json[posIndex!]["Frequency"].stringValue = freq.text!
            json[posIndex!]["Prescribed by"].stringValue = preDoctor.text!
            json[posIndex!]["Number of repeat fills?"].stringValue = repeats.text!
            json[posIndex!]["_hide"].boolValue = hideBool
            json[posIndex!]["_save"].boolValue = true
            json[posIndex!]["Was this medicine prescribed by a doctor?"].boolValue = fromDoc
            json[posIndex!]["Is this a repeat prescription?"].boolValue = isRepeat
            
            
            
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


extension MedicationSubRecord: TextFieldDelegate {
    
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

