//
//  ProfileController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/02/22.
//  Copyright © 2017 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire
import Toast_Swift
import DropDown


class ProfileController: UIViewController, WWCalendarTimeSelectorProtocol,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let upright = image.fixOrientation()
            
            let jpegCompressionQuality: CGFloat = 0.7 // Set this to whatever suits your purpose
            let base64String = UIImageJPEGRepresentation(upright, jpegCompressionQuality)?.base64EncodedString()
            
            
            let prefs = UserDefaults.standard
            prefs.set(base64String, forKey: "attachBase64Profile")
            
            self.dismiss(animated: true, completion: nil)
            
            UploadProfilePic()
            
            
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bpDate: ErrorTextField!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var titlenow: ErrorTextField!
    
    @IBOutlet weak var initials: ErrorTextField!
    @IBOutlet weak var firstName: ErrorTextField!
    @IBOutlet weak var lastName: ErrorTextField!
    @IBOutlet weak var maiden: ErrorTextField!
    @IBOutlet weak var idNum: ErrorTextField!
    @IBOutlet weak var passportNum: ErrorTextField!
    
    @IBOutlet weak var gender: NiceButton!
    
    @IBOutlet weak var nationality: NiceButton!
    
    @IBOutlet weak var marital: NiceButton!
    @IBOutlet weak var ethnicity: NiceButton!
    
    @IBOutlet weak var donorNum: ErrorTextField!
    @IBOutlet weak var bloodNum: ErrorTextField!
    
    @IBOutlet weak var bloodType: NiceButton!
    
    @IBOutlet weak var bpCalendar: UIButton!
    fileprivate var singleDate: Date = Date()
    
    fileprivate var multipleDates: [Date] = []
    
    var messageStr : String = String()
    
    
    
    var NewDate : Bool = Bool()
    
    
    var validateID : Bool = Bool()
    
    
    
    let chooseDropDown = DropDown()
    let chooseDropDownNationality = DropDown()
    let chooseDropDownEthnicity = DropDown()
    let chooseDropDownMarital = DropDown()
    let chooseDropDownBloodType = DropDown()
    
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
    
    var valueGender = "Please select"
    var valueNationality = "South African"
    var valueEthnicity = "Please select"
    var valueMarital = "Please select"
    var valueBloodType = "Please select"
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadProfilePic), name: NSNotification.Name(rawValue: "loadProfilePic"), object: nil)
        
        self.navItem.title = "Personal Details"
        
        
        imagePicker.delegate = self
        
        NewDate = false
        validateID = false
        
        
        prepareCloseButton()
        prepareCalendarButton()
        prepareSaveButton()
        
        prepareDate()
        prepareDateView()
        
        prepareTitle()
        prepareFirstName()
        prepareMaiden()
        prepareInitials()
        prepareLastName()
        preparedropdownGender()
        prepareId()
        preparePassport()
        preparedropdownNationality()
        preparedropdownEthnicity()
        preparedropdownMarital()
        preparedropdownBloodType()
        prepareOrgan()
        prepareBlood()
        
        prepareProfilePic()
        
        getDetails()
        
        
        
    }
    
    
    func loadProfilePic(notification: NSNotification){
        //load data here
        
        let prefs = UserDefaults.standard
        
        let image = prefs.string(forKey: "attachBase64Profile")
        
        let dataDecoded : Data = Data(base64Encoded: image!, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        let size = CGSize(width:100, height:100)
        let resizeImg = resizeImage(image: decodedimage!, newSize: size)
        
        self.profilePic.image = resizeImg.fixOrientation()
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
        scrollView.contentSize = CGSize(width: 300, height: 1450)
    }
    
    
    func resizeImage(image: UIImage, newSize: CGSize) -> (UIImage) {
        
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality.default
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        
        context!.concatenate(flipVertical)
        // Draw into the context; this scales the image
        context?.draw(image.cgImage!, in: CGRect(x: 0.0,y: 0.0, width: newRect.width, height: newRect.height))
        
        let newImageRef = context!.makeImage()! as CGImage
        let newImage = UIImage(cgImage: newImageRef)
        
        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(MainChronic.buttonTapActionClose)
        
        
    }
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func showDatePicker() {
        
        NewDate = true
        
        showCal()
    }
    
    
    
    private func prepareDateView() {
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DoctorSubRecord.showDatePicker))
        dateView.addGestureRecognizer(tapDateView)
    }
    
    private func prepareProfilePic() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer)
        
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
        profilePic.clipsToBounds = true
        
        
    }
    
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let optionMenuPhoto = UIAlertController(title: nil, message: "Add Photo", preferredStyle: .actionSheet)
        
        // 2
        let photoAction = UIAlertAction(title: "Take a photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                self.imagePicker.allowsEditing = false
                self.imagePicker.navigationBar.barTintColor = UIColor(red: 0/255, green: 153/255, blue: 217/255, alpha: 1.0)
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        })
        
        // 2
        let galleryAction = UIAlertAction(title: "Select from gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                self.imagePicker.allowsEditing = true
                self.imagePicker.navigationBar.barTintColor = UIColor(red: 0/255, green: 153/255, blue: 217/255, alpha: 1.0)
                self.imagePicker.navigationBar.tintColor = .white
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }            })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        
        // 4
        optionMenuPhoto.addAction(photoAction)
        optionMenuPhoto.addAction(galleryAction)
        
        optionMenuPhoto.addAction(cancelAction)
        
        // 5
        //presentViewController(optionMenu, animated: true, completion: nil)
        self.present(optionMenuPhoto, animated: true, completion: nil)
        //self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    
    private func prepareCalendarButton() {
        bpCalendar.addTarget(self, action: #selector(buttonCalendarAction), for: .touchUpInside)
        
    }
    
    func buttonCalendarAction(sender: UIButton!) {
        print("Button tapped")
        NewDate = true
        
        showCal()
    }
    
    
    
    private func prepareDate() {
        
        bpDate.placeholder = "Date of birth"
        bpDate.resignFirstResponder()
        bpDate.detail = Constants.err_msg_profile_dob
        bpDate.detailLabel.numberOfLines = 0
        bpDate.delegate = self
        bpDate.addTarget(self, action: #selector(myTargetFunctionDate), for: UIControlEvents.touchDown)
        
        
        
        
    }
    
    
    
    func myTargetFunctionDate(textField: UITextField) {
        NewDate = true
        showCal()
    }
    
    
    
    
    
    private func prepareTitle() {
        
        titlenow.placeholder = "Title"
        //titlenow.detail = Constants.err_msg
        titlenow.isClearIconButtonEnabled = true
        
        
        titlenow.detailLabel.numberOfLines = 0
        
        titlenow.delegate = self
        
        
        titlenow.addTarget(self,action: #selector(textFieldDidChangeLength1),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeLength1(textField: UITextField) {
        
        
        checkMaxLength1(textField: titlenow,maxLength: 5)
        
    }
    
    
    func checkMaxLength1(textField: UITextField!, maxLength: Int) {
        if (titlenow.text!.characters.count > maxLength) {
            titlenow.deleteBackward()
        }
    }
    
    private func prepareFirstName() {
        
        firstName.placeholder = "First Name"
        firstName.detail = Constants.err_msg_profile_first_name
        firstName.isClearIconButtonEnabled = true
        
        
        
        firstName.detailLabel.numberOfLines = 0
        
        firstName.delegate = self
        
        firstName.addTarget(self,action: #selector(textFieldDidChangefirst),for: UIControlEvents.editingDidEnd)
        firstName.addTarget(self,action: #selector(textFieldDidChangeLength2),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangefirst(textField: UITextField) {
        
        let Str: String = firstName.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                firstName.isErrorRevealed = true
                firstName.detail = Constants.err_msg_profile_first_name
            } else{
                firstName.isErrorRevealed = false
                
            }
        }else{
            firstName.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLength2(textField: UITextField) {
        
        
        checkMaxLength2(textField: firstName,maxLength: 50)
        
    }
    
    
    func checkMaxLength2(textField: UITextField!, maxLength: Int) {
        if (firstName.text!.characters.count > maxLength) {
            firstName.deleteBackward()
        }
    }
    
    
    
    private func prepareInitials() {
        
        initials.placeholder = "Initials"
        //titlenow.detail = Constants.err_msg
        initials.isClearIconButtonEnabled = true
        
        
        initials.detailLabel.numberOfLines = 0
        
        initials.delegate = self
        
        
        initials.addTarget(self,action: #selector(textFieldDidChangeLength3),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeLength3(textField: UITextField) {
        
        
        checkMaxLength3(textField: initials,maxLength: 10)
        
    }
    
    
    func checkMaxLength3(textField: UITextField!, maxLength: Int) {
        if (initials.text!.characters.count > maxLength) {
            initials.deleteBackward()
        }
    }
    
    
    private func prepareLastName() {
        
        lastName.placeholder = "Last Name"
        lastName.detail = Constants.err_msg_profile_last_name
        lastName.isClearIconButtonEnabled = true
        
        
        
        lastName.detailLabel.numberOfLines = 0
        
        lastName.delegate = self
        
        lastName.addTarget(self,action: #selector(textFieldDidChangelast),for: UIControlEvents.editingDidEnd)
        lastName.addTarget(self,action: #selector(textFieldDidChangeLength4),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangelast(textField: UITextField) {
        
        let Str: String = lastName.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                lastName.isErrorRevealed = true
                lastName.detail = Constants.err_msg_profile_last_name
            } else{
                lastName.isErrorRevealed = false
                
            }
        }else{
            lastName.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLength4(textField: UITextField) {
        
        
        checkMaxLength4(textField: firstName,maxLength: 50)
        
    }
    
    
    func checkMaxLength4(textField: UITextField!, maxLength: Int) {
        if (lastName.text!.characters.count > maxLength) {
            lastName.deleteBackward()
        }
    }
    
    
    private func prepareMaiden() {
        
        maiden.placeholder = "Maiden Name"
        //titlenow.detail = Constants.err_msg
        maiden.isClearIconButtonEnabled = true
        
        
        maiden.detailLabel.numberOfLines = 0
        
        maiden.delegate = self
        
        
        maiden.addTarget(self,action: #selector(textFieldDidChangeLength5),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeLength5(textField: UITextField) {
        
        
        checkMaxLength5(textField: maiden,maxLength: 50)
        
    }
    
    
    func checkMaxLength5(textField: UITextField!, maxLength: Int) {
        if (maiden.text!.characters.count > maxLength) {
            maiden.deleteBackward()
        }
    }
    
    
    
    private func preparedropdownGender() {
        
        chooseDropDown.anchorView = gender
        
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: gender.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDropDown.dataSource = ["Please select","Male", "Female"]
        
        
        // Action triggered on selection
        chooseDropDown.selectionAction = { [unowned self] (index, item) in
            
            
            
            self.gender.setTitle(item, for: .normal)
            self.valueGender = item
            
        }
        
        chooseDropDown.direction = .any
        
        
    }
    
    @IBAction func chooseGender(_ sender: AnyObject) {
        chooseDropDown.show()
    }
    
    
    private func prepareId() {
        
        idNum.placeholder = "ID Number"
        idNum.detail = Constants.err_msg_profile_id
        idNum.isClearIconButtonEnabled = true
        
        idNum.detailLabel.numberOfLines = 0
        
        idNum.delegate = self
        
        idNum.addTarget(self,action: #selector(textFieldDidChangeid),for: UIControlEvents.editingDidEnd)
        idNum.addTarget(self,action: #selector(textFieldDidChangeLength6),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeid(textField: UITextField) {
        
        let Str: String = idNum.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str.trimmed)){
                
                idNum.isErrorRevealed = true
                idNum.detail = Constants.err_msg_profile_id
            } else{
                idNum.isErrorRevealed = false
                
            }
            
            if(!validateValueID(testStr: Str.trimmed)){
                
                idNum.isErrorRevealed = true
                idNum.detail = Constants.err_msg_profile_id
            } else{
                idNum.isErrorRevealed = false
                
            }
        }else{
            idNum.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangeLength6(textField: UITextField) {
        
        
        checkMaxLength6(textField: idNum,maxLength: 13)
        
    }
    
    
    func checkMaxLength6(textField: UITextField!, maxLength: Int) {
        if (idNum.text!.characters.count > maxLength) {
            idNum.deleteBackward()
        }
    }
    
    
    
    private func preparePassport() {
        
        passportNum.placeholder = "Passport Number"
        //titlenow.detail = Constants.err_msg
        passportNum.isClearIconButtonEnabled = true
        
        
        passportNum.detailLabel.numberOfLines = 0
        
        passportNum.delegate = self
        
        
        passportNum.addTarget(self,action: #selector(textFieldDidChangeLength7),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeLength7(textField: UITextField) {
        
        
        checkMaxLength7(textField: passportNum,maxLength: 20)
        
    }
    
    
    func checkMaxLength7(textField: UITextField!, maxLength: Int) {
        if (passportNum.text!.characters.count > maxLength) {
            passportNum.deleteBackward()
        }
    }
    
    
    
    private func prepareSaveButton() {
        
        let rightNavItem = saveButton
        rightNavItem?.action = #selector(DoctorSubRecord.buttonTapAction)
        
        
    }
    
    
    private func preparedropdownNationality() {
        
        chooseDropDownNationality.anchorView = nationality
        
        chooseDropDownNationality.bottomOffset = CGPoint(x: 0, y: nationality.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDropDownNationality.dataSource = ["South African"]
        
        
        // Action triggered on selection
        chooseDropDownNationality.selectionAction = { [unowned self] (index, item) in
            
            
            
            self.nationality.setTitle(item, for: .normal)
            self.valueNationality = item
            
        }
        
        chooseDropDownNationality.direction = .any
        
        
    }
    
    @IBAction func chooseNationality(_ sender: AnyObject) {
        chooseDropDownNationality.show()
    }
    
    
    private func preparedropdownEthnicity() {
        
        chooseDropDownEthnicity.anchorView = ethnicity
        
        chooseDropDownEthnicity.bottomOffset = CGPoint(x: 0, y: ethnicity.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDropDownEthnicity.dataSource = ["Please select", "Asian", "Black African", "Black Caribbean", "Coloured", "Latino Hispanic", "Middle Eastern", "Mixed Race", "White Caucasian"]
        
        
        // Action triggered on selection
        chooseDropDownEthnicity.selectionAction = { [unowned self] (index, item) in
            
            
            
            self.ethnicity.setTitle(item, for: .normal)
            self.valueEthnicity = item
            
        }
        
        chooseDropDownEthnicity.direction = .any
        
        
    }
    
    @IBAction func chooseEthnicity(_ sender: AnyObject) {
        chooseDropDownEthnicity.show()
    }
    
    
    
    private func preparedropdownMarital() {
        
        chooseDropDownMarital.anchorView = marital
        
        chooseDropDownMarital.bottomOffset = CGPoint(x: 0, y: marital.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDropDownMarital.dataSource = ["Please select", "Married", "Single", "Divorced", "Widowed"]
        
        
        // Action triggered on selection
        chooseDropDownMarital.selectionAction = { [unowned self] (index, item) in
            
            
            
            self.marital.setTitle(item, for: .normal)
            self.valueMarital = item
            
        }
        
        chooseDropDownMarital.direction = .any
        
        
    }
    
    @IBAction func chooseMarital(_ sender: AnyObject) {
        chooseDropDownMarital.show()
    }
    
    private func preparedropdownBloodType() {
        
        chooseDropDownBloodType.anchorView = bloodType
        
        chooseDropDownBloodType.bottomOffset = CGPoint(x: 0, y: bloodType.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDropDownBloodType.dataSource = ["Please select", "A +", "A -", "AB +", "AB -", "B +", "B -", "O +", "O -"]
        
        
        // Action triggered on selection
        chooseDropDownBloodType.selectionAction = { [unowned self] (index, item) in
            
            
            
            self.bloodType.setTitle(item, for: .normal)
            self.valueBloodType = item
            
        }
        
        chooseDropDownBloodType.direction = .any
        
        
    }
    
    @IBAction func chooseBloodType(_ sender: AnyObject) {
        chooseDropDownBloodType.show()
    }
    
    
    
    private func prepareOrgan() {
        
        donorNum.placeholder = "Organ Donor Registration Number"
        //titlenow.detail = Constants.err_msg
        donorNum.isClearIconButtonEnabled = true
        
        
        donorNum.detailLabel.numberOfLines = 0
        
        donorNum.delegate = self
        
        
        donorNum.addTarget(self,action: #selector(textFieldDidChangeLength8),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeLength8(textField: UITextField) {
        
        
        checkMaxLength8(textField: donorNum,maxLength: 20)
        
    }
    
    
    func checkMaxLength8(textField: UITextField!, maxLength: Int) {
        if (donorNum.text!.characters.count > maxLength) {
            donorNum.deleteBackward()
        }
    }
    
    private func prepareBlood() {
        
        bloodNum.placeholder = "Blood Donor Number"
        //titlenow.detail = Constants.err_msg
        bloodNum.isClearIconButtonEnabled = true
        
        
        bloodNum.detailLabel.numberOfLines = 0
        
        bloodNum.delegate = self
        
        
        bloodNum.addTarget(self,action: #selector(textFieldDidChangeLength9),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangeLength9(textField: UITextField) {
        
        
        checkMaxLength9(textField: bloodNum,maxLength: 20)
        
    }
    
    
    func checkMaxLength9(textField: UITextField!, maxLength: Int) {
        if (bloodNum.text!.characters.count > maxLength) {
            bloodNum.deleteBackward()
        }
    }
    
    
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        
        if(firstName.text?.trimmed.isEmpty)!{
            firstName.isErrorRevealed = true
            firstName.detail = Constants.err_msg_profile_first_name
            self.firstName.becomeFirstResponder()
            
            return
        }
        
        
        if(lastName.text?.trimmed.isEmpty)!{
            lastName.isErrorRevealed = true
            lastName.detail = Constants.err_msg_profile_last_name
            self.lastName.becomeFirstResponder()
            
            return
        }
        
        if(bpDate.text?.trimmed.isEmpty)!{
            bpDate.isErrorRevealed = true
            bpDate.detail = Constants.err_msg_profile_dob
            
            
            return
        }
        
        if(validateID == true){
            if(idNum.text?.trimmed.isEmpty)!{
                idNum.isErrorRevealed = true
                idNum.detail = Constants.err_msg_profile_id
                self.idNum.becomeFirstResponder()
                
                return
            }
            
            if(!validateValueID(testStr: (idNum.text?.trimmed)!)){
                
                idNum.isErrorRevealed = true
                idNum.detail = Constants.err_msg_profile_id
                self.idNum.becomeFirstResponder()
                
                return
            }
            
            
        }
        
        
        if(valueGender == "Please select"){
            self.view.makeToast("Please select your gender.", duration: 3.0, position: .center)
            return
        }
        
        if(valueEthnicity == "Please select"){
            self.view.makeToast("Please select your ethnicity.", duration: 3.0, position: .center)
            return
        }
        
        if(valueMarital == "Please select"){
            self.view.makeToast("Please select your marital status.", duration: 3.0, position: .center)
            return
        }
        
        save()
        
        
        
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
    
    
    func validateValueID(testStr:String) -> Bool {
        
        //Now perform the checkdigit for Id No
        
        let lastDigit = String(testStr[testStr.index(before: testStr.endIndex)])
        
        
        
        var oddDigits = 0
        
        
        var lengName = testStr.substring(to: testStr.index(before: testStr.endIndex))
        
        let leng = lengName.characters.count
        
        for oddnumber in 0...leng where oddnumber % 2 == 1 {
            
            
            oddDigits = oddDigits + Int(String(lengName[oddnumber - 1]))!
        }
        
        //print(oddDigits)
        
        var strEvenDigits = ""
        for evennumber in 0...leng where evennumber % 2 == 0 {
            
            //print(evennumber)
            strEvenDigits += String(lengName[evennumber + 1])
        }
        
        //print(strEvenDigits)
        
        let evenmulti = Int(strEvenDigits)!*2
        
        // print(evenmulti)
        
        var evenDigits = 0
        
        let leng2 = String(evenmulti).characters.count
        
        let ss = String(evenmulti)
        
        //print(ss)
        
        
        for evennumbertotal in 0...leng2 - 1{
            
            //print(evennumbertotal)
            
            evenDigits = evenDigits + Int(ss[evennumbertotal])!
        }
        
        //print(evenDigits)
        
        let sumOfOddEven = oddDigits + evenDigits
        if (sumOfOddEven < 10){
            return false
        }
        
        //print(sumOfOddEven)
        
        let str = String(sumOfOddEven)
        
        let ww = String(str[str.index(before: str.endIndex)])
        
        //print(ww)
        
        var controlDigit = 10 - Int(ww)!
        
        //print(controlDigit)
        
        
        if (controlDigit > 9) {
            
            let i = Int(String(str[str.index(before: str.endIndex)]))!
            controlDigit = i
        }
        
        
        if (controlDigit != Int(lastDigit)){
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
        selector.optionCalendarFontColorFutureDates = UIColor.lightGray
        
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
                bpDate.isErrorRevealed = false
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
        
        
        let title: String = self.titlenow.text!
        let firstName: String = self.firstName.text!
        let lastName: String = self.lastName.text!
        let maidenName: String = self.maiden.text!
        let initial: String = self.initials.text!
        let organDonorRegistrationNumber: String = self.donorNum.text!
        let bloodDonorNumber: String = self.bloodNum.text!
        let idNum: String = self.idNum.text!
        let pass: String = self.passportNum.text!
        
        if (valueMarital == "Please select"){
            valueMarital = ""
        }
        if (valueNationality == "Please select") {
            valueNationality = ""
        }
        if (valueEthnicity == "Please select") {
            valueEthnicity = ""
        }
        if (valueBloodType == "Please select") {
            valueBloodType = ""
        }
        
        if (valueGender == "Please select") {
            valueGender = ""
        }
        
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        let urlString: String
        
        urlString = Constants.baseURL + "personalDetails"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "title": title,
            "initial": initial,
            "firstName": firstName,
            "lastName": lastName,
            "maidenName": maidenName,
            "gender": valueGender,
            "maritalStatus": valueMarital,
            "nationality": valueNationality,
            "passportNumber": pass,
            "idNumber": idNum,
            "dob": strDate,
            "ethnicity": valueEthnicity,
            "organDonorRegistrationNumber": organDonorRegistrationNumber,
            "bloodDonorNumber": bloodDonorNumber,
            "bloodType": valueBloodType,
            "authToken": authToken!
            
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        ProfileController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    appDelegate.showToast()
                    
                    //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTable"), object: nil)
                    
                    
                    
                    
                    //Toast(text: self.messageStr, duration: Delay.long).show()
                    
                    self.dismiss(animated: true, completion: nil)
                    
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
    
    
    
    
    private func getDetails() {
        
        
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        let urlString: String
        
        urlString = Constants.baseURL + "getPersonalDetails"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            
            
            ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        
        // Both calls are equivalent
        ProfileController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                let title = json["title"].string
                let firstName = json["firstName"].string
                let lastName = json["lastName"].string
                let maidenName = json["maidenName"].string
                let initial = json["initial"].string
                let organDonorRegistrationNumber = json["organDonorRegistrationNumber"].string
                let bloodDonorNumber = json["bloodDonorNumber"].string
                let idNumber = json["idNumber"].string
                let passportNumber = json["passportNumber"].string
                let dob = json["dob"].string
                
                let bloodType = json["bloodType"].string
                let ethnicity = json["ethnicity"].string
                let gender = json["gender"].string
                let maritalStatus = json["maritalStatus"].string
                let nationality = json["nationality"].string
                
                let profilePictureData = json["profilePictureData"].string
                
                if(profilePictureData != nil){
                    
                    let prefs = UserDefaults.standard
                    prefs.set(profilePictureData, forKey: "attachBase64Profile")
                    
                    let dataDecoded : Data = Data(base64Encoded: profilePictureData!, options: .ignoreUnknownCharacters)!
                    let decodedimage = UIImage(data: dataDecoded)
                    let size = CGSize(width:100, height:100)
                    let resizeImg = self.resizeImage(image: decodedimage!, newSize: size)
                    
                    self.profilePic.image = resizeImg.fixOrientation()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMyPic"), object: nil)
                    
                }
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    
                    self.titlenow.text = title
                    self.firstName.text = firstName
                    self.lastName.text = lastName
                    self.maiden.text = maidenName
                    self.initials.text = initial
                    self.donorNum.text = organDonorRegistrationNumber
                    self.bloodNum.text = bloodDonorNumber
                    self.idNum.text = idNumber
                    self.passportNum.text = passportNumber
                    self.bpDate.text = dob
                    
                    if(idNumber != ""){
                        self.validateID = true
                    }else{
                        self.validateID = false
                    }
                    
                    
                    self.valueMarital = maritalStatus!
                    self.marital.setTitle(maritalStatus!, for: .normal)
                    
                    
                    self.valueNationality = nationality!
                    self.nationality.setTitle(nationality!, for: .normal)
                    
                    
                    self.valueEthnicity = ethnicity!
                    self.ethnicity.setTitle(ethnicity!, for: .normal)
                    
                    
                    self.valueBloodType = bloodType!
                    self.bloodType.setTitle(bloodType!, for: .normal)
                    
                    self.valueGender = gender!
                    self.gender.setTitle(gender!, for: .normal)
                    
                    
                    
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
            
            
            
        })
        
        
        
        present(ac, animated: true)
        
    }
    
    
    
    private func UploadProfilePic() {
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        self.view.makeToast("Upload started...", duration: 1.0, position: .bottom)
        
        let urlString: String
        
        urlString = Constants.baseURL + "profilePicture"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        let base = prefs.string(forKey: "attachBase64Profile")!
        
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "name": "LifeDoc_profile.jpg",
            "data": base
            
            
        ]
        
        //print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        ProfileController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    
                    
                    
                    self.messageStr = "Profile picture uploaded successfully"
                    
                    
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProfilePic"), object: nil)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMyPic"), object: nil)
                    
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


extension ProfileController: TextFieldDelegate {
    
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
        
        
    }
    
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        
        if(bpDate.isEditing){
            return false
        }else if(titlenow.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(firstName.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(initials.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(lastName.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(maiden.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(idNum.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(passportNum.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(bloodNum.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
        }else if(donorNum.isEditing){
            let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").inverted
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
extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}

