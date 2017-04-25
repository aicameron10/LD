//
//  LeftViewController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/15.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material

class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tableViewSide: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    private var transitionButton: FlatButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = Color.blue.base
        view.backgroundColor = Color.white
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "firstName") != nil){
            
            welcomeLabel.text = "Welcome " + prefs.string(forKey: "firstName")! + " " + prefs.string(forKey: "lastName")!
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadProfilePic), name: NSNotification.Name(rawValue: "loadMyPic"), object: nil)
        prepareProfilePic()
        
    }
    
    
    private func prepareProfilePic() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer)
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
        profilePic.clipsToBounds = true
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "attachBase64Profile") != nil){
            
            let image = prefs.string(forKey: "attachBase64Profile")
            
            let dataDecoded : Data = Data(base64Encoded: image!, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            profilePic.image = decodedimage?.fixOrientation()
        }else{
            
            profilePic.image = UIImage(named: "blue_camera.png")
        }
        
    }
    
    func loadProfilePic(notification: NSNotification){
        //load data here
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "attachBase64Profile") != nil) {
            
            let image = prefs.string(forKey: "attachBase64Profile")
            
            let dataDecoded : Data = Data(base64Encoded: image!, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            let size = CGSize(width:65, height:65)
            let resizeImg = resizeImage(image: decodedimage!, newSize: size)
            
            self.profilePic.image = resizeImg.fixOrientation()
            
            
        }
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
    
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        
        navigationDrawerController?.closeLeftView()
        let profile: ProfileController = {
            return UIStoryboard.viewController(identifier: "ProfileController") as! ProfileController
        }()
        
        
        self.present(profile, animated: true, completion: nil)
        
        
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
    
    
    
    
    
    var textNames = ["Health Profile", "Health Assessments", "My Profile", "Change Password"]
    var textNames1 = ["Generate OTP"]
    
    var pics = ["ic_profile_health.png", "ic_assess_health_bar.png", "ic_profile_side.png", "ic_change_password.png"]
    var pics1 = ["ic_otp_side.png"]
    
    internal func closeNavigationDrawer(result: Bool) {
        navigationDrawerController?.closeLeftView()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 0) {
            return ""
        } else {
            return "Communicate"
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if (section == 0) {
            return 4; //However many static cells you want
        } else {
            return 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = SideCustomCell()
        
        
        
        cell = tableView.dequeueReusableCell(withIdentifier: "sideCell", for: indexPath) as! SideCustomCell
        
        if(indexPath.section == 0){
            cell.textStr.text = textNames[indexPath.row]
            
            cell.pic.image = UIImage(named:pics[indexPath.row])
            
        }
        if (indexPath.section == 1){
            
            cell.textStr.text = textNames1[indexPath.row]
            
            cell.pic.image = UIImage(named:pics1[indexPath.row])
            
            
        }
        
        
        
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if(indexPath.section == 0 && indexPath.row == 0){
            let pageTabBarController = AppPageTabBarController(viewControllers: [healthProfileController, healthAssessmentController, profileListViewController], selectedIndex: 0)
            let toolbarController = AppToolbarController(rootViewController: pageTabBarController)
            let menuController = AppMenuController(rootViewController: toolbarController)
            
            let navigationController  = AppNavigationDrawerController(rootViewController: menuController, leftViewController: leftViewController,rightViewController: rightViewController)
            let statusController = AppStatusBarController(rootViewController: navigationController)
            
            navigationDrawerController?.closeLeftView()
            
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
            UIApplication.shared.keyWindow?.rootViewController = statusController
            //self.present((rootViewController: statusController),animated: false)
            
        }else if(indexPath.section == 0 && indexPath.row == 1){
            
            let pageTabBarController = AppPageTabBarController(viewControllers: [healthProfileController, healthAssessmentController, profileListViewController], selectedIndex: 1)
            let toolbarController = AppToolbarController(rootViewController: pageTabBarController)
            let menuController = AppMenuController(rootViewController: toolbarController)
            
            let navigationController  = AppNavigationDrawerController(rootViewController: menuController, leftViewController: leftViewController,rightViewController: rightViewController)
            let statusController = AppStatusBarController(rootViewController: navigationController)
            
            navigationDrawerController?.closeLeftView()
            
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
            UIApplication.shared.keyWindow?.rootViewController = statusController
            //self.present((rootViewController: statusController),animated: false)
            
        }else if(indexPath.section == 0 && indexPath.row == 2){
            
            let pageTabBarController = AppPageTabBarController(viewControllers: [healthProfileController, healthAssessmentController, profileListViewController], selectedIndex: 2)
            let toolbarController = AppToolbarController(rootViewController: pageTabBarController)
            let menuController = AppMenuController(rootViewController: toolbarController)
            
            let navigationController  = AppNavigationDrawerController(rootViewController: menuController, leftViewController: leftViewController,rightViewController: rightViewController)
            let statusController = AppStatusBarController(rootViewController: navigationController)
            
            navigationDrawerController?.closeLeftView()
            
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
            UIApplication.shared.keyWindow?.rootViewController = statusController
            //self.present((rootViewController: statusController),animated: false)
            
        }
            
        else if(indexPath.section == 0 && indexPath.row == 3){
            
            navigationDrawerController?.closeLeftView()
            let change: ChangePasswordController = {
                return UIStoryboard.viewController(identifier: "ChangePasswordController") as! ChangePasswordController
            }()
            
            
            self.present(change, animated: true, completion: nil)
        }
        else if(indexPath.section == 1 && indexPath.row == 0){
            
            print("Generate OTP")
            
            navigationDrawerController?.closeLeftView()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.generateOTP()
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if(indexPath.section == 0){
            
            return 45
            
        }else{
            return 45
        }
        
        
    }
    
    
}
