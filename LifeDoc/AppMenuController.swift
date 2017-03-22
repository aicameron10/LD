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

class AppMenuController: MenuController {
    internal let baseSize = CGSize(width: 56, height: 56)
    internal let bottomInset: CGFloat = 24
    internal let rightInset: CGFloat = 24
    
    internal var addButton: FabButton!
    internal var OTPMenuItem: MenuItem!
    internal var recordMenuItem: MenuItem!
    
    open override func prepare() {
        super.prepare()
        view.backgroundColor = Color.blueGrey.lighten5
        
        // Menu.
        prepareAddButton()
        prepareOTPButton()
        prepareRecordButton()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareMenu()
    }
}

/// Menu.
extension AppMenuController {
    open override func openMenu(completion: ((UIView) -> Void)? = nil) {
        super.openMenu(completion: completion)
        menu.views.first?.animate(animation: Motion.rotate(angle: 45))
    }
    
    open override func closeMenu(completion: ((UIView) -> Void)? = nil) {
        super.closeMenu(completion: completion)
        menu.views.first?.animate(animation: Motion.rotate(angle: 0))
    }
    
    /// Handle the menu toggle event.
    internal func handleToggleMenu(button: Button) {
        guard let mc = menuController as? AppMenuController else {
            return
        }
        
        if mc.menu.isOpened {
            mc.closeMenu { (view) in
                (view as? MenuItem)?.hideTitleLabel()
            }
        } else {
            mc.openMenu { (view) in
                (view as? MenuItem)?.showTitleLabel()
            }
        }
    }
    
    
    /// Handle the menu toggle event.
    internal func handleOTP(button: Button) {
        
        closeMenu()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.generateOTP()
    }
    
    /// Handle the menu toggle event.
    internal func handleSelect(button: Button) {
        
        closeMenu()
        
        let selectContoller: SelectContoller = {
            return UIStoryboard.viewController(identifier: "SelectContoller") as! SelectContoller
        }()
        
        
        self.present(selectContoller, animated: true, completion: nil)
    }
    
    
    
    
    internal func prepareAddButton() {
        addButton = FabButton(image: Icon.cm.add, tintColor: .white)
        addButton.pulseColor = .white
        addButton.backgroundColor = UIColor(red: 0/255, green: 149/255, blue: 217/255, alpha: 1.0)
        
        
        addButton.addTarget(self, action: #selector(handleToggleMenu), for: .touchUpInside)
    }
    
    internal func prepareOTPButton() {
        
        let imageotp : UIImage = UIImage(named:"ic_otp_sub")!
        OTPMenuItem = MenuItem()
        OTPMenuItem.button.image = imageotp
        OTPMenuItem.button.tintColor = .white
        OTPMenuItem.button.pulseColor = .white
        OTPMenuItem.button.backgroundColor = UIColor(red: 0/255, green: 157/255, blue: 78/255, alpha: 1.0)
        OTPMenuItem.button.depthPreset = .depth1
        OTPMenuItem.title = "OTP"
        
        OTPMenuItem.button.addTarget(self, action: #selector(handleOTP), for: .touchUpInside)
        
    }
    
    internal func prepareRecordButton() {
        recordMenuItem = MenuItem()
        recordMenuItem.button.image = Icon.cm.add
        recordMenuItem.button.tintColor = .white
        recordMenuItem.button.pulseColor = .white
        recordMenuItem.button.backgroundColor = UIColor(red: 217/255, green: 42/255, blue: 24/255, alpha: 1.0)
        recordMenuItem.title = "Add record"
        
        
        recordMenuItem.button.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
    }
    
    internal func prepareMenu() {
        view.layout(menu)
            .size(baseSize)
            .bottom(bottomInset)
            .right(rightInset)
        
        menu.delegate = self
        menu.baseSize = baseSize
        menu.views = [addButton, OTPMenuItem, recordMenuItem]
    }
}

/// MenuDelegate.
extension AppMenuController: MenuDelegate {
    func menu(menu: Menu, tappedAt point: CGPoint, isOutside: Bool) {
        guard isOutside else {
            return
        }
        
        guard let mc = menuController as? AppMenuController else {
            return
        }
        
        mc.closeMenu { (view) in
            (view as? MenuItem)?.hideTitleLabel()
        }
    }
}
