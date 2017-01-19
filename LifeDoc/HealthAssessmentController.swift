//
//  HealthAssessmentController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/15.
//  Copyright © 2016 MediSwitch. All rights reserved.
///

import UIKit
import Material
import Alamofire


class HealthAssessmentController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var refreshControl = UIRefreshControl()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        preparePageTabBarItem()
    }
    @IBOutlet weak var tableViewAssess: UITableView!
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        preparePageTabBarItem()
    }
    
    var messageStr : String = String()
    
    var shouldCellBeExpanded = false
    var indexOfExpandedCell = -1
    var ShowMoreLess = "Show More"
    
    var measurementValue = ""
    
    var tempCell = 0
    
    var arrayHealthAssessment = [HealthAssessment]()
    
    var add : Array<String> = Array()
    
    let NUMBER_OF_STATIC_CELLS = 1
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        self.tableViewAssess?.addSubview(refreshControl)
        
        self.tableViewAssess.estimatedRowHeight = 80.0
        self.tableViewAssess.rowHeight = UITableViewAutomaticDimension
        
        
        tableViewAssess.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(HealthProfileController.longPressGestureRecognized(_:)))
        tableViewAssess.addGestureRecognizer(longpress)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadTable"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadListHistory), name: NSNotification.Name(rawValue: "loadTableHistory"), object: nil)
        
        //self.loadJSON()
        if(self.loadJSON() != nil){
            print("loading history Assess")
            //print(self.loadJSON())
            gethealthAssessmentsHistory()
        }else{
            print("Nil value returned")
            gethealthAssessments()
        }
        
        
        
    }
    
    func loadList(notification: NSNotification){
        //load data here
        gethealthAssessments()
        print("relaoding")
    }
    
    func loadListHistory(notification: NSNotification){
        //load data here
        gethealthAssessmentsHistory()
        print("relaoding History")
    }
    
    func refresh(sender:AnyObject) {
        
        gethealthAssessments()
    }
    
    private func preparePageTabBarItem() {
        //pageTabBarItem.title = "My Health Assessments"
        //pageTabBarItem.titleColor = Color.white
        
        let myString = "Health Assessments"
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
                                        length:18))
        
        pageTabBarItem.setAttributedTitle(myMutableString, for: UIControlState.normal)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableViewAssess)
        let indexPath = tableViewAssess.indexPathForRow(at: locationInView)
        
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
                let cell = tableViewAssess.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshotOfCell(cell!)
                
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                tableViewAssess.addSubview(My.cellSnapshot!)
                
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
                    arrayHealthAssessment.insert(arrayHealthAssessment.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                    tableViewAssess.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableViewAssess.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if (section == 0) {
            return 1; //However many static cells you want
        } else {
            return arrayHealthAssessment.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = HealthAssessmentCustomCell()
        
        if(indexPath.section == 0){
            cell = tableView.dequeueReusableCell(withIdentifier: "CellPic", for: indexPath) as! HealthAssessmentCustomCell
            
        }
        if (indexPath.section == 1){
            //let cell:HealthAssessmentCustomCell = self.tableViewAssess.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HealthAssessmentCustomCell
            // Don't forget to enter this in IB also
            //let cellReuseIdentifier = "CellAssess\(indexPath.row-2)"
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CellAssess", for: indexPath) as! HealthAssessmentCustomCell
            
            cell.separatorInset.left = 20.0
            cell.separatorInset.right = 20.0
            cell.separatorInset.top = 20.0
            cell.separatorInset.bottom = 20.0
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            
            
            cell.tableView.isHidden = true
            
            
            let healthAssess = arrayHealthAssessment[indexPath.row]
            
            cell.assessName.text = healthAssess.type
        
            cell.showMoreAssess.tag = indexPath.row
            
            cell.showMoreAssess.addTarget(self,action:#selector(self.buttonClicked), for: .touchUpInside)
            
            cell.showMoreAssess.setTitle("Show More", for: .normal)
            
            //cell.showMoreAssess.setTitle("Show More", for: .normal)
            
            cell.measurements.text = healthAssess.measurements
            
            cell.count.layer.cornerRadius = 11.0
            cell.count.clipsToBounds = true
            cell.count.text = healthAssess.count
        
            
            if(shouldCellBeExpanded && indexPath.row == indexOfExpandedCell)
            {
                let prefs = UserDefaults.standard
                prefs.removeObject(forKey: "measurementValue")
                
                let json = JSON(cell.measurements.text!)
                
                
                //print(json)
                
                self.saveJSONNow(j: json)
                
              
                let type = cell.assessName.text!
                prefs.set(type, forKey: "AssessmentType")
                
                // design your read more label here
                cell.tableView.isHidden = false
                
                cell.tableView.reloadData()
                cell.showMoreAssess.setTitle("Show Less", for: .normal)
                ShowMoreLess = "Show Less"
            }else{
                cell.tableView.isHidden = true
                cell.showMoreAssess.setTitle("Show More", for: .normal)
                ShowMoreLess = "Show More"
            }
            
            
            
            if(healthAssess.type == "Blood Glucose"){
                
                cell.assessImage.image = UIImage(named:"lifedoc_icons_blood_glucose.png")
            }else if(healthAssess.type == "Height"){
                
                cell.assessImage.image = UIImage(named:"lifedoc_icons_height.png")
            }else if(healthAssess.type == "Weight"){
                
                cell.assessImage.image = UIImage(named:"lifedoc_icons_weight.png")
            }else if(healthAssess.type == "Pulse"){
                
                cell.assessImage.image = UIImage(named:"lifedoc_icons_pulse.png")
            }else if(healthAssess.type == "Cholesterol"){
                
                cell.assessImage.image = UIImage(named:"lifedoc_icons_chol_new.png")
            }else if(healthAssess.type == "Body Temperature"){
                
                cell.assessImage.image = UIImage(named:"lifedoc_icons_body_temperature.png")
            }else if(healthAssess.type == "Blood Pressure"){
                
                cell.assessImage.image = UIImage(named:"lifedoc_icons_blood_pressure.png")
            }else if(healthAssess.type == "BMI"){
                
                cell.assessImage.image = UIImage(named:"lifedoc_icons_bmi.png")
            }else{
                cell.assessImage.image = UIImage(named:"purple_health_record.png")
                
            }
            
        }
        
        
        return cell
        
    }
    
    public func saveJSONNow(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "measurementValue")
        
        // here I save my JSON as a string
    }
    
    func buttonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        indexOfExpandedCell = buttonRow
        
        
        
        if(ShowMoreLess == "Show More"){
            shouldCellBeExpanded = true
            
            
            
            let indexPath = IndexPath(item: indexOfExpandedCell, section: 1)
            
            self.tableViewAssess.beginUpdates()
            self.tableViewAssess.reloadRows(at: [indexPath], with: .fade)
            self.tableViewAssess.endUpdates()
      
            
        }else{
            
            shouldCellBeExpanded = false
            
            
            let indexPath = IndexPath(item: indexOfExpandedCell, section: 1)
            
            self.tableViewAssess.beginUpdates()
            self.tableViewAssess.reloadRows(at: [indexPath], with: .fade)
            self.tableViewAssess.endUpdates()
        }
        
    }
    
    // [[self tableView] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfExpandedCell inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    // self.tableView.reloadRowsAtIndexPaths:(arrIndexPaths withRowAnimation:UITableViewRowAnimation.Fade)
    
    
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
        
        if(shouldCellBeExpanded && indexPath.row == indexOfExpandedCell && indexPath.section == 1){
            
            return 260 //Your desired height for the expanded cell
        }
        
        
        if(indexPath.section == 0){
            
            return 120
            
        }else{
            return 75
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    public func saveJSON(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "jsonHealthAssess")
        
        // here I save my JSON as a string
    }
    
    public func loadJSON() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "jsonHealthAssess") != nil){
            
            return JSON.parse(prefs.string(forKey: "jsonHealthAssess")!)
        }else{
            return nil
        }
        
    }
    
    
    private func gethealthAssessmentsHistory() {
        
        self.arrayHealthAssessment.removeAll()
        
          indexOfExpandedCell = -1
        
        let json = self.loadJSON()
        
        
        for item in json["assessments"].arrayValue {
            
            
            let healthAssess = HealthAssessment()
            healthAssess.id = item["id"].stringValue
            healthAssess.type = item["type"].stringValue
            healthAssess.count = item["count"].stringValue
            healthAssess.measurements = String(describing: item["events"].arrayValue)
            
            
            self.arrayHealthAssessment.append(healthAssess)
            
        }
        
        
        self.tableViewAssess?.reloadData()
        
    }
    
    
    public func gethealthAssessments() {
        
        // tell refresh control it can stop showing up now
        if (!self.refreshControl.isRefreshing){
            
            // get a reference to the app delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showActivityIndicator(uiView: self.view)
        }
        
        indexOfExpandedCell = -1
        
        let urlString: String
        
        
        urlString = Constants.baseURL + "healthAssessments/list"
        
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
        HealthAssessmentController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            //print(response)
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

                    
                    self.arrayHealthAssessment.removeAll()
                    
                    // tell refresh control it can stop showing up now
                    if self.refreshControl.isRefreshing
                    {
                        self.refreshControl.endRefreshing()
                    }
                    
                    
                    for item in json["assessments"].arrayValue {
                        
                        
                        let healthAssess = HealthAssessment()
                        healthAssess.id = item["id"].stringValue
                        healthAssess.type = item["type"].stringValue
                        healthAssess.count = item["count"].stringValue
                        healthAssess.measurements = String(describing: item["events"].arrayValue)
                        
                        
                        self.arrayHealthAssessment.append(healthAssess)
                        
                        
                    }
                    
                    self.tableViewAssess?.reloadData()
                    
                    
                    
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
                
            } else {
                
                // get a reference to the app delegate
                // let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //appDelegate.hideActivityIndicator(uiView: self.view)
                // self.showNetworkError()
                
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


class HealthAssessment {
    var id = ""
    var type = ""
    var count = ""
    var measurements = ""
    
    
    
}

