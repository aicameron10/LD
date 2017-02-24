//
//  RecordsCustomCell.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/01/19.
//  Copyright © 2017 MediSwitch. All rights reserved.
//

import Foundation
import UIKit

class RecordsCustomCell: UITableViewCell {
    
    @IBOutlet weak var recordId: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var dateStr: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hide: UIButton!
    @IBOutlet weak var values: UILabel!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var hiddenValue: UILabel!
   
    @IBOutlet weak var pos: UILabel!
   
}
