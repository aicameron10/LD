//
//  HealthProfileController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/15.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire


class HealthProfileController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var refreshControl = UIRefreshControl()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        preparePageTabBarItem()
    }
    @IBOutlet weak var tableViewProfile: UITableView!
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        preparePageTabBarItem()
    }
    
    var messageStr : String = String()
    
    var shouldCellBeExpanded = false
    var indexOfExpandedCell = -1
    var ShowMoreLess = "Show More"
    
    var indexOfChangedCell = -1
    
    var indexOfDeletedCell = -1
    var indexOfEditCell = -1
    
    var deletedListValue = ""
    
    var hideList : Array<String> = Array()
    
    var deleteList : Array<String> = Array()
    
    var deleteValue = ""
    
    var measurementValue = ""
    
    var arrayHealthProfile = [HealthProfile]()
    
    var add : Array<String> = Array()
    
    let NUMBER_OF_STATIC_CELLS = 1
    
    var hideRecord = false
    
    var hideRecordValue = false
    
    var recordType = ""
    
    var recordValue = ""
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        self.tableViewProfile?.addSubview(refreshControl)
        
        self.tableViewProfile.estimatedRowHeight = 80.0
        self.tableViewProfile.rowHeight = UITableViewAutomaticDimension
        
        tableViewProfile.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(HealthProfileController.longPressGestureRecognized(_:)))
        tableViewProfile.addGestureRecognizer(longpress)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadTableProfile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadListHistory), name: NSNotification.Name(rawValue: "loadTableProfileHistory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadDetails), name: NSNotification.Name(rawValue: "loadGetDetail"), object: nil)
        
        
        //self.loadJSON()
        if(self.loadJSON() != nil){
            print("loading history Profiles")
            //print(self.loadJSON())
            gethealthProfileHistory()
        }else{
            print("Nil value returned so no history")
            gethealthProfile()
        }
        
        
        
    }
    
    func loadList(notification: NSNotification){
        //load data here
        gethealthProfile()
        print("relaoding")
    }
    
    func loadDetails(notification: NSNotification){
        //load data here
        getDetails()
        print("getting details")
    }
    
    func loadListHistory(notification: NSNotification){
        //load data here
        print("relaoding History Profile")
        gethealthProfileHistory()
        
    }
    
    
    func refresh(sender:AnyObject) {
        
        gethealthProfile()
    }
    
    private func preparePageTabBarItem() {
        //pageTabBarItem.title = "My Health Assessments"
        //pageTabBarItem.titleColor = Color.white
        
        let myString = "Health Profile"
        let myMutableString = NSMutableAttributedString(
            string: myString,
            attributes: [NSFontAttributeName:
                UIFont(name: "Arial", size: 11.50 )!
            ]
        )
        myMutableString.addAttribute(NSForegroundColorAttributeName,
                                     value: UIColor.white,
                                     range: NSRange(
                                        location:0,
                                        length:14))
        
        pageTabBarItem.setAttributedTitle(myMutableString, for: UIControlState.normal)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableViewProfile)
        let indexPath = tableViewProfile.indexPathForRow(at: locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableViewProfile.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshotOfCell(cell!)
                
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                tableViewProfile.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
            
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    arrayHealthProfile.insert(arrayHealthProfile.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                    tableViewProfile.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableViewProfile.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell?.center)!
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
                })
            }
        }
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    
    public func saveJSONSubs(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "recordSubs")
        
        // here I save my JSON as a string
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if (section == 0) {
            return 1; //However many static cells you want
        } else {
            return arrayHealthProfile.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = HealthProfileCustomCell()
        
        if(indexPath.section == 0){
            cell = tableView.dequeueReusableCell(withIdentifier: "CellPic", for: indexPath) as! HealthProfileCustomCell
            
        }
        if (indexPath.section == 1){
            //let cell:HealthAssessmentCustomCell = self.tableViewAssess.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HealthAssessmentCustomCell
            // Don't forget to enter this in IB also
            //let cellReuseIdentifier = "CellAssess\(indexPath.row-2)"
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CellProfile", for: indexPath) as! HealthProfileCustomCell
            
            cell.separatorInset.left = 20.0
            cell.separatorInset.right = 20.0
            cell.separatorInset.top = 20.0
            cell.separatorInset.bottom = 20.0
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            
            let healthProfile = arrayHealthProfile[indexPath.row]
            
            cell.count.text = healthProfile.subRecordCount
            
            cell.hiddenValue.text = healthProfile.hide
            
            cell.showMore.tag = indexPath.row
            
            cell.showMore.addTarget(self,action:#selector(self.buttonClicked), for: .touchUpInside)
            
            cell.name.text = healthProfile.name
            cell.type.text = healthProfile.description
            cell.dateStr.text = "Last Updated: " + healthProfile.lastUpdated
            
            
            cell.recordId.text = healthProfile.recordId
            
            
            cell.showMore.setTitle("Show More", for: .normal)
            
            if(cell.count.text! == "0"){
                cell.showMore.isHidden = true
            }else{
                cell.showMore.isHidden = false
            }
            
            cell.subRecords.text = healthProfile.subRecords
            
            if(healthProfile.hide == "false"){
                let image = UIImage(named: "blue_unhide") as UIImage?
                cell.hide.setBackgroundImage(image, for: .normal)
                
            }else if (healthProfile.hide == "true"){
                let image = UIImage(named: "blue_hide") as UIImage?
                cell.hide.setBackgroundImage(image, for: .normal)
                
            }
            
            
            if(shouldCellBeExpanded && indexPath.row == indexOfExpandedCell)
            {
                
                let prefs = UserDefaults.standard
                prefs.removeObject(forKey: "recordSubs")
                
                let json = JSON(cell.subRecords.text!)
                
                
                self.saveJSONSubs(j: json)
                
                if(cell.type.text!.uppercased() == "ALLERGY"){
                    
                    recordType = cell.type.text!.uppercased()
                    recordValue = cell.recordId.text!
              
                    
                }else if(cell.type.text!.uppercased() == "CHRONIC CONDITION"){
                    
                    
                }

              
                cell.tableViewSubs.isHidden = false
                
                cell.tableViewSubs.reloadData()
                
                cell.showMore.setTitle("Show Less", for: .normal)
                ShowMoreLess = "Show Less"
            }else{
                cell.tableViewSubs.isHidden = true
                cell.showMore.setTitle("Show More", for: .normal)
                ShowMoreLess = "Show More"
            }
            
            
            if(indexPath.row == indexOfChangedCell)
            {
                hideList.removeAll()
                
                hideList.append(cell.recordId.text!)
                
                let hidden = cell.hiddenValue.text!
                
                
                recordType = cell.type.text!.uppercased()
                
                if(hidden == "false"){
                    let image = UIImage(named: "blue_hide") as UIImage?
                    cell.hide.setBackgroundImage(image, for: .normal)
                    hideRecordValue = true
                    
                }else if (hidden == "true"){
                    let image = UIImage(named: "blue_unhide") as UIImage?
                    cell.hide.setBackgroundImage(image, for: .normal)
                    hideRecordValue = false
                    
                }
                
                
            }
            
            if(indexPath.row == indexOfDeletedCell)
            {
                
                print("deleting....")
                deletedListValue = cell.recordId.text!
                
                //print(cell.type.text!.uppercased())
                
                if(cell.type.text!.uppercased() == "ALLERGY"){
                    deleteValue = "allergies"
                }else if(cell.type.text!.uppercased() == "CHRONIC CONDITION"){
                    deleteValue = "chronicConditions"
                }
                
                
                
            }
            
            if(indexPath.row == indexOfEditCell)
            {
                
                indexOfEditCell = -1
                if(cell.type.text!.uppercased() == "ALLERGY"){
                    
                    recordType = cell.type.text!.uppercased()
                    recordValue = cell.recordId.text!
                    
                    getDetails()
                    
                    
                }else if(cell.type.text!.uppercased() == "CHRONIC CONDITION"){
                   
                    
                }
    
                
                
            }
            
            
            
            
            
            
            cell.count.layer.cornerRadius = 11.0
            cell.count.clipsToBounds = true
            
            cell.edit.tag = indexPath.row
            
            cell.edit.addTarget(self,action:#selector(self.buttonEditClicked), for: .touchUpInside)
            
            cell.hide.tag = indexPath.row
            
            cell.hide.addTarget(self,action:#selector(self.buttonHideClicked), for: .touchUpInside)
            
            cell.more.tag = indexPath.row
            
            cell.more.addTarget(self,action:#selector(self.buttonMoreClicked), for: .touchUpInside)
            
            
            
            
            if(healthProfile.description == "Allergy"){
                
                cell.imagepic.image = UIImage(named:"lifedoc_icons_allergy.png")
            }else if(healthProfile.description == "Chronic Condition"){
                
                cell.imagepic.image = UIImage(named:"lifedoc_icons_chronic_condition.png")
            }
            else{
                cell.imagepic.image = UIImage(named:"purple_health_record.png")
                
            }
            
        }
        
        
        return cell
        
    }
    
    
    func buttonEditClicked(sender:UIButton) {
        
        indexOfDeletedCell = -1
        indexOfChangedCell = -1
        
        let buttonRow = sender.tag
        indexOfEditCell = buttonRow
        print("Edit clicked")
        
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        let indexPath = IndexPath(item: indexOfEditCell, section: 1)
        self.tableViewProfile.beginUpdates()
        self.tableViewProfile.reloadRows(at: [indexPath], with: .fade)
        self.tableViewProfile.endUpdates()

        
    }
    
    
    
    func buttonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        indexOfExpandedCell = buttonRow
        
        
        
        if(ShowMoreLess == "Show More"){
            shouldCellBeExpanded = true;
            
            
            let indexPath = IndexPath(item: indexOfExpandedCell, section: 1)
            
            self.tableViewProfile.beginUpdates()
            self.tableViewProfile.reloadRows(at: [indexPath], with: .fade)
            self.tableViewProfile.endUpdates()
            
        }else{
            
            shouldCellBeExpanded = false;
            
            
            let indexPath = IndexPath(item: indexOfExpandedCell, section: 1)
            
            self.tableViewProfile.beginUpdates()
            self.tableViewProfile.reloadRows(at: [indexPath], with: .fade)
            self.tableViewProfile.endUpdates()
        }
        
    }
    
    // [[self tableView] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfExpandedCell inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    // self.tableView.reloadRowsAtIndexPaths:(arrIndexPaths withRowAnimation:UITableViewRowAnimation.Fade)
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
          indexOfEditCell = indexPath.row
       //print(indexOfEditCell)
        let indexPathNow = IndexPath(item: indexOfEditCell, section: 1)
        self.tableViewProfile.beginUpdates()
        self.tableViewProfile.reloadRows(at: [indexPathNow], with: .fade)
        self.tableViewProfile.endUpdates()
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(shouldCellBeExpanded && indexPath.row == indexOfExpandedCell && indexPath.section == 1){
            
            return 270 //Your desired height for the expanded cell
        }
        
        
        if(indexPath.section == 0){
            
            return 120
            
        }else{
            return 110
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func buttonHideClicked(sender:UIButton) {
        
        indexOfDeletedCell = -1
        indexOfEditCell = -1
        
        let buttonRow = sender.tag
        indexOfChangedCell = buttonRow
        
        let indexPath = IndexPath(item: indexOfChangedCell, section: 1)
        self.tableViewProfile.beginUpdates()
        self.tableViewProfile.reloadRows(at: [indexPath], with: .fade)
        self.tableViewProfile.endUpdates()
        
        
        
        self.hideUnhideRecord()
        
        
    }
    
    func buttonMoreClicked(sender:UIButton) {
        
        
        print("More clicked")
        
        
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        let optionMenu = UIAlertController(title: nil, message: "More Options", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.indexOfChangedCell = -1
            self.indexOfEditCell = -1
            
            let buttonRow = sender.tag
            self.indexOfDeletedCell = buttonRow
            
            
            let indexPath = IndexPath(item: self.indexOfDeletedCell, section: 1)
            self.tableViewProfile.beginUpdates()
            self.tableViewProfile.reloadRows(at: [indexPath], with: .fade)
            self.tableViewProfile.endUpdates()
            
            self.showAreYouSure()
            
        })
        
        // 2
        let attachAction = UIAlertAction(title: "Attachments", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            let buttonRow = sender.tag
            self.indexOfDeletedCell = buttonRow
            
            
            let indexPath = IndexPath(item: self.indexOfDeletedCell, section: 1)
            self.tableViewProfile.beginUpdates()
            self.tableViewProfile.reloadRows(at: [indexPath], with: .fade)
            self.tableViewProfile.endUpdates()
            
            self.showAreYouSure()
            
        })
        
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(attachAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        //presentViewController(optionMenu, animated: true, completion: nil)
        self.view.window?.rootViewController?.present(optionMenu, animated: true, completion: nil)
        //self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    
    func showAreYouSure() {
        let ac = UIAlertController(title: "Message", message: "Are you sure you wish to delete this information? Please note that all the Sub-records will also be deleted", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
        })
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
            
            self.deleteRecord()
        })
        self.view.window?.rootViewController?.present(ac, animated: true)
    }
    
    
    
    public func saveJSON(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "jsonHealthProfile")
        
        // here I save my JSON as a string
    }
    
    public func loadJSON() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "jsonHealthProfile") != nil){
            
            return JSON.parse(prefs.string(forKey: "jsonHealthProfile")!)
        }else{
            return nil
        }
        
    }
    
    private func gethealthProfileHistory() {
        
        self.arrayHealthProfile.removeAll()
        
        indexOfChangedCell = -1
        indexOfExpandedCell = -1
        indexOfDeletedCell = -1
        
        let json = self.loadJSON()
        
        
        for item in json["records"].arrayValue {
            
            
            let healthprofile = HealthProfile()
            healthprofile.recordId = item["recordId"].stringValue
            healthprofile.description = item["description"].stringValue
            healthprofile.subRecordCount = item["subRecordCount"].stringValue
            healthprofile.hide = item["_hide"].stringValue
            
            healthprofile.lastUpdated = item["lastUpdated"].stringValue
            healthprofile.name = item["attributes"][0]["value"].stringValue
            
            healthprofile.subRecords = String(describing: item["subRecords"].arrayValue)
            
            self.arrayHealthProfile.append(healthprofile)
            
        }
        
        self.tableViewProfile?.reloadData()
        
    }
    
    
    public func saveJSONAllergy(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "mainAllergy")
        
        // here I save my JSON as a string
    }
    
    private func getDetails() {
        
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
      
        let urlString: String
        
        urlString = Constants.baseURL + "healthProfiles/details"
        
        print(urlString)
        
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        let authToken = prefs.string(forKey: "authToken")
        
        
        
        
        let parameters: Parameters = [
            "loggedInUserDetailsId": String(loggedInUserDetailsId),
            "currentActiveUserDetailsId": String(currentActiveUserDetailsId),
            "recordId": recordValue,
            "recordType": recordType
            
        ]
        
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json",
            "Content-Type": "application/json"
            
        ]
        
        
        
        HealthProfileController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            //print(response)
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(json)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                
                if status == "SUCCESS"{
                    
                    let responseJSON = response.result.value
                    
                    if(responseJSON != nil){
                        let json1 = JSON(responseJSON as Any)
                        
                        self.saveJSONAllergy(j: json1)
                    }

                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    
                    if(self.recordType == "ALLERGY"){
                        
                        let allergy: MainAllergy = {
                            return UIStoryboard.viewController(identifier: "MainAllergy") as! MainAllergy
                        }()
                        
                        let allergyView = AppMenuSubRecords(rootViewController: allergy)
                        
                        self.present(allergyView, animated: false, completion: nil)
                        
                    }else if(self.recordType == "CHRONIC CONDITION"){
                        
                        
                    }

                   
                    
                 

                    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //appDelegate.hideActivityIndicator(uiView: self.view)
                    //self.showSuccess()
                    
                    //appDelegate.gethealthProfile()
                    //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTable"), object: nil)
                    
                    //let prefs = UserDefaults.standard
                    //prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    //Toast(text: self.messageStr, duration: Delay.long).show()
                    //self.dismiss(animated: true, completion: nil)
                    
                }else{
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
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                self.showNetworkError()
                
            } else {
                
                
                
                
            }
            
        }
        
        
    }

    
    private func gethealthProfile() {
        
        
        // tell refresh control it can stop showing up now
        if (!self.refreshControl.isRefreshing){
            
            // get a reference to the app delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showActivityIndicator(uiView: self.view)
        }
        
        
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "healthProfiles/list"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        let authToken = prefs.string(forKey: "authToken")
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId
            
        ]
        
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        HealthProfileController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            print(response)
            
            let responseJSON = response.result.value
            
            if(responseJSON != nil){
                let json1 = JSON(responseJSON as Any)
                
                self.saveJSON(j: json1)
            }
            
            
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    
                    print("success")
                    
                    self.arrayHealthProfile.removeAll()
                    
                    // tell refresh control it can stop showing up now
                    if self.refreshControl.isRefreshing
                    {
                        self.refreshControl.endRefreshing()
                    }
                    
                    
                    for item in json["records"].arrayValue {
                        
                        
                        let healthprofile = HealthProfile()
                        healthprofile.recordId = item["recordId"].stringValue
                        healthprofile.description = item["description"].stringValue
                        healthprofile.hide = item["_hide"].stringValue
                        
                        healthprofile.subRecordCount = item["subRecordCount"].stringValue
                        healthprofile.lastUpdated = item["lastUpdated"].stringValue
                        
                        healthprofile.name = item["attributes"][0]["value"].stringValue
                        
                        healthprofile.subRecords = String(describing: item["subRecords"].arrayValue)
                        
                        self.arrayHealthProfile.append(healthprofile)
                        
                    }
                    
                    self.tableViewProfile?.reloadData()
                    
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
                
                // tell refresh control it can stop showing up now
                if self.refreshControl.isRefreshing
                {
                    self.refreshControl.endRefreshing()
                }
                
                
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                self.showNetworkError()
                
                
                
            } else {
                
                // get a reference to the app delegate
                // let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //appDelegate.hideActivityIndicator(uiView: self.view)
                // self.showNetworkError()
                
            }
        }
        
        
    }
    
    
    private func hideUnhideRecord() {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "records/hideUnhide"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "recordId": hideList[0],
            "recordType": recordType,
            "_hide": hideRecordValue
            
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        HealthProfileController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    print("success")
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    appDelegate.gethealthProfile()
                    
                    
                    
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
    
    private func deleteRecord() {
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        
        self.view.makeToast("Deleting record...", duration: 3.0, position: .bottom)
        
        let urlString: String
        
        print(deleteValue)
        
        urlString = Constants.baseURL + "healthProfiles/" + deleteValue
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "date": "",
            "description": "",
            "recordId": deletedListValue,
            "severity": "",
            "_hide": false,
            "_save": false,
            "_delete": true,
            "subRecords": deleteList
            
            
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        HealthProfileController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    appDelegate.gethealthProfile()
                    
                    
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
    
    
}


class HealthProfile {
    var recordId = ""
    var name = ""
    var subRecordCount = ""
    var description = ""
    var lastUpdated = ""
    var hide = ""
    var subRecords = ""
    
}

