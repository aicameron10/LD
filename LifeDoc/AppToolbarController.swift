/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material


class AppToolbarController: ToolbarController {
    private var menuButton: IconButton!
    private var HealthButton: IconButton!
    private var searchButton: IconButton!
    
    open override func prepare() {
        super.prepare()
        prepareMenuButton()
        prepareHealthRecordsButton()
        prepareSearchButton()
        prepareToolbar()
    }
    
   
    
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
    internal func handleMenuButton() {
        navigationDrawerController?.toggleLeftView()
    }
    
    @objc
    internal func handleMoreButton() {
        navigationDrawerController?.toggleRightView()
    }
    
    @objc
    internal func handleHealthRecordsButton() {
        
        let pageTabBarController = AppPageTabBarController(viewControllers: [healthProfileController, healthAssessmentController, profileListViewController], selectedIndex: 0)
        let toolbarController = AppToolbarController(rootViewController: pageTabBarController)
        let menuController = AppMenuController(rootViewController: toolbarController)
        
        let navigationController  = AppNavigationDrawerController(rootViewController: menuController, leftViewController: leftViewController,rightViewController: rightViewController)
        let statusController = AppStatusBarController(rootViewController: navigationController)
        
         self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        UIApplication.shared.keyWindow?.rootViewController = statusController
        
        //self.present((rootViewController: statusController),animated: false)
 
        
    }
    

    
    private func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu, tintColor: .white)
        menuButton.pulseColor = .white
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
    }
    
    private func prepareHealthRecordsButton() {
        HealthButton = IconButton(image: #imageLiteral(resourceName: "ic_profile_health_bar.png"), tintColor: .white)
        HealthButton.pulseColor = .white
        
        HealthButton.addTarget(self, action: #selector(handleHealthRecordsButton), for: .touchUpInside)
    }
    
    private func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.moreVertical, tintColor: .white)
        searchButton.pulseColor = .white
        searchButton.addTarget(self, action: #selector(handleMoreButton), for: .touchUpInside)
    }
    
    
    
    
    private func prepareToolbar() {
        toolbar.depthPreset = .none
        toolbar.backgroundColor = UIColor(red: 0/255, green: 153.0/255, blue: 217.0/255, alpha: 1.0)
        
        
    
        toolbar.title = "LifeDoc"
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .left
        toolbar.titleLabel.font = UIFont(name: "SegoePrint", size: 20)
        
        
        toolbar.leftViews = [menuButton]
        toolbar.rightViews = [HealthButton, searchButton]
    }
}

