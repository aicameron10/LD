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
import FileExplorer

class MainChronic: UIViewController, WWCalendarTimeSelectorProtocol, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FileExplorerViewControllerDelegate{
    
    
    public func fileExplorerViewControllerDidFinish(_ controller: FileExplorerViewController) {
        //
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            let jpegCompressionQuality: CGFloat = 0.75 // Set this to whatever suits your purpose
            let base64String = UIImageJPEGRepresentation(image, jpegCompressionQuality)?.base64EncodedString()
            print(base64String as Any)
            
            let prefs = UserDefaults.standard
            prefs.set(base64String, forKey: "attachBase64")
            
            let attach: AttachmentController = {
                return UIStoryboard.viewController(identifier: "AttachmentController") as! AttachmentController
            }()
            self.dismiss(animated: true, completion: nil)
            self.present(attach, animated: true, completion: nil)
            
            
        }
        
    }
    
    
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
    
    let imagePicker = UIImagePickerController()
    
    var NewDate : Bool = Bool()
    
    var deleteRecord : Bool = Bool()
    
    var hidelater = "null"
    
    var savedNotes: [[String: AnyObject]] = []
    
    var hideBool : Bool = Bool()
    var fields : Array<String> = Array()
    
    var somethingChanged : Bool = Bool()
    
    
    
    var hideImage : Bool = Bool()
    
    var countSkip : Bool = Bool()
    
    var deletedList : Array<String> = Array()
    
    var editDateTime = ""
    
    var editDate = ""
    
    var serverityValue = "Status of condition"
    var recordValue = ""
    
    var dropDownOption = ""
    
    var recordIdValue = ""
    
    var countAttachments = 0
    
    var counterNote = ""
    var counterMedi = ""
    var counterPath = ""
    var counterHos = ""
    var counterDoc = ""
    
    let chooseDropDown = DropDown()
    
    var indexOfExpandedCell = -1
    
    var ShowMoreLess = "closed"
    
    var shouldCellBeExpanded = false
    
    
    var countNotes = 0
    var countMedi = 0
    var countDoc = 0
    var countHos = 0
    var countPath = 0
    
    
    var options = ["Notes", "Doctor Visits", "Medication", "Hospital Visits", "Pathology Results", "Attachments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BloodPresssureContoller.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        //view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Edit Chronic Condition"
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadListAttach), name: NSNotification.Name(rawValue: "loadAttach"), object: nil)
        
        imagePicker.delegate = self
        
        deleteRecord = false
        NewDate = false
        hideBool = false
        somethingChanged = false
        
        countSkip = false
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergyChronic") != nil){
            loadDataSingle()
            listAttachments()
        }
        
        
        prepareCloseButton()
        prepareCalendarButton()
        prepareSaveButton()
        prepareHideButton()
        prepareDeleteButton()
        prepareDesc()
        prepareDate()
        prepareDateView()
        prepareAttachButton()
        preparedropdown()
        
        
        
    }
    
    func loadList(notification: NSNotification){
        //load data here
        print("reloading table on chronic")
        
        indexOfExpandedCell = -1
        
        ShowMoreLess = "closed"
        
        shouldCellBeExpanded = false
        
        
        loadDataNotes()
        loadDataPath()
        loadDataDoc()
        loadDataHos()
        loadDataMedi()
        
        self.tableView.reloadData()
        
    }
    
    
    func loadListAttach(notification: NSNotification){
        //load data here
        
        listAttachments()
        
        
    }
    
    
    
    public func loadJSONSingle() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "mainAllergyChronic") != nil){
            
            return JSON.parse(prefs.string(forKey: "mainAllergyChronic")!)
        }else{
            return nil
        }
        
    }
    
    
    public func loadJSONNotes() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Notes") != nil){
            
            return JSON.parse(prefs.string(forKey: "Notes")!)
        }else{
            return nil
        }
        
    }
    func loadDataNotes(){
        
        let json = self.loadJSONNotes()
        
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Notes") != nil){
            countNotes = 0
            
            for (_, object) in json {
                
                let del = object["_delete"].stringValue
                
                print("hello*****************************"+del)
                
                if(del == "false" || del == "" || del == " "){
                    countNotes += 1
                }
                
                if(countNotes == -1){
                    countNotes = 0
                }
                
                if(countNotes == 0){
                    countSkip = true
                }
                
            }
        }
        
        
    }
    
    
    public func loadJSONPath() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Pathology") != nil){
            
            return JSON.parse(prefs.string(forKey: "Pathology")!)
        }else{
            return nil
        }
        
    }
    func loadDataPath(){
        
        let json = self.loadJSONPath()
        
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Pathology") != nil){
            countPath = 0
            
            for (_, object) in json {
                
                print(object)
                
                let del = object["_delete"].stringValue
                
                print("del-"+del)
                
                
                if(del == "false" || del == "" || del == " "){
                    
                    print("count me in")
                    countPath += 1
                }
                
                if(countPath == -1){
                    countPath = 0
                }
                
                if(countPath == 0){
                    countSkip = true
                }
                
            }
        }
        
        
    }
    
    public func loadJSONDoc() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Doctors") != nil){
            
            return JSON.parse(prefs.string(forKey: "Doctors")!)
        }else{
            return nil
        }
        
    }
    func loadDataDoc(){
        
        let json = self.loadJSONDoc()
        
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Doctors") != nil){
            countDoc = 0
            
            for (_, object) in json {
                
                print(object)
                
                let del = object["_delete"].stringValue
                
                print("del-"+del)
                
                
                if(del == "false" || del == "" || del == " "){
                    
                    print("count me in")
                    countDoc += 1
                }
                
                if(countDoc == -1){
                    countDoc = 0
                }
                
                if(countDoc == 0){
                    countSkip = true
                }
                
            }
        }
        
        
    }
    
    public func loadJSONHos() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Hospitals") != nil){
            
            return JSON.parse(prefs.string(forKey: "Hospitals")!)
        }else{
            return nil
        }
        
    }
    func loadDataHos(){
        
        let json = self.loadJSONHos()
        
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Hospitals") != nil){
            countHos = 0
            
            for (_, object) in json {
                
                print(object)
                
                let del = object["_delete"].stringValue
                
                print("del-"+del)
                
                
                if(del == "false" || del == "" || del == " "){
                    
                    print("count me in")
                    countHos += 1
                }
                
                if(countHos == -1){
                    countHos = 0
                }
                
                if(countHos == 0){
                    countSkip = true
                }
                
            }
        }
        
        
    }
    
    public func loadJSONMedi() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Medication") != nil){
            
            return JSON.parse(prefs.string(forKey: "Medication")!)
        }else{
            return nil
        }
        
    }
    func loadDataMedi(){
        
        let json = self.loadJSONMedi()
        
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Medication") != nil){
            countMedi = 0
            
            for (_, object) in json {
                
                print(object)
                
                let del = object["_delete"].stringValue
                
                print("del-"+del)
                
                
                if(del == "false" || del == "" || del == " "){
                    
                    print("count me in")
                    countMedi += 1
                }
                
                if(countMedi == -1){
                    countMedi = 0
                }
                
                if(countMedi == 0){
                    countSkip = true
                }
                
            }
        }
        
        
    }
    
    
    func loadDataSingle(){
        
        let json = self.loadJSONSingle()
        
        print(json)
        
        
        for item in json["attributes"].arrayValue {
            print(item["value"].stringValue)
            let description = item["description"].stringValue
            
            let value = item["value"].stringValue
            
            if(description == "Condition"){
                condition.text = value
                
                
                let prefs = UserDefaults.standard
                
                prefs.set(value, forKey: "globalReason")
            }
            
            if(description == "Status of condition"){
                
                if(value == "Uncontrolled, even with medication"){
                    dropDownOption = "Uncontrolled, even with medication"
                }
                else if(value == "Under control, with medication"){
                    dropDownOption = "Controlled, with medication"
                }else if(value == "Under control, without  medication"){
                    dropDownOption = "Controlled, without medication"
                }else{
                    dropDownOption = value
                }
            }
            if(description == "Date first diagnosed"){
                editDate = value
            }
            
        }
        
        for item in json["subRecords"].arrayValue {
            //print(item["value"].stringValue)
            let description = item["description"].stringValue
            
            
            if(description == "Doctor Visit"){
                let details = item["details"].arrayValue
                counterDoc = item["count"].stringValue
                
                let json = JSON(details)
                
                self.saveJSONDocs(j: json)
            }
            
            if(description == "Hospital Visit"){
                let details = item["details"].arrayValue
                counterHos = item["count"].stringValue
                
                let json = JSON(details)
                
                self.saveJSONHos(j: json)
            }
            if(description == "Notes"){
                let details = item["details"].arrayValue
                counterNote = item["count"].stringValue
                
                print(counterNote)
                
                let json = JSON(details)
                
                self.saveJSONNotes(j: json)
                
                
            }
            if(description == "Pathology"){
                let details = item["details"].arrayValue
                counterPath = item["count"].stringValue
                
                let json = JSON(details)
                
                self.saveJSONPath(j: json)
            }
            if(description == "Medicine"){
                let details = item["details"].arrayValue
                counterMedi = item["count"].stringValue
                
                let json = JSON(details)
                
                self.saveJSONMedi(j: json)
            }
            
        }
        
        
        if (json["_hide"].stringValue == "true"){
            
            hideImage = true
            
        }else{
            hideImage = false
            
        }
        
        
        recordValue = json["recordId"].stringValue
        deletedList.append(json["recordId"].stringValue)
        
        self.tableView.reloadData()
        
    }
    
    public func saveJSONNotes(j: JSON) {
        let prefs = UserDefaults.standard
        
        prefs.set(j.rawString()!, forKey: "Notes")
        
        // here I save my JSON as a string
    }
    
    public func saveJSONMedi(j: JSON) {
        let prefs = UserDefaults.standard
        
        prefs.set(j.rawString()!, forKey: "Medication")
        
        // here I save my JSON as a string
    }
    
    public func saveJSONDocs(j: JSON) {
        let prefs = UserDefaults.standard
        
        prefs.set(j.rawString()!, forKey: "Doctors")
        
        // here I save my JSON as a string
    }
    
    public func saveJSONHos(j: JSON) {
        let prefs = UserDefaults.standard
        
        prefs.set(j.rawString()!, forKey: "Hospitals")
        
        // here I save my JSON as a string
    }
    
    public func saveJSONPath(j: JSON) {
        let prefs = UserDefaults.standard
        
        prefs.set(j.rawString()!, forKey: "Pathology")
        
        // here I save my JSON as a string
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
        
        cell.expandRow.text = "closed"
        
        if(cell.name.text == "Attachments"){
            cell.count.text = String(describing: countAttachments)
        }
        
        if(indexPath.row == 0 && cell.name.text == "Notes"){
            if(cell.name.text == "Notes" && counterNote != "" && countNotes == 0 && countSkip == false){
                
                print("i want this one now ")
                cell.count.text = counterNote
            }else{
                
                cell.count.text = String(describing: countNotes)
            }
        }
        if(indexPath.row == 1 && cell.name.text == "Doctor Visits"){
            if(cell.name.text == "Doctor Visits" && counterDoc != "" && countDoc == 0 && countSkip == false){
                cell.count.text = counterDoc
            }else{
                cell.count.text = String(describing: countDoc)
            }
        }
        if(indexPath.row == 2 && cell.name.text == "Medication"){
            if(cell.name.text == "Medication" && counterMedi != "" && countMedi == 0 && countSkip == false){
                cell.count.text = counterMedi
            }else{
                cell.count.text = String(describing: countMedi)
            }
        }
        if(indexPath.row == 3 && cell.name.text == "Hospital Visits"){
            if(cell.name.text == "Hospital Visits" && counterHos != "" && countHos == 0 && countSkip == false){
                cell.count.text = counterHos
            }else{
                cell.count.text = String(describing: countHos)
            }
        }
        
        if(indexPath.row == 4 && cell.name.text == "Pathology Results"){
            if(cell.name.text == "Pathology Results" && counterPath != "" && countPath == 0 && countSkip == false){
                cell.count.text = counterPath
            }else{
                cell.count.text = String(describing: countPath)
            }
        }
        
        
        
        if(shouldCellBeExpanded  && indexPath.row == indexOfExpandedCell)
        {
            
            cell.tableView.isHidden = false
            
            let prefs = UserDefaults.standard
            
            
            let type = cell.name.text!
            print(type)
            prefs.set(type, forKey: "SubType")
            
            cell.expandRow.text = "open"
            ShowMoreLess = "open"
            
            cell.tableView.reloadData()
            
        }else{
            cell.tableView.isHidden = true
            
            cell.expandRow.text = "closed"
            ShowMoreLess = "closed"
        }
        
        
        
        cell.count.layer.cornerRadius =  cell.count.frame.size.width / 2
        cell.count.clipsToBounds = true
        
        return cell
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        print("touch me")
        
        if(ShowMoreLess == "closed"){
            shouldCellBeExpanded = true
            
            
            
            indexOfExpandedCell = indexPath.row
            //print(indexOfEditCell)
            let indexPathNow = IndexPath(item: indexOfExpandedCell, section: 0)
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPathNow], with: .fade)
            self.tableView.endUpdates()
            
            
            
        }else{
            
            shouldCellBeExpanded = false
            
            
            indexOfExpandedCell = indexPath.row
            //print(indexOfEditCell)
            let indexPathNow = IndexPath(item: indexOfExpandedCell, section: 0)
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPathNow], with: .fade)
            self.tableView.endUpdates()
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(shouldCellBeExpanded  && indexPath.row == indexOfExpandedCell && indexPath.section == 0){
            
            return 190 //Your desired height for the expanded cell
        }else{
            return 38
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL]) {
        //Your code here
    }
    
    private func prepareAttachButton() {
        
        attach.addTarget(self, action: #selector(buttonAttachAction), for: .touchUpInside)
        
        
        
    }
    
    func buttonAttachAction(sender: UIButton!) {
        print("Button tapped")
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergyChronic") != nil){
            
            let optionMenuPhoto = UIAlertController(title: nil, message: "Add Photo/Attachment", preferredStyle: .actionSheet)
            
            // 2
            let photoAction = UIAlertAction(title: "Take a photo", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                
                let prefs = UserDefaults.standard
                prefs.set(self.recordValue, forKey: "attachId")
                prefs.set("CHRONIC_CONDITION", forKey: "attachType")
                
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.navigationBar.barTintColor = UIColor(red: 0/255, green: 149/255, blue: 217/255, alpha: 1.0)
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            })
            
            // 2
            let galleryAction = UIAlertAction(title: "Select from gallery", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                let prefs = UserDefaults.standard
                prefs.set(self.recordValue, forKey: "attachId")
                prefs.set("CHRONIC_CONDITION", forKey: "attachType")
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                    
                    
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                    self.imagePicker.allowsEditing = true
                    self.imagePicker.navigationBar.barTintColor = UIColor(red: 0/255, green: 149/255, blue: 217/255, alpha: 1.0)
                    self.imagePicker.navigationBar.tintColor = .white
                    
                    self.present(self.imagePicker, animated: true, completion: nil)
                }            })
            
            /*let fileAction = UIAlertAction(title: "Choose a file", style: .default, handler: {
             (alert: UIAlertAction!) -> Void in
             
             let navigationBarAppearace = UINavigationBar.appearance()
             
             navigationBarAppearace.tintColor = .white
             navigationBarAppearace.barTintColor = UIColor(red: 0/255, green: 153/255, blue: 217/255, alpha: 1.0)
             
             
             
             let fileExplorer = FileExplorerViewController()
             fileExplorer.canChooseFiles = true //specify whether user is allowed to choose files
             fileExplorer.canChooseDirectories = true //specify whether user is allowed to choose directories
             fileExplorer.allowsMultipleSelection = false //specify whether user is allowed to choose multiple files and/or directories
             fileExplorer.fileFilters = [Filter.extension("txt"), Filter.extension("pdf"), Filter.extension("doc")]
             
             //let documentsUrl = FileManager.default.urls(for: .picturesDirectory,
             //  in: .userDomainMask).first!
             //fileExplorer.initialDirectoryURL = documentsUrl
             fileExplorer.ignoredFileFilters = [Filter.extension("txt")]
             fileExplorer.delegate = self
             
             self.present(fileExplorer, animated: true, completion: nil)
             
             })*/
            //
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            
            
            // 4
            optionMenuPhoto.addAction(photoAction)
            optionMenuPhoto.addAction(galleryAction)
            //optionMenuPhoto.addAction(fileAction)
            optionMenuPhoto.addAction(cancelAction)
            
            // 5
            //presentViewController(optionMenu, animated: true, completion: nil)
            parent?.present(optionMenuPhoto, animated: true, completion: nil)
            //self.present(optionMenu, animated: true, completion: nil)
            
            
        }else{
            self.view.makeToast("Please save record before adding an attachment", duration: 3.0, position: .center)
            
        }
        
        
        
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
        chooseDropDown.dataSource = ["Uncontrolled, even with medication", "Controlled, with medication", "Controlled, without medication", "Life Threatening", "Other"]
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "mainAllergyChronic") != nil){
            
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
        
        bpDate.placeholder = "Date first diagnosed"
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
            
            
            hidelater = "true"
            
            
        }else if (hideBool == true){
            let image = UIImage(named: "blue_unhide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = false
            self.view.makeToast("Record has been made visible, please apply to save", duration: 3.0, position: .center)
            
            
            hidelater = "false"
            
            
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
    
    public func loadJSON() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Notes") != nil){
            
            return JSON.parse(prefs.string(forKey: "Notes")!)
        }else{
            return nil
        }
        
    }
    
    
    
    private func sendMainAllergyChronic() {
        
        
        let strDate: String = bpDate.text!
        
        let strDesc: String = condition.text!
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        saveButton.isEnabled = false
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "healthProfiles/chronicConditions"
        
        print(urlString)
        
        let date = strDate
        let dec = strDesc
        
        var save = true
        var del = false
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        let authToken = prefs.string(forKey: "authToken")
        
        var savedFiles: [[String: AnyObject]] = []
        var savedFilesPath: [[String: AnyObject]] = []
        var savedFilesDoc: [[String: AnyObject]] = []
        var savedFilesHos: [[String: AnyObject]] = []
        var savedFilesMedi: [[String: AnyObject]] = []
        
        var savedSubs : [String: NSArray] = [:]
        
        if (prefs.string(forKey: "Notes") != nil){
            
            let json = self.loadJSON()
            
            print(json)
            
            print("what")
            
            
            
            for (_, object) in json {
                print("hello")
                
                var add : [String: String] = [:]
                //print(item["id"].stringValue)
                add["recordId"] = object["recordId"].stringValue
                add["_type"] = object["_type"].stringValue
                add["Date"] = object["Date"].stringValue
                add["_hide"] = object["_hide"].stringValue
                add["_save"] = object["_save"].stringValue
                add["_delete"] = object["_delete"].stringValue
                add["lastUpdated"] = object["lastUpdated"].stringValue
                add["Notes"] = object["Notes"].stringValue
                
                savedFiles.append(add as [String : AnyObject])
                
                print(savedFiles)
                
            }
            
            
            
        }
        
        if (prefs.string(forKey: "Pathology") != nil){
            
            let json = self.loadJSONPath()
            
            print(json)
            
            
            
            for (_, object) in json {
                print("hello")
                
                var add : [String: String] = [:]
                //print(item["id"].stringValue)
                add["recordId"] = object["recordId"].stringValue
                add["_type"] = object["_type"].stringValue
                add["Test Date"] = object["Test Date"].stringValue
                add["_hide"] = object["_hide"].stringValue
                add["_save"] = object["_save"].stringValue
                add["_delete"] = object["_delete"].stringValue
                add["lastUpdated"] = object["lastUpdated"].stringValue
                add["Prescribed by?"] = object["Prescribed by?"].stringValue
                add["Diagnosis/Reason for test?"] = object["Diagnosis/Reason for test?"].stringValue
                add["Test description"] = object["Test description"].stringValue
                add["Was this test prescribed by a doctor?"] = object["Was this test prescribed by a doctor?"].stringValue
                
                savedFilesPath.append(add as [String : AnyObject])
                
                
            }
            
            
            
        }
        
        if (prefs.string(forKey: "Doctors") != nil){
            
            let json = self.loadJSONDoc()
            
            print(json)
            
            
            
            for (_, object) in json {
                print("hello")
                
                var add : [String: String] = [:]
                //print(item["id"].stringValue)
                add["recordId"] = object["recordId"].stringValue
                add["_type"] = object["_type"].stringValue
                add["Date visited"] = object["Date visited"].stringValue
                add["_hide"] = object["_hide"].stringValue
                add["_save"] = object["_save"].stringValue
                add["_delete"] = object["_delete"].stringValue
                add["lastUpdated"] = object["lastUpdated"].stringValue
                add["Name of doctor"] = object["Name of doctor"].stringValue
                add["Contact number"] = object["Contact number"].stringValue
                add["Doctor type/specialization"] = object["Doctor type/specialization"].stringValue
                add["Diagnosis/Reason for visit?"] = object["Diagnosis/Reason for visit?"].stringValue
                add["What treatment was given?"] = object["What treatment was given?"].stringValue
                
                
                savedFilesDoc.append(add as [String : AnyObject])
                
                
            }
            
            
            
        }
        
        if (prefs.string(forKey: "Hospitals") != nil){
            
            let json = self.loadJSONHos()
            
            print(json)
            
            
            
            for (_, object) in json {
                print("hello")
                
                var add : [String: String] = [:]
                //print(item["id"].stringValue)
                add["recordId"] = object["recordId"].stringValue
                add["_type"] = object["_type"].stringValue
                add["Admission date"] = object["Admission date"].stringValue
                add["Discharge date"] = object["Discharge date"].stringValue
                add["_hide"] = object["_hide"].stringValue
                add["_save"] = object["_save"].stringValue
                add["_delete"] = object["_delete"].stringValue
                add["lastUpdated"] = object["lastUpdated"].stringValue
                add["Hospital name"] = object["Hospital name"].stringValue
                add["Who was the treating doctor?"] = object["Who was the treating doctor?"].stringValue
                
                add["Diagnosis/Reason for visit?"] = object["Diagnosis/Reason for visit?"].stringValue
                add["What treatment did you receive?"] = object["What treatment did you receive?"].stringValue
                
                
                savedFilesHos.append(add as [String : AnyObject])
                
                
            }
            
            
            
        }
        
        if (prefs.string(forKey: "Medication") != nil){
            
            let json = self.loadJSONMedi()
            
            print(json)
            
            
            
            for (_, object) in json {
                print("hello")
                
                var add : [String: String] = [:]
                //print(item["id"].stringValue)
                add["recordId"] = object["recordId"].stringValue
                add["_type"] = object["_type"].stringValue
                add["Start date"] = object["Start date"].stringValue
                add["End date"] = object["End date"].stringValue
                add["_hide"] = object["_hide"].stringValue
                add["_save"] = object["_save"].stringValue
                add["_delete"] = object["_delete"].stringValue
                add["lastUpdated"] = object["lastUpdated"].stringValue
                add["Medicine name"] = object["Medicine name"].stringValue
                add["Strength"] = object["Strength"].stringValue
                add["Dosage"] = object["Dosage"].stringValue
                add["Frequency"] = object["Frequency"].stringValue
                add["Number of repeat fills?"] = object["Number of repeat fills?"].stringValue
                add["Medicine notes"] = object["Medicine notes"].stringValue
                add["Prescribed by"] = object["Prescribed by"].stringValue
                
                add["Diagnosis/Reason for visit?"] = object["Diagnosis/Reason for visit?"].stringValue
                add["Was this medicine prescribed by a doctor?"] = object["Was this medicine prescribed by a doctor?"].stringValue
                add["Is this a repeat prescription?"] = object["Is this a repeat prescription?"].stringValue
                
                savedFilesMedi.append(add as [String : AnyObject])
                
                
            }
            
            
            
        }
        
        savedSubs["Notes"] = savedFiles as NSArray?
        savedSubs["Pathology"] = savedFilesPath as NSArray?
        savedSubs["Doctor Visit"] = savedFilesDoc as NSArray?
        savedSubs["Hospital Visit"] = savedFilesHos as NSArray?
        savedSubs["Medicine"] = savedFilesMedi as NSArray?
        
        
        if(deleteRecord == true){
            save = false
            del = true
            
        }
        
        
        
        
        let parameters: Parameters = [
            "loggedInUserDetailsId": String(loggedInUserDetailsId),
            "currentActiveUserDetailsId": String(currentActiveUserDetailsId),
            "date": date,
            "condition": dec,
            "recordId": recordValue,
            "status": serverityValue,
            "_hide": false,
            "_save": save,
            "_delete": del,
            "subRecords": savedSubs
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
                self.recordIdValue = json["recordId"].string!
                
                if status == "SUCCESS"{
                    
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    if(self.hidelater != "null"){
                        
                        self.recordValue = self.recordIdValue
                        prefs.set(self.messageStr, forKey: "savedServerMessage")
                        self.hideUnhideRecord()
                    }else{
                        appDelegate.gethealthProfile()
                        let prefs = UserDefaults.standard
                        prefs.set(self.messageStr, forKey: "savedServerMessage")
                        
                    }
                    
                    
                    
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
    
    
    private func hideUnhideRecord() {
        
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.showActivityIndicator(uiView: self.view)
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "records/hideUnhide"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        if (hidelater == "false"){
            hideBool = false
        }
        
        if (hidelater == "true"){
            hideBool = true
        }
        
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "recordId": recordValue,
            "recordType": "CHRONIC_CONDITION",
            "_hide": hideBool
            
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        MainChronic.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    print("success")
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.gethealthProfile()
                    
                    
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
    
    
    public func saveJSONList(j: JSON) {
        let prefs = UserDefaults.standard
        
        prefs.set(j.rawString()!, forKey: "Attachments")
        
        // here I save my JSON as a string
    }
    
    
    
    private func listAttachments() {
        
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "records/listAttachments"
        
        print(urlString)
        
        
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        let authToken = prefs.string(forKey: "authToken")
        
        
        
        let parameters: Parameters = [
            "loggedInUserDetailsId": String(loggedInUserDetailsId),
            "currentActiveUserDetailsId": String(currentActiveUserDetailsId),
            "recordId": recordValue,
            "type": "CHRONIC_CONDITION"
            
        ]
        
        
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json",
            "Content-Type": "application/json"
            
        ]
        
        
        
        MainChronic.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            print(response)
            
            //print(response)
            let responseJSON = response.result.value
            if(responseJSON != nil){
                let json1 = JSON(responseJSON as Any)
                
                self.saveJSONList(j: json1)
            }
            
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(json)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                
                if status == "SUCCESS"{
                    
                    let count = json["attachments"].array?.count
                    
                    self.countAttachments = count!
                    
                    self.tableView.reloadData()
                    
                }else{
                    
                    //self.showError()
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
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        let prefs = UserDefaults.standard
        
        prefs.set(condition.text, forKey: "globalReason")
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
