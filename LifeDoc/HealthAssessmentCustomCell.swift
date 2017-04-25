//
//  HealthAssessmentCustomCell.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/12/09.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Toast_Swift


class HealthAssessmentCustomCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate  {
    
    @IBOutlet weak var assessName: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var dragHandle: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var assessImage: UIImageView!
    @IBOutlet weak var showMoreAssess: UIButton!
    @IBOutlet weak var measurements: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpTable()
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "measurementValue")
    }
    
    
    func setUpTable()
    {
        tableView?.delegate = self
        tableView?.dataSource = self
        
    }
    
    var arrayHealthAssessmentMeasure = [HealthAssessmentMeasure]()
    var deletedList : Array<String> = Array()
    var hideList : Array<String> = Array()
    var messageStr : String = String()
    var indexOfChangedCell = -1
    var indexOfDeletedCell = -1
    var indexOfEditCell = -1
    let cellReuseIdentifier = "cellID"
    var hideRecord = false
    var hideRecordValue = false
    
    
    public func loadJSON() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "measurementValue") != nil){
            
            return JSON.parse(prefs.string(forKey: "measurementValue")!)
        }else{
            return nil
        }
        
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
            
            
            for (_, object) in json {
                
                hideList.append(object["id"].stringValue)
                
                deletedList.append(object["id"].stringValue)
                
            }
        }
        
        
    }
    
    
    func loadData(){
        
        let json = self.loadJSON()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "measurementValue") != nil){
            
            
            for (_, object) in json {
                
                let healthAssess = HealthAssessmentMeasure()
                healthAssess.id = object["id"].stringValue
                healthAssess.hide = object["_hide"].stringValue
                healthAssess.datetime = object["datetime"].stringValue
                
                healthAssess.individualMeasure = String(describing: object["measurements"].arrayValue)
                
                var finalStr = ""
                for item in object["measurements"].arrayValue {
                    //print(item["id"].stringValue)
                    let type = item["type"].stringValue
                    let unit = item["unit"].stringValue
                    let value = item["value"].stringValue
                    
                    if(finalStr == ""){
                        finalStr =  type + ": " + value + " " + unit
                    }else{
                        finalStr = finalStr + "\n" +  type + ": " + value + " " + unit
                    }
                    
                }
                
                
                healthAssess.measurements = finalStr
                self.arrayHealthAssessmentMeasure.append(healthAssess)
                
            }
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.arrayHealthAssessmentMeasure.removeAll()
        
        loadData()
        
        if(arrayHealthAssessmentMeasure.count > 0) {
            return arrayHealthAssessmentMeasure.count
        } else {
            return 0
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:AssessmentsCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AssessmentsCell
        
        let healthAssess = arrayHealthAssessmentMeasure[indexPath.row]
        
        cell.valueStr.text = healthAssess.measurements
        cell.date.text = healthAssess.datetime
        cell.recordId.text = healthAssess.individualMeasure
        cell.hiddenValue.text = healthAssess.hide
  
        if(indexPath.row == indexOfChangedCell)
        {
            hideList.removeAll()
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "singleMeasurement")
            
            let json = JSON(cell.recordId.text!)
            
            self.saveJSONNow(j: json)
            
            loadDataSingle()
       
            
            if(healthAssess.hide == "false"){
                let image = UIImage(named: "blue_hide") as UIImage?
                cell.hide.setBackgroundImage(image, for: .normal)
                hideRecordValue = true
                
            }else if (healthAssess.hide == "true"){
                let image = UIImage(named: "blue_unhide") as UIImage?
                cell.hide.setBackgroundImage(image, for: .normal)
                hideRecordValue = false
                
            }
            
            
        }
        
        
        if(indexPath.row == indexOfDeletedCell)
        {
            deletedList.removeAll()
            
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "singleMeasurement")
            
            let json = JSON(cell.recordId.text!)
            
            self.saveJSONNow(j: json)
            
            loadDataSingle()
            
            
        }
        
        
        if(indexPath.row == indexOfEditCell)
        {
            
            
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "singleMeasurement")
            
            let hidden = cell.hiddenValue.text!
            let date = cell.date.text!
            
            prefs.set(hidden, forKey: "isHiddenValue")
            prefs.set(date, forKey: "dateValue")
            
            let json = JSON(cell.recordId.text!)
            
            self.saveJSONNow(j: json)
            
            
            
        }
        
        
        if(healthAssess.hide == "false"){
            let image = UIImage(named: "blue_unhide") as UIImage?
            cell.hide.setBackgroundImage(image, for: .normal)
            
        }else if (healthAssess.hide == "true"){
            let image = UIImage(named: "blue_hide") as UIImage?
            cell.hide.setBackgroundImage(image, for: .normal)
            
        }
        

        
        
        cell.edit.tag = indexPath.row
        
        cell.edit.addTarget(self,action:#selector(self.buttonEditClicked), for: .touchUpInside)
        
        cell.hide.tag = indexPath.row
        
        cell.hide.addTarget(self,action:#selector(self.buttonHideClicked), for: .touchUpInside)
        
        cell.more.tag = indexPath.row
        
        cell.more.addTarget(self,action:#selector(self.buttonMoreClicked), for: .touchUpInside)
        
        
        return cell
    }
    
    
    
    public func saveJSONNow(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "singleMeasurement")
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 90
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    func buttonEditClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        indexOfEditCell = buttonRow
        print("Edit clicked")
        
        
        
        let indexPath = IndexPath(item: indexOfEditCell, section: 0)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        self.tableView.endUpdates()
        
        
        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
        
        let prefs = UserDefaults.standard
        var typeOf = ""
        if (prefs.string(forKey: "AssessmentType") != nil){
            
            typeOf = prefs.string(forKey: "AssessmentType")!
            
        }
        
        
        let cholesterolController: CholesterolController = {
            return UIStoryboard.viewController(identifier: "CholesterolController") as! CholesterolController
        }()
        let weightContoller: WeightContoller = {
            return UIStoryboard.viewController(identifier: "WeightContoller") as! WeightContoller
        }()
        let pulseContoller: PulseContoller = {
            return UIStoryboard.viewController(identifier: "PulseContoller") as! PulseContoller
        }()
        
        let heightContoller: HeightContoller = {
            return UIStoryboard.viewController(identifier: "HeightContoller") as! HeightContoller
        }()
        
        let bodyTempContoller: BodyTempContoller = {
            return UIStoryboard.viewController(identifier: "BodyTempContoller") as! BodyTempContoller
        }()
        
        
        let bmiController: BmiController = {
            return UIStoryboard.viewController(identifier: "BmiController") as! BmiController
        }()
        
        let bloodGlucoseContoller: BloodGlucoseContoller = {
            return UIStoryboard.viewController(identifier: "BloodGlucoseContoller") as! BloodGlucoseContoller
        }()
        
        let bloodPresssureContoller: BloodPresssureContoller = {
            return UIStoryboard.viewController(identifier: "BloodPresssureContoller") as! BloodPresssureContoller
        }()
        
        
        if(typeOf == "Cholesterol"){
            self.window?.rootViewController?.present(cholesterolController, animated: false, completion: nil)
        }
        if(typeOf == "Weight"){
            self.window?.rootViewController?.present(weightContoller, animated: false, completion: nil)
        }
        
        if(typeOf == "Pulse"){
            self.window?.rootViewController?.present(pulseContoller, animated: false, completion: nil)
        }
        
        if(typeOf == "Height"){
            self.window?.rootViewController?.present(heightContoller, animated: false, completion: nil)
        }
        
        if(typeOf == "Body Temperature"){
            self.window?.rootViewController?.present(bodyTempContoller, animated: false, completion: nil)
        }
        
        if(typeOf == "BMI"){
            self.window?.rootViewController?.present(bmiController, animated: false, completion: nil)
        }
        
        if(typeOf == "Blood Glucose"){
            self.window?.rootViewController?.present(bloodGlucoseContoller, animated: false, completion: nil)
        }
        
        if(typeOf == "Blood Pressure"){
            self.window?.rootViewController?.present(bloodPresssureContoller, animated: false, completion: nil)
        }
        
        
        
        
    }
    
    
    func buttonHideClicked(sender:UIButton) {
        
        
        let buttonRow = sender.tag
        indexOfChangedCell = buttonRow
        
        let indexPath = IndexPath(item: indexOfChangedCell, section: 0)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        self.tableView.endUpdates()
        
        self.hideUnhideRecord()
        
        
        
        
        
    }
    
    func buttonMoreClicked(sender:UIButton) {
        
        
        print("More clicked")
        
        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
        
        let optionMenu = UIAlertController(title: nil, message: "More Options", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            let buttonRow = sender.tag
            self.indexOfDeletedCell = buttonRow
            
            
            let indexPath = IndexPath(item: self.indexOfDeletedCell, section: 0)
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
            
            self.showAreYouSure()
            
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.window?.rootViewController?.present(optionMenu, animated: true, completion: nil)
        
        
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
        self.window?.rootViewController?.present(ac, animated: true)
    }
    
    
    private func deleteRecord() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
        
        
        self.window!.rootViewController?.view.makeToast("Deleting record...", duration: 3.0, position: .bottom)
        
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
        
        HealthAssessmentCustomCell.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                
                if status == "SUCCESS"{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    appDelegate.gethealthAssessments()
                    
                    
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
                
                
                
            }
        }
        
        
    }
    
    
    private func hideUnhideRecord() {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
        
        
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
            "recordType": "HEALTHASSESSMENT",
            "_hide": hideRecordValue
            
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        HealthAssessmentCustomCell.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                if status == "SUCCESS"{
                    
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    appDelegate.gethealthAssessments()
                    
                    
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
    
    
}
