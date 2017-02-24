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

class ProfileListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        preparePageTabBarItem()
    }
    
        var textNames = ["Personal Details"]
    
    @IBOutlet weak var tableViewProfile: UITableView!
    init() {
        super.init(nibName: nil, bundle: nil)
        preparePageTabBarItem()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func preparePageTabBarItem() {
        //pageTabBarItem.title = "My Profile"
        //pageTabBarItem.titleColor = Color.white
        
        let myString = "Profile"
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
                                        length:7))
        
        pageTabBarItem.setAttributedTitle(myMutableString, for: UIControlState.normal)
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
            return 1; //However many static cells you want
       
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = PersonalCustomCell()
        
        
        
        cell = tableViewProfile.dequeueReusableCell(withIdentifier: "cellProfile", for: indexPath) as! PersonalCustomCell
        
       
        cell.textStr.text = textNames[indexPath.row]
            
       
    
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if(indexPath.section == 0 && indexPath.row == 0){
           print("Clicked me")
            
            let profile: ProfileController = {
                return UIStoryboard.viewController(identifier: "ProfileController") as! ProfileController
            }()
            
            self.present(profile, animated: false, completion: nil)
            
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

