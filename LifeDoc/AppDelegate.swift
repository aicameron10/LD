//
//  AppDelegate.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/08.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire
import FileExplorer
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var add : Array<String> = Array()
    
    var messageStr : String = String()
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    lazy var rootViewController: RootViewController = {
        return UIStoryboard.viewController(identifier: "RootViewController") as! RootViewController
    }()
    
    lazy var leftViewController: LeftViewController = {
        return UIStoryboard.viewController(identifier: "LeftViewController") as! LeftViewController
    }()
    
    lazy var rightViewController: RightViewController = {
        return UIStoryboard.viewController(identifier: "RightViewController") as! RightViewController
    }()
    
    
    lazy var profileListViewController: ProfileListViewController = {
        return UIStoryboard.viewController(identifier: "ProfileListViewController") as! ProfileListViewController
    }()
    
    lazy var healthAssessmentController: HealthAssessmentController = {
        return UIStoryboard.viewController(identifier: "HealthAssessmentController") as! HealthAssessmentController
    }()
    
    lazy var healthProfileController: HealthProfileController = {
        return UIStoryboard.viewController(identifier: "HealthProfileController") as! HealthProfileController
    }()
    
    lazy var pageViewController: PageViewController = {
        return UIStoryboard.viewController(identifier: "PageViewController") as! PageViewController
    }()
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "SegoePrint", size: 20)!]
        
        
        
        //application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        //UIFont.familyNames.sorted().forEach({print($0)})
        
        let prefs = UserDefaults.standard
        
        prefs.removeObject(forKey: "savedOrderProfile")
        //prefs.removeObject(forKey: "savedOrder")
        prefs.removeObject(forKey: "savedServerMessage")
        
        
        
        
        mainViewLoad()
        
        
        
        
        return true
    }
    
    
    func mainView() {
        
        let prefs = UserDefaults.standard
        
        prefs.removeObject(forKey: "savedServerMessage")
        
        
        self.checkTerms()
        self.checkAuthToken()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginFirst"), object: nil)
        
        
        setStatusBarBackgroundColor(color: UIColor(red: 1/255, green: 139/255, blue: 197/255, alpha: 1.0))
        
        let pageTabBarController = AppPageTabBarController(viewControllers: [healthProfileController, healthAssessmentController, profileListViewController], selectedIndex: 0)
        let toolbarController = AppToolbarController(rootViewController: pageTabBarController)
        let menuController = AppMenuController(rootViewController: toolbarController)
        
        let navigationController  = AppNavigationDrawerController(rootViewController: menuController, leftViewController: leftViewController,rightViewController: rightViewController)
        let statusController = AppStatusBarController(rootViewController: navigationController)
        
        window = UIWindow(frame: Screen.bounds)
        
        window!.rootViewController = statusController
        
        window!.makeKeyAndVisible()
        
        
        
    }
    
    func mainViewLoad() {
        
        
        setStatusBarBackgroundColor(color: UIColor(red: 1/255, green: 139/255, blue: 197/255, alpha: 1.0))
        
        let prefs = UserDefaults.standard
        window = UIWindow(frame: Screen.bounds)
        
        if (prefs.string(forKey: "userloggedin") != nil) && (prefs.string(forKey: "userloggedin")?.contains("true"))! {
            
            let pageTabBarController = AppPageTabBarController(viewControllers: [healthProfileController, healthAssessmentController, profileListViewController], selectedIndex: 0)
            let toolbarController = AppToolbarController(rootViewController: pageTabBarController)
            let menuController = AppMenuController(rootViewController: toolbarController)
            
            let navigationController  = AppNavigationDrawerController(rootViewController: menuController, leftViewController: leftViewController,rightViewController: rightViewController)
            let statusController = AppStatusBarController(rootViewController: navigationController)
            
            window!.rootViewController = statusController
        }else{
            window!.rootViewController = pageViewController
        }
        
        
        window!.makeKeyAndVisible()
        
        
    }
    
    func logOutScreen() {
        
        setStatusBarBackgroundColor(color: UIColor(red: 1/255, green: 139/255, blue: 197/255, alpha: 1.0))
        
        self.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        window = UIWindow(frame: Screen.bounds)
        
        window!.rootViewController = pageViewController
        
        window!.makeKeyAndVisible()
        
    }
    
    func dismissSelect() {
        
        let selectContoller: SelectContoller = {
            return UIStoryboard.viewController(identifier: "SelectContoller") as! SelectContoller
        }()
        selectContoller.dismiss(animated: true, completion: nil)
        
        
    }
    
    func showToast(){
        
        
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "savedServerMessage") != nil){
            
            self.window!.rootViewController?.view.makeToast(prefs.string(forKey: "savedServerMessage")!, duration: 5.0, position: .center)
            
            
        }
        
    }
    
    
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    public func saveJSON(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "jsonHealthAssess")
        
        // here I save my JSON as a string
    }
    
    public func saveJSONProfile(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "jsonHealthProfile")
        
        // here I save my JSON as a string
    }
    
    
    private func showShare(){
        
        let prefs = UserDefaults.standard
        var msg = ""
        if (prefs.string(forKey: "savedServerMessage") != nil){
            
            msg = prefs.string(forKey: "savedServerMessage")!
            
        }
        
        let ac = UIAlertController(title: "Generate OTP", message: msg, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default)
        { action -> Void in
            
        })
        ac.addAction(UIAlertAction(title: "Share", style: UIAlertActionStyle.default)
        { action -> Void in
            self.shareNow()
        })
        self.window!.rootViewController?.present(ac, animated: true)
        
    }
    
    
    private func showTerms(){
        
        
        let msg = Constants.msg_lifedoc_terms
        
        
        let ac = UIAlertController(title: "Terms and Conditions", message: msg, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "View T&C's", style: UIAlertActionStyle.default)
        { action -> Void in
            let terms: TermsCheckController = {
                return UIStoryboard.viewController(identifier: "TermsCheckController") as! TermsCheckController
            }()
            
            
            
            self.window!.rootViewController?.present(terms, animated: true)
        })
        
        
        ac.addAction(UIAlertAction(title: "Decline", style: UIAlertActionStyle.default)
        { action -> Void in
            self.logOut()
        })
        ac.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default)
        { action -> Void in
            self.acceptTermsConditions()
        })
        
        
        
        self.window!.rootViewController?.present(ac, animated: true)
        
    }
    
    
    
    
    
    private func shareNow(){
        // text to share
        let prefs = UserDefaults.standard
        var msg = ""
        if (prefs.string(forKey: "savedServerMessage") != nil){
            
            msg = prefs.string(forKey: "savedServerMessage")!
            
        }
        
        
        // set up activity view controller
        let textToShare = [ msg ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.window!.rootViewController?.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        
        // present the view controller
        self.window!.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    
    public func generateOTP() {
        
        self.showActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
        let urlString: String
        
        urlString = Constants.baseURL + "generateOTP"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        add.append(String(currentActiveUserDetailsId))
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "phoneNumber": "",
            "onceOffNumber": "",
            "userIds": add
            
        ]
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        AppDelegate.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            print(response)
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(json)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                let msg = json["message"].string!
                
                
                if status == "SUCCESS"{
                    
                    let prefs = UserDefaults.standard
                    prefs.set(msg, forKey: "savedServerMessage")
                    self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                    self.showShare()
                    
                    
                }else{
                    self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
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
                self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                
            }
            
        }
        
        
    }
    
    
    public func gethealthProfile() {
        
        
        // get a reference to the app delegate
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.showActivityIndicator(uiView: self.view)
        
        
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
        AppDelegate.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            //print(response)
            
            
            
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                let records = json["records"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                if(records.isEmpty){
                    
                    let prefs = UserDefaults.standard
                    
                    prefs.removeObject(forKey: "jsonHealthProfile")
                    prefs.removeObject(forKey: "savedOrderProfile")
                    self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                    self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showNoDataLabel"), object: nil)
                    
                }else{
                    
                    if status == "SUCCESS"{
                        
                        
                        let responseJSON = response.result.value
                        
                        if(responseJSON != nil){
                            let json1 = JSON(responseJSON as Any)
                            
                            self.saveJSONProfile(j: json1)
                        }
                        
                        
                        self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                        self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableProfileHistory"), object: nil)
                        
                        
                        let prefs = UserDefaults.standard
                        
                        if (prefs.string(forKey: "savedServerMessage") != nil){
                            
                            self.window!.rootViewController?.view.makeToast(prefs.string(forKey: "savedServerMessage")!, duration: 5.0, position: .bottom)
                        }
                        
                        
                    }else{
                        self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                        self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        self.showError()
                    }
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
                self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                self.showNetworkError()
            } else {
                
                // get a reference to the app delegate
                // let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //appDelegate.hideActivityIndicator(uiView: self.view)
                // self.showNetworkError()
                
            }
        }
        
        
    }
    
    
    
    public func gethealthAssessments() {
        
        
        
        let urlString: String
        
        
        urlString = Constants.baseURL + "healthAssessments/list"
        
        
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
        AppDelegate.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
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
                let assessments = json["assessments"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                if(assessments.isEmpty){
                    
                    let prefs = UserDefaults.standard
                    
                    prefs.removeObject(forKey: "jsonHealthAssess")
                    prefs.removeObject(forKey: "savedOrder")
                    self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                    self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showNoDataLabelAssess"), object: nil)
                    
                }else{
                    
                    if status == "SUCCESS"{
                        
                        self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                        self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableHistory"), object: nil)
                        
                        
                        let prefs = UserDefaults.standard
                        
                        if (prefs.string(forKey: "savedServerMessage") != nil){
                            
                            self.window!.rootViewController?.view.makeToast(prefs.string(forKey: "savedServerMessage")!, duration: 5.0, position: .bottom)
                            
                            
                        }
                        
                        
                        
                        
                    }else{
                        
                        self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                        self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        self.showError()
                        
                    }
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
                self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                self.showNetworkError()
                
            } else {
                
                // get a reference to the app delegate
                // let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //appDelegate.hideActivityIndicator(uiView: self.view)
                // self.showNetworkError()
                
            }
        }
        
        
    }
    
    public func checkTerms() {
        
        
        
        let urlString: String
        
        
        urlString = Constants.baseURL + "checkTermsConditions"
        
        
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
        AppDelegate.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                let value = json["value"].bool!
                
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    
                    if (value == false) {
                        
                        self.showTerms()
                    }
                    
                    
                    
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
                self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                self.showNetworkError()
                
            }
        }
        
        
    }
    
    
    public func acceptTermsConditions() {
        
        
        
        let urlString: String
        
        
        urlString = Constants.baseURL + "acceptTermsConditions"
        
        
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
        AppDelegate.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    
                    self.window!.rootViewController?.view.makeToast(self.messageStr, duration: 3.0, position: .bottom)
                    
                }else{
                    self.window!.rootViewController?.view.makeToast(self.messageStr, duration: 3.0, position: .bottom)
                    self.checkTerms()
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
                self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                self.showNetworkError()
                
            }
        }
        
        
    }
    
    
    public func checkAuthToken() {
        
        
        
        let urlString: String
        
        
        urlString = Constants.baseURL + "checkAuthToken"
        
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        let authToken = prefs.string(forKey: "authToken")
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "authToken": authToken as Any
            
        ]
        
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        AppDelegate.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                let value = json["value"].bool!
                
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    
                    if (value == false) {
                        //logout
                        self.logOut()
                    }
                    
                    
                    
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
                self.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
                self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                self.showNetworkError()
                
            }
        }
        
        
    }
    
    
    private func logOut() {
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "userloggedin")
        prefs.removeObject(forKey: "jsonHealthAssess")
        prefs.removeObject(forKey: "jsonHealthProfile")
        prefs.removeObject(forKey: "savedOrder")
        prefs.removeObject(forKey: "savedOrderProfile")
        prefs.removeObject(forKey: "savedServerMessage")
        prefs.removeObject(forKey: "attachBase64Profile")
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "logout"
        
        print(urlString)
        
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        let authToken = prefs.string(forKey: "authToken")
        
        let parameters: Parameters = [
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "currentActiveUserDetailsId": currentActiveUserDetailsId
            
        ]
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        Networking().ldmgw(urlString: urlString, parameters: parameters, headers: headers){
            jsonResponse in
            
            var json = JSON(jsonResponse!)
            let status = json["status"]
            let msg = json["message"].string!
            
            if status == "SUCCESS"{
                
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let prefs = UserDefaults.standard
                prefs.set(msg, forKey: "savedServerMessage")
                
                appDelegate.logOutScreen()
                appDelegate.showToast()
                
            }
            
        }
        
    }
    
    
    
    func showNetworkError() {
        let ac = UIAlertController(title: "Error", message:  "Your device is unable to connect,  Please check your device internet settings or contact 0800 695 433 (0800 My Life) for further assistance", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.window!.rootViewController?.present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Error", message: messageStr, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.window!.rootViewController?.present(ac, animated: true)
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


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}
public extension Array {
    mutating func swap(ind1: Int, _ ind2: Int){
        var temp: Element
        temp = self[ind1]
        self[ind1] = self[ind2]
        self[ind2] = temp
    }
}

public extension Array {
    mutating func rearrange(from: Int, to: Int) {
        
        insert(remove(at: from), at: to)
        
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x:0, y:0, width:self.size.width, height:self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
}

extension String {
    
    func fileName() -> String {
        
        if let fileNameWithoutExtension = NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent {
            return fileNameWithoutExtension
        } else {
            return ""
        }
    }
    
    func fileExtension() -> String {
        
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        } else {
            return ""
        }
    }
}

extension UIStoryboard {
    class func viewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

extension NSURLRequest {
    static func allowsAnyHTTPSCertificateForHost(host: String) -> Bool {
        return true
    }
}
