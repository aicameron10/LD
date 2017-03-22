//
//  MainRecordCustomCell.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/01/13.
//  Copyright © 2017 MediSwitch. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Toast_Swift
import FileExplorer
import Photos

class MainRecordCustomCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate,FileExplorerViewControllerDelegate {
    
    
    public func fileExplorerViewControllerDidFinish(_ controller: FileExplorerViewController) {
        //
    }
    
    
    
    @IBOutlet weak var count: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var expandRow: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpTable()
        
        
    }
    
    
    func setUpTable()
    {
        tableView?.delegate = self
        tableView?.dataSource = self
        
        
        
    }
    
    
    var downLoadID = ""
    
    var downloadName = ""
    
    var arrayNoteSub = [NoteSub]()
    var arrayPathSub = [PathSub]()
    var arrayDocSub = [DocSub]()
    var arrayHosSub = [HosSub]()
    var arrayMediSub = [MediSub]()
    
    var arrayAttachSub = [AttachSub]()
    
    var deletedList : Array<String> = Array()
    
    var hideList : Array<String> = Array()
    
    var messageStr : String = String()
    var indexOfChangedCell = -1
    
    var indexOfDeletedCell = -1
    
    var indexOfEditCell = -1
    
    var indexOfAttachCell = -1
    
    var hideValue = false
    
    let cellReuseIdentifier = "cellAllergy"
    
    var hideRecord = false
    
    var hideRecordValue = false
    var counterNow = -1
    
    
    var downFail = false
    
    public func loadJSON() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Notes") != nil){
            //print(JSON.parse(prefs.string(forKey: "Notes")!))
            return JSON.parse(prefs.string(forKey: "Notes")!)
            
            
        }else{
            return nil
        }
        
    }
    
    public func loadJSONPath() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Pathology") != nil){
            
            return JSON.parse(prefs.string(forKey: "Pathology")!)
            
            
        }else{
            return nil
        }
        
    }
    public func loadJSONDoc() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Doctors") != nil){
            
            return JSON.parse(prefs.string(forKey: "Doctors")!)
            
            
        }else{
            return nil
        }
        
    }
    
    public func loadJSONHos() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Hospitals") != nil){
            
            return JSON.parse(prefs.string(forKey: "Hospitals")!)
            
            
        }else{
            return nil
        }
        
    }
    
    public func loadJSONMedi() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Medication") != nil){
            
            return JSON.parse(prefs.string(forKey: "Medication")!)
            
            
        }else{
            return nil
        }
        
    }
    
    
    public func loadJSONAttach() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Attachments") != nil){
            
            return JSON.parse(prefs.string(forKey: "Attachments")!)
            
            
        }else{
            return nil
        }
        
    }
    
    func loadDataAttach(){
        
        let json = self.loadJSONAttach()
        
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Attachments") != nil){
            
            print(json)
            var count = -1
            
            for item in json["attachments"].arrayValue {
                
                //print(object["Date"].stringValue)
                count += 1
                
                let attach = AttachSub()
                attach.id = item["id"].stringValue
                attach.attachmentName = item["attachmentName"].stringValue
                attach.attachmentType = item["attachmentType"].stringValue
                attach.description = item["description"].stringValue
                
                attach.pos = count
                
                self.arrayAttachSub.append(attach)
                
                
            }
            
        }
    }
    
    
    func loadDataPath(){
        
        let json = self.loadJSONPath()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Pathology") != nil){
            
            //print(json)
            var count = -1
            for (_, object) in json {
                //print(object["Date"].stringValue)
                count += 1
                
                let path = PathSub()
                path.id = object["recordId"].stringValue
                path.hide = object["_hide"].stringValue
                path.date = object["Test Date"].stringValue
                path.docName = object["Prescribed by?"].stringValue
                path.reason = object["Diagnosis/Reason for test?"].stringValue
                path.desc = object["Test description"].stringValue
                path.delete = object["_delete"].stringValue
                path.pos = count
                
                if(path.delete == "true"){
                    path.tag = -1
                }else{
                    path.tag = 1
                }
                
                
                self.arrayPathSub.append(path)
                
                
            }
            
        }
    }
    
    func loadDataDoc(){
        
        let json = self.loadJSONDoc()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Doctors") != nil){
            
            //print(json)
            var count = -1
            for (_, object) in json {
                //print(object["Date"].stringValue)
                count += 1
                
                let doc = DocSub()
                doc.id = object["recordId"].stringValue
                doc.hide = object["_hide"].stringValue
                doc.date = object["Date visited"].stringValue
                doc.docName = object["Name of doctor"].stringValue
                doc.reason = object["Diagnosis/Reason for visit?"].stringValue
                doc.desc = object["What treatment was given?"].stringValue
                doc.delete = object["_delete"].stringValue
                doc.pos = count
                
                if(doc.delete == "true"){
                    doc.tag = -1
                }else{
                    doc.tag = 1
                }
                
                
                self.arrayDocSub.append(doc)
                
                
            }
            
        }
    }
    
    
    func loadDataHos(){
        
        let json = self.loadJSONHos()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Hospitals") != nil){
            
            //print(json)
            var count = -1
            for (_, object) in json {
                //print(object["Date"].stringValue)
                count += 1
                
                let hos = HosSub()
                hos.id = object["recordId"].stringValue
                hos.hide = object["_hide"].stringValue
                hos.datead = object["Admission date"].stringValue
                hos.datedis = object["Discharge date"].stringValue
                hos.hosName = object["Hospital name"].stringValue
                hos.hosDoc = object["Who was the treating doctor?"].stringValue
                hos.reason = object["Diagnosis/Reason for test?"].stringValue
                hos.desc = object["What treatment did you receive?"].stringValue
                hos.delete = object["_delete"].stringValue
                hos.pos = count
                
                if(hos.delete == "true"){
                    hos.tag = -1
                }else{
                    hos.tag = 1
                }
                
                
                self.arrayHosSub.append(hos)
                
                
            }
            
        }
    }
    
    func loadDataMedi(){
        
        let json = self.loadJSONMedi()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Medication") != nil){
            
            //print(json)
            var count = -1
            for (_, object) in json {
                //print(object["Date"].stringValue)
                count += 1
                
                let medi = MediSub()
                medi.id = object["recordId"].stringValue
                medi.hide = object["_hide"].stringValue
                medi.datestart = object["Start date"].stringValue
                medi.dateend = object["End date"].stringValue
                medi.mediName = object["Medicine name"].stringValue
                medi.reason = object["Diagnosis/Reason for visit?"].stringValue
                medi.desc = object["Medicine notes"].stringValue
                medi.delete = object["_delete"].stringValue
                medi.pos = count
                
                if(medi.delete == "true"){
                    medi.tag = -1
                }else{
                    medi.tag = 1
                }
                
                
                self.arrayMediSub.append(medi)
                
                
            }
            
        }
    }
    
    
    func loadData(){
        
        let json = self.loadJSON()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "Notes") != nil){
            
            //print(json)
            var count = -1
            for (_, object) in json {
                //print(object["Date"].stringValue)
                count += 1
                
                let notes = NoteSub()
                notes.id = object["recordId"].stringValue
                notes.hide = object["_hide"].stringValue
                notes.date = object["Date"].stringValue
                notes.note = object["Notes"].stringValue
                notes.delete = object["_delete"].stringValue
                notes.pos = count
                
                if(notes.delete == "true"){
                    notes.tag = -1
                }else{
                    notes.tag = 1
                }
                
                
                self.arrayNoteSub.append(notes)
                
                
            }
            
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let prefs = UserDefaults.standard
        var type = ""
        if (prefs.string(forKey: "SubType") != nil){
            
            type = prefs.string(forKey: "SubType")!
            
        }
        
        
        self.arrayNoteSub.removeAll()
        self.arrayPathSub.removeAll()
        self.arrayDocSub.removeAll()
        self.arrayHosSub.removeAll()
        self.arrayMediSub.removeAll()
        self.arrayAttachSub.removeAll()
        
        
        
        if(type == "Notes"){
            loadData()
            
            if(arrayNoteSub.count > 0) {
                return arrayNoteSub.count
            } else {
                return 0
            }
            
        }else if(type == "Pathology Results"){
            loadDataPath()
            
            if(arrayPathSub.count > 0) {
                return arrayPathSub.count
            } else {
                return 0
            }
        }
        else if(type == "Doctor Visits"){
            loadDataDoc()
            
            if(arrayDocSub.count > 0) {
                return arrayDocSub.count
            } else {
                return 0
            }
        }
        else if(type == "Hospital Visits"){
            loadDataHos()
            
            if(arrayHosSub.count > 0) {
                return arrayHosSub.count
            } else {
                return 0
            }
        }
        else if(type == "Medication"){
            loadDataMedi()
            
            if(arrayMediSub.count > 0) {
                return arrayMediSub.count
            } else {
                return 0
            }
        } else if(type == "Attachments"){
            loadDataAttach()
            
            if(arrayAttachSub.count > 0) {
                return arrayAttachSub.count
            } else {
                return 0
            }
        }
        
        
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:RecordsCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! RecordsCustomCell
        
        
        
        let prefs = UserDefaults.standard
        var type = ""
        if (prefs.string(forKey: "SubType") != nil){
            
            type = prefs.string(forKey: "SubType")!
            
        }
        
        cell.hide.isHidden = false
        cell.delete.isHidden = false
        
        
        
        let image = UIImage(named : "edit_details.png")
        cell.edit.setBackgroundImage(image, for: .normal)
        
        
        
        if(type == "Notes"){
            let note = arrayNoteSub[indexPath.row]
            
            
            
            //cell.pos.text = String(indexPath.row)
            
            cell.name.text = note.note
            cell.dateStr.text = note.date
            cell.recordId.text = note.id
            
            
            print(note.pos)
            cell.pos.text = String(describing: note.pos)
            
            cell.hiddenValue.text = note.hide
            
            if(note.delete == "true"){
                cell.isHidden = true
                cell.tag = note.tag
            }
            
            cell.edit.tag = indexPath.row
            
            cell.edit.addTarget(self,action:#selector(self.buttonEditClicked), for: .touchUpInside)
            
        }else if(type == "Pathology Results"){
            let path = arrayPathSub[indexPath.row]
            
            
            
            //cell.pos.text = String(indexPath.row)
            
            cell.name.text = path.desc
            cell.dateStr.text = path.date
            cell.recordId.text = path.id
            
            
            print(path.pos)
            cell.pos.text = String(describing: path.pos)
            
            cell.hiddenValue.text = path.hide
            
            if(path.delete == "true"){
                cell.isHidden = true
                cell.tag = path.tag
            }
            
            cell.edit.tag = indexPath.row
            
            cell.edit.addTarget(self,action:#selector(self.buttonEditClicked), for: .touchUpInside)
        }
        else if(type == "Doctor Visits"){
            let doc = arrayDocSub[indexPath.row]
            
            
            
            //cell.pos.text = String(indexPath.row)
            
            cell.name.text = doc.docName
            cell.dateStr.text = doc.date
            cell.recordId.text = doc.id
            
            
            print(doc.pos)
            cell.pos.text = String(describing: doc.pos)
            
            cell.hiddenValue.text = doc.hide
            
            if(doc.delete == "true"){
                cell.isHidden = true
                cell.tag = doc.tag
            }
            cell.edit.tag = indexPath.row
            
            cell.edit.addTarget(self,action:#selector(self.buttonEditClicked), for: .touchUpInside)
            
        }
        else if(type == "Hospital Visits"){
            let hos = arrayHosSub[indexPath.row]
            
            
            
            //cell.pos.text = String(indexPath.row)
            
            cell.name.text = hos.hosName
            cell.dateStr.text = hos.datead + " to " +  hos.datedis
            cell.recordId.text = hos.id
            
            
            print(hos.pos)
            cell.pos.text = String(describing: hos.pos)
            
            cell.hiddenValue.text = hos.hide
            
            if(hos.delete == "true"){
                cell.isHidden = true
                cell.tag = hos.tag
            }
            
            cell.edit.tag = indexPath.row
            
            cell.edit.addTarget(self,action:#selector(self.buttonEditClicked), for: .touchUpInside)
        }
        else if(type == "Medication"){
            let medi = arrayMediSub[indexPath.row]
            
            
            
            //cell.pos.text = String(indexPath.row)
            
            cell.name.text = medi.mediName
            if(medi.dateend == ""){
                cell.dateStr.text = medi.datestart
            }else{
                cell.dateStr.text = medi.datestart + " to " +  medi.dateend
            }
            
            
            cell.recordId.text = medi.id
            
            
            print(medi.pos)
            cell.pos.text = String(describing: medi.pos)
            
            cell.hiddenValue.text = medi.hide
            
            if(medi.delete == "true"){
                cell.isHidden = true
                cell.tag = medi.tag
            }
            cell.edit.tag = indexPath.row
            
            cell.edit.addTarget(self,action:#selector(self.buttonEditClicked), for: .touchUpInside)
            
        }
        else if(type == "Attachments"){
            let attach = arrayAttachSub[indexPath.row]
            
            cell.hide.isHidden = true
            cell.delete.isHidden = true
            
            cell.recordId.text = attach.id
            
            let image = UIImage(named : "blue_attach.png")
            cell.edit.setBackgroundImage(image, for: .normal)
            
            
            
            //cell.pos.text = String(indexPath.row)
            
            cell.name.text = attach.attachmentName
            
            cell.dateStr.text = attach.description
            
            cell.recordId.text = attach.id
            
            
            cell.pos.text = String(describing: attach.pos)
            
            cell.edit.tag = indexPath.row
            
            cell.edit.addTarget(self,action:#selector(self.buttonAttachClicked), for: .touchUpInside)
            
            
            
            
        }
        
        
        
        
        
        
        
        
        if(cell.hiddenValue.text! == "false"){
            let image = UIImage(named: "blue_unhide") as UIImage?
            cell.hide.setBackgroundImage(image, for: .normal)
            
        }else if (cell.hiddenValue.text! == "true"){
            let image = UIImage(named: "blue_hide") as UIImage?
            cell.hide.setBackgroundImage(image, for: .normal)
            
        }
        
        
        
        if(indexPath.row == indexOfChangedCell)
        {
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "NotesEdit")
            prefs.removeObject(forKey: "PathEdit")
            prefs.removeObject(forKey: "DocEdit")
            prefs.removeObject(forKey: "HosEdit")
            prefs.removeObject(forKey: "MediEdit")
            
            let pos = cell.pos.text!
            
            prefs.set(pos, forKey: "posEdit")
            
            if(cell.hiddenValue.text! == "false"){
                
                hideValue = true
                
            }else if (cell.hiddenValue.text! == "true"){
                hideValue = false
            }
            
            if(type == "Notes"){
                hideNote()
            }else if(type == "Pathology Results"){
                print("hide path")
                hidePath()
            }
            else if(type == "Doctor Visits"){
                print("hide path")
                hideDoc()
            }
            else if(type == "Hospital Visits"){
                print("hide path")
                hideHos()
            }
            else if(type == "Medication"){
                print("hide path")
                hideMedi()
            }
            
        }
        
        
        
        if(indexPath.row == indexOfDeletedCell)
        {
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "NotesEdit")
            prefs.removeObject(forKey: "PathEdit")
            prefs.removeObject(forKey: "DocEdit")
            prefs.removeObject(forKey: "HosEdit")
            prefs.removeObject(forKey: "MediEdit")
            
            let pos = cell.pos.text!
            
            prefs.set(pos, forKey: "posEdit")
            showAreYouSure()
            
            
            
        }
        
        if(indexPath.row == indexOfAttachCell)
        {
            
            print("gotID")
            downLoadID = cell.recordId.text!
            downloadName = cell.name.text!
            
            
        }
        
        
        
        if(indexPath.row == indexOfEditCell)
        {
            
            
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "NotesEdit")
            prefs.removeObject(forKey: "PathEdit")
            prefs.removeObject(forKey: "DocEdit")
            prefs.removeObject(forKey: "HosEdit")
            prefs.removeObject(forKey: "MediEdit")
            
            
            let pos = cell.pos.text!
            
            print(pos)
            
            prefs.set(pos, forKey: "posEdit")
            
            
            
            if(type == "Notes"){
                self.saveJSONSubNote()
            }else if(type == "Pathology Results"){
                self.saveJSONSubPath()
            }else if(type == "Doctor Visits"){
                self.saveJSONSubDoc()
            }
            else if(type == "Hospital Visits"){
                self.saveJSONSubHos()
            }
            else if(type == "Medication"){
                self.saveJSONSubMedi()
            }
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        cell.hide.tag = indexPath.row
        
        cell.hide.addTarget(self,action:#selector(self.buttonHideClicked), for: .touchUpInside)
        
        cell.delete.tag = indexPath.row
        
        cell.delete.addTarget(self,action:#selector(self.buttonDeleteClicked), for: .touchUpInside)
        
        
        return cell
    }
    
    
    
    public func saveJSONNow(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "singleMeasurement")
        
        // here I save my JSON as a string
    }
    
    public func saveJSONSubNote(){
        let prefs = UserDefaults.standard
        prefs.set(prefs.string(forKey: "Notes")!, forKey: "NotesEdit")
        
    }
    
    public func saveJSONSubPath(){
        let prefs = UserDefaults.standard
        prefs.set(prefs.string(forKey: "Pathology")!, forKey: "PathEdit")
        
    }
    public func saveJSONSubDoc(){
        let prefs = UserDefaults.standard
        prefs.set(prefs.string(forKey: "Doctors")!, forKey: "DocEdit")
        
    }
    public func saveJSONSubHos(){
        let prefs = UserDefaults.standard
        prefs.set(prefs.string(forKey: "Hospitals")!, forKey: "HosEdit")
        
    }
    public func saveJSONSubMedi(){
        let prefs = UserDefaults.standard
        prefs.set(prefs.string(forKey: "Medication")!, forKey: "MediEdit")
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath)
        
        print(cell?.tag as Any)
        if(cell?.tag == -1){
            print("table cell")
            return 1
        }
            
        else{
            print("table cell 2")
            return 90
        }
        
        
        
        
        
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
        
        
        
        //self.window?.rootViewController?.dismiss(animated: false, completion: nil)
        
        let prefs = UserDefaults.standard
        var typeOf = ""
        if (prefs.string(forKey: "SubType") != nil){
            
            typeOf = prefs.string(forKey: "SubType")!
            
        }
        
        self.indexOfEditCell = -1
        
        let Notesub: NoteSubRecord = {
            return UIStoryboard.viewController(identifier: "NoteSubRecord") as! NoteSubRecord
        }()
        
        let Pathsub: PathSubRecord = {
            return UIStoryboard.viewController(identifier: "PathSubRecord") as! PathSubRecord
        }()
        
        
        let doc: DoctorSubRecord = {
            return UIStoryboard.viewController(identifier: "DoctorSubRecord") as! DoctorSubRecord
        }()
        
        let hos: HospitalSubRecord = {
            return UIStoryboard.viewController(identifier: "HospitalSubRecord") as! HospitalSubRecord
        }()
        
        let medi: MedicationSubRecord = {
            return UIStoryboard.viewController(identifier: "MedicationSubRecord") as! MedicationSubRecord
        }()
        
        
        
        if(typeOf == "Notes"){
            parentViewController?.present(Notesub, animated: false, completion: nil)
            
        }
        
        if(typeOf == "Pathology Results"){
            parentViewController?.present(Pathsub, animated: false, completion: nil)
            
            
        }
        
        if(typeOf == "Doctor Visits"){
            parentViewController?.present(doc, animated: false, completion: nil)
            
            
        }
        
        if(typeOf == "Hospital Visits"){
            parentViewController?.present(hos, animated: false, completion: nil)
            
            
        }
        
        if(typeOf == "Medication"){
            parentViewController?.present(medi, animated: false, completion: nil)
            
            
        }
        
    }
    
    func buttonAttachClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        indexOfAttachCell = buttonRow
        print("attach clicked")
        
        
        
        let indexPath = IndexPath(item: indexOfAttachCell, section: 0)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        self.tableView.endUpdates()
        
      let fileExtension = self.downloadName.fileExtension()
        
        if(fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png"){
            
           self.download()
        }
            
        else if(fileExtension == "pdf"){
            self.download()
        }
        else{
            
            self.parentViewController?.view.makeToast("Only PDF or image based files can be downloaded from the app.Login via the website to complete your download.", duration: 3.0, position: .center)
        }

       
        
        self.indexOfAttachCell = -1
        
        
    }
    
    
    
    func buttonHideClicked(sender:UIButton) {
        
        
        let buttonRow = sender.tag
        indexOfChangedCell = buttonRow
        
        
        
        
        let indexPath = IndexPath(item: indexOfChangedCell, section: 0)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        self.tableView.endUpdates()
        
        
        
        
    }
    
    func buttonDeleteClicked(sender:UIButton) {
        
        
        let buttonRow = sender.tag
        self.indexOfDeletedCell = buttonRow
        
        
        let indexPath = IndexPath(item: self.indexOfDeletedCell, section: 0)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        self.tableView.endUpdates()
        
        
        
        self.showAreYouSure()
        
    }
    
    
    func showAreYouSure() {
        let ac = UIAlertController(title: "Message", message: "Are you sure you wish to delete this information?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
            
            self.indexOfDeletedCell = -1
        })
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
            let prefs = UserDefaults.standard
            var type = ""
            if (prefs.string(forKey: "SubType") != nil){
                type = prefs.string(forKey: "SubType")!
                
                
                if(type == "Notes"){
                    print("delete path")
                    self.deleteNote()
                }else if(type == "Pathology Results"){
                    print("delete path")
                    self.deletePath()
                }else if(type == "Doctor Visits"){
                    print("delete path")
                    self.deleteDoc()
                }
                else if(type == "Hospital Visits"){
                    print("delete path")
                    self.deleteHos()
                }
                else if(type == "Medication"){
                    print("delete path")
                    self.deleteMedi()
                }
                
            }
            
            
            
            
        })
        parentViewController?.present(ac, animated: true)
    }
    
    public func loadJSONNote() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Notes") != nil){
            
            return JSON.parse(prefs.string(forKey: "Notes")!)
        }else{
            return nil
        }
        
    }
    
    public func loadJSONPaths() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Pathology") != nil){
            
            return JSON.parse(prefs.string(forKey: "Pathology")!)
        }else{
            return nil
        }
        
    }
    
    public func loadJSONDocs() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Doctors") != nil){
            
            return JSON.parse(prefs.string(forKey: "Doctors")!)
        }else{
            return nil
        }
        
    }
    public func loadJSONHoss() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Hospitals") != nil){
            
            return JSON.parse(prefs.string(forKey: "Hospitals")!)
        }else{
            return nil
        }
        
    }
    
    public func loadJSONMedis() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "Medication") != nil){
            
            return JSON.parse(prefs.string(forKey: "Medication")!)
        }else{
            return nil
        }
        
    }
    
    
    
    
    public func saveJSONNote(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "Notes")
        
        // here I save my JSON as a string
    }
    
    
    public func saveJSONPath(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "Pathology")
        
        // here I save my JSON as a string
    }
    
    public func saveJSONDoc(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "Doctors")
        
        // here I save my JSON as a string
    }
    public func saveJSONHos(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "Hospitals")
        
        // here I save my JSON as a string
    }
    
    public func saveJSONMedi(j: JSON) {
        let prefs = UserDefaults.standard
        prefs.set(j.rawString()!, forKey: "Medication")
        
        // here I save my JSON as a string
    }
    
    private func deleteNote() {
        
        let prefs = UserDefaults.standard
        let posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONNote()
        
        if (prefs.string(forKey: "Notes") != nil){
            
            json[posIndex!]["_delete"].boolValue = true
            json[posIndex!]["_save"].boolValue = false
            
            self.saveJSONNote(j: json)
            
            print(json)
            
        }
        
        indexOfDeletedCell = -1
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
    }
    
    private func deletePath() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONPaths()
        
        if (prefs.string(forKey: "Pathology") != nil){
            
            json[posIndex!]["_delete"].boolValue = true
            json[posIndex!]["_save"].boolValue = false
            
            self.saveJSONPath(j: json)
            
            print(json)
            
        }
        
        indexOfDeletedCell = -1
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
    }
    
    
    private func deleteDoc() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONDocs()
        
        if (prefs.string(forKey: "Doctors") != nil){
            
            json[posIndex!]["_delete"].boolValue = true
            json[posIndex!]["_save"].boolValue = false
            
            self.saveJSONDoc(j: json)
            
            print(json)
            
        }
        
        indexOfDeletedCell = -1
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
    }
    
    private func deleteHos() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONHoss()
        
        if (prefs.string(forKey: "Hospitals") != nil){
            
            json[posIndex!]["_delete"].boolValue = true
            json[posIndex!]["_save"].boolValue = false
            
            self.saveJSONHos(j: json)
            
            print(json)
            
        }
        
        indexOfDeletedCell = -1
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
    }
    
    
    private func deleteMedi() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONMedis()
        
        if (prefs.string(forKey: "Medication") != nil){
            
            json[posIndex!]["_delete"].boolValue = true
            json[posIndex!]["_save"].boolValue = false
            
            self.saveJSONMedi(j: json)
            
            print(json)
            
        }
        
        indexOfDeletedCell = -1
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
    }
    
    private func hideNote() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONNote()
        
        if (prefs.string(forKey: "Notes") != nil){
            
            if(hideValue == true){
                json[posIndex!]["_hide"].boolValue = true
                json[posIndex!]["_save"].boolValue = true
            }else{
                json[posIndex!]["_hide"].boolValue = false
                json[posIndex!]["_save"].boolValue = true
            }
            
            
            
            self.saveJSONNote(j: json)
            
            print(json)
            
        }
        
        indexOfChangedCell = -1
        
        parentViewController?.view.makeToast("Record has been hidden/made visible, please apply to save", duration: 3.0, position: .center)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
    }
    
    
    private func hidePath() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONPaths()
        
        if (prefs.string(forKey: "Pathology") != nil){
            
            if(hideValue == true){
                json[posIndex!]["_hide"].boolValue = true
                json[posIndex!]["_save"].boolValue = true
            }else{
                json[posIndex!]["_hide"].boolValue = false
                json[posIndex!]["_save"].boolValue = true
            }
            
            
            
            self.saveJSONPath(j: json)
            
            print(json)
            
        }
        
        indexOfChangedCell = -1
        
        parentViewController?.view.makeToast("Record has been hidden/made visible, please apply to save", duration: 3.0, position: .center)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
    }
    
    
    private func hideDoc() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONDocs()
        
        if (prefs.string(forKey: "Doctors") != nil){
            
            if(hideValue == true){
                json[posIndex!]["_hide"].boolValue = true
                json[posIndex!]["_save"].boolValue = true
            }else{
                json[posIndex!]["_hide"].boolValue = false
                json[posIndex!]["_save"].boolValue = true
            }
            
            
            
            self.saveJSONDoc(j: json)
            
            print(json)
            
        }
        
        indexOfChangedCell = -1
        
        parentViewController?.view.makeToast("Record has been hidden/made visible, please apply to save", duration: 3.0, position: .center)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
    }
    
    private func hideHos() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONHoss()
        
        if (prefs.string(forKey: "Hospitals") != nil){
            
            if(hideValue == true){
                json[posIndex!]["_hide"].boolValue = true
                json[posIndex!]["_save"].boolValue = true
            }else{
                json[posIndex!]["_hide"].boolValue = false
                json[posIndex!]["_save"].boolValue = true
            }
            
            
            
            self.saveJSONHos(j: json)
            
            print(json)
            
        }
        
        indexOfChangedCell = -1
        
        parentViewController?.view.makeToast("Record has been hidden/made visible, please apply to save", duration: 3.0, position: .center)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
    }
    
    public func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL]) {
        //Your code here
    }
    
    public func showAttachMessage(){
        
        let prefs = UserDefaults.standard
        var msg = ""
        if (prefs.string(forKey: "savedServerMessage") != nil){
            
            msg = prefs.string(forKey: "savedServerMessage")!
            
        }
        
        let ac = UIAlertController(title: "LifeDoc", message: msg, preferredStyle: .alert)
        
        
        ac.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
        })
        ac.addAction(UIAlertAction(title: "View", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
            let fileExplorer = FileExplorerViewController()
            
            let navigationBarAppearace = UINavigationBar.appearance()
            
            navigationBarAppearace.tintColor = .white
            navigationBarAppearace.barTintColor = UIColor(red: 0/255, green: 153/255, blue: 217/255, alpha: 1.0)
            
            fileExplorer.canChooseFiles = true //specify whether user is allowed to choose files
            fileExplorer.canChooseDirectories = true //specify whether user is allowed to choose directories
            fileExplorer.allowsMultipleSelection = false //specify whether user is allowed to choose multiple files and/or directories
            fileExplorer.fileFilters = [Filter.extension("jpg"),Filter.extension("png"),Filter.extension("pdf")]
            
            //let documentsUrl = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
            //fileExplorer.initialDirectoryURL = documentsUrl
            fileExplorer.ignoredFileFilters = [Filter.extension("txt")]
            fileExplorer.delegate = self
            
            
            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(fileExplorer, animated: true, completion: nil)
            
        })
        
        
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(ac, animated: true, completion: nil)
        
        
        
        
    }
    
    public func showAttachMessage1(){
        
        let prefs = UserDefaults.standard
        var msg = ""
        if (prefs.string(forKey: "savedServerMessage") != nil){
            
            msg = prefs.string(forKey: "savedServerMessage")!
            
        }
        
        let ac = UIAlertController(title: "LifeDoc", message: msg, preferredStyle: .alert)
        
        
        ac.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
        })
        
        
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(ac, animated: true, completion: nil)
        
        
        
        
    }
    
    
    private func download() {
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: (parentViewController?.view)!)
        
        parentViewController?.view.makeToast("Download started...", duration: 1.0, position: .bottom)
        
        let urlString: String
        
        urlString = Constants.baseURL + "records/downloadAttachment"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        let idd = downLoadID
        
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "attachmentId": idd
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Content-Type": "application/json",
            "Cache-Control": "no-cache"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        MainRecordCustomCell.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).response { response in
       
            
            let fileExtension = self.downloadName.fileExtension()
            
            
            if let data = response.data?.base64EncodedString(){
                
                if(data != ""){
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: (self.parentViewController?.view)!)
                    
                    
                    
                    if(fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png"){
                        
                        let dataDecoded : Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
                        let decodedimage = UIImage(data: dataDecoded)
                        
                        if let data = UIImageJPEGRepresentation(decodedimage!, 0.8) {
                            let name = self.downloadName
                            let filename = self.getDocumentsDirectory().appendingPathComponent(name)
                            try? data.write(to: filename)
                        }
                        
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAsset(from: decodedimage!)
                        }, completionHandler: { success, error in
                            if success {
                                // Saved successfully!
                            }
                            else if let error = error {
                                // Save photo failed with error
                                
                                print(error)
                            }
                            else {
                                // Save photo failed with no error
                            }
                        })
                        
                    }
                        
                    if(fileExtension == "pdf"){
                        let dataDecoded : Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
                        
                        let name = self.downloadName
                        let filename = self.getDocumentsDirectory().appendingPathComponent(name)
                        try? dataDecoded.write(to: filename)
                    }
                    
                    
                    
                    
                    
                    self.messageStr =  self.downloadName +  " downloaded successfully"
                    
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    self.showAttachMessage()
                    
                }else{
                    // get a reference to the app delegate
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: (self.parentViewController?.view)!)
                    self.messageStr =  "Download of " + self.downloadName  + " failed. Please try again."
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    self.showAttachMessage1()
                    
                }
                
            }
            
            
            if let error = response.error as? AFError{
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
            } else if let error = response.error as? URLError {
                print("URLError occurred: \(error)")
                
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: (self.parentViewController?.view)!)
                self.messageStr =  "Download of " + self.downloadName  + " failed. Please try again."
                prefs.set(self.messageStr, forKey: "savedServerMessage")
                self.showAttachMessage1()
                
                
            }
        }
        
        
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    private func hideMedi() {
        
        let prefs = UserDefaults.standard
        let  posIndex = Int(prefs.string(forKey: "posEdit")!)
        
        var json = self.loadJSONMedis()
        
        if (prefs.string(forKey: "Medication") != nil){
            
            if(hideValue == true){
                json[posIndex!]["_hide"].boolValue = true
                json[posIndex!]["_save"].boolValue = true
            }else{
                json[posIndex!]["_hide"].boolValue = false
                json[posIndex!]["_save"].boolValue = true
            }
            
            
            
            self.saveJSONMedi(j: json)
            
            print(json)
            
        }
        
        indexOfChangedCell = -1
        
        parentViewController?.view.makeToast("Record has been hidden/made visible, please apply to save", duration: 3.0, position: .center)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableRecord"), object: nil)
        
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
