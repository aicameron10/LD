//
//  RightViewController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/15.
//  Copyright © 2016 MediSwitch. All rights reserved.
//
import UIKit
import Material
import Alamofire


class RightViewController: UIViewController {
    
    
    @IBOutlet weak var healthAssessments: FlatButton!
    @IBOutlet weak var termsButton: FlatButton!
    @IBOutlet weak var logoutButton: FlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        prepareTermsButton()
        prepareLogoutButton()
        preparehealthAssessments()
    }
    
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
    
    
    @objc
    internal func handleTermsButton() {
        navigationDrawerController?.closeRightView()
        let terms: TermsViewController = {
            return UIStoryboard.viewController(identifier: "TermsViewController") as! TermsViewController
        }()
        
        
        self.present(terms, animated: true, completion: nil)
        
    }
    
    @objc
    internal func handlehealth() {
        
        let pageTabBarController = AppPageTabBarController(viewControllers: [healthProfileController, healthAssessmentController, profileListViewController], selectedIndex: 1)
        let toolbarController = AppToolbarController(rootViewController: pageTabBarController)
        let menuController = AppMenuController(rootViewController: toolbarController)
        
        let navigationController  = AppNavigationDrawerController(rootViewController: menuController, leftViewController: leftViewController,rightViewController: rightViewController)
        let statusController = AppStatusBarController(rootViewController: navigationController)
        
        navigationDrawerController?.closeRightView()
        
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        UIApplication.shared.keyWindow?.rootViewController = statusController
        
        //self.present((rootViewController: statusController),animated: false)
        
    }
    
    
    @objc
    internal func handleLogoutButton() {
        // Transition the entire NavigationDrawer rootViewController.
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "userloggedin")
        prefs.removeObject(forKey: "jsonHealthAssess")
        prefs.removeObject(forKey: "jsonHealthProfile")
        prefs.removeObject(forKey: "savedOrder")
        prefs.removeObject(forKey: "savedOrderProfile")
        prefs.removeObject(forKey: "savedServerMessage")
        prefs.removeObject(forKey: "attachBase64Profile")
        
        
        
        logOut()
        
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        
        
        //UIApplication.shared.keyWindow?.rootViewController = pageViewController
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logOutScreen()
        
        //navigationDrawerController?.transition(to: TransitionedViewController(), completion: closeNavigationDrawer)
        
        
    }
    
    
    
    internal func closeNavigationDrawer(result: Bool) {
        navigationDrawerController?.closeRightView()
    }
    
    private func prepareTermsButton() {
        
        termsButton.addTarget(self, action: #selector(handleTermsButton), for: .touchUpInside)
        
        //view.layout(termsButton).horizontally().center()
    }
    
    private func preparehealthAssessments() {
        
        healthAssessments.addTarget(self, action: #selector(handlehealth), for: .touchUpInside)
        
    }
    
    private func prepareLogoutButton() {
        
        logoutButton.addTarget(self, action: #selector(handleLogoutButton), for: .touchUpInside)
        //view.layout(logoutButton).horizontally().center()
    }
    
    private func logOut() {
        
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "logout"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
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
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        RightViewController.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                
                var json = JSON(jsonResponse)
                let status = json["status"]
                let msg = json["message"].string!
                
                if status == "SUCCESS"{
                    
                    let prefs = UserDefaults.standard
                    prefs.set(msg, forKey: "savedServerMessage")
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.showToast()
                    
                    
                }else{
                    
                    
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
    
    func showNetworkError() {
        let ac = UIAlertController(title: "Error", message:  "Your device is unable to connect,  Please check your device internet settings or contact 0800 695 433 (0800 My Life) for further assistance", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
}
