//
//  RootViewController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/15.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material

class RootViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        prepareToolbar()
    }
    
    private func prepareToolbar() {
        guard let toolbar = toolbarController?.toolbar else {
            return
        }
        
        toolbar.title = "LifeDoc"
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .left
        
    }
    
}
