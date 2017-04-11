//
//  HealthProfileCustomCell.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/12/09.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import Foundation
import UIKit
class HealthProfileCustomCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var subRecords: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateStr: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var tableViewSubs: UITableView!
    @IBOutlet weak var dragHandle: UIButton!
    @IBOutlet weak var imagepic: UIImageView!
    @IBOutlet weak var hiddenValue: UILabel!
    @IBOutlet weak var showMore: UIButton!
    @IBOutlet weak var recordId: UILabel!
    @IBOutlet weak var more: UIButton!
    @IBOutlet weak var hide: UIButton!
    @IBOutlet weak var edit: UIButton!
    
    
    var indexOfTouchCell = -1
    
    var arraySubs = [SubsCount]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTable()
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "recordSubs")
    }
    
    
    public func loadJSON() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "recordSubs") != nil){
            
            return JSON.parse(prefs.string(forKey: "recordSubs")!)
        }else{
            return nil
        }
        
    }
    
    func loadData(){
        
        let json = self.loadJSON()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "recordSubs") != nil){
            
            // print(json)
            
            for (_, object) in json {
                
                let subs = SubsCount()
                subs.count = object["count"].stringValue
                subs.description = object["description"].stringValue
                
                if(object["count"].stringValue != "0"){
                    
                    self.arraySubs.append(subs)
                    
                    
                }
                
            }
        }
        
        
    }
    
    
    func setUpTable()
    {
        tableViewSubs?.delegate = self
        tableViewSubs?.dataSource = self
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.arraySubs.removeAll()
        
        loadData()
        
        if(arraySubs.count > 0) {
            return arraySubs.count
        } else {
            return 0
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = SubRecordsCustomCell()
        
        
        cell = tableView.dequeueReusableCell(withIdentifier: "CellRecordSubs", for: indexPath) as! SubRecordsCustomCell
        
        cell.separatorInset.left = 20.0
        cell.separatorInset.right = 20.0
        cell.separatorInset.top = 20.0
        cell.separatorInset.bottom = 20.0
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.white.cgColor
        
        let subs = arraySubs[indexPath.row]
        
        cell.count.text = subs.count
        
        
        if(subs.description == "Doctor Visit"){
            cell.name.text = "Doctor Visits"
        }
        
        if(subs.description == "Hospital Visit"){
            cell.name.text = "Hospital Visits"
        }
        
        if(subs.description == "Pathology"){
            cell.name.text = "Pathology Results"
        }
        
        if(subs.description == "Medicine"){
            cell.name.text = "Medication"
        }
        
        if(subs.description == "Notes"){
            cell.name.text = "Notes"
        }
        
        
        cell.count.layer.cornerRadius = 11.5
        cell.count.clipsToBounds = true
        
        
        if(indexPath.row == indexOfTouchCell)
        {
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadGetDetail"), object: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
        
        
    }
    
}
