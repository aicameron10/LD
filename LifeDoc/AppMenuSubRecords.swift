//
//  AppMenuSubRecords.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/01/11.
//  Copyright © 2017 MediSwitch. All rights reserved.
//



import UIKit
import Material

class AppMenuSubRecords: MenuController {
    internal let baseSize = CGSize(width: 56, height: 56)
    internal let bottomInset: CGFloat = 24
    internal let rightInset: CGFloat = 24
    
    internal var addButton: FabButton!
    internal var NoteMenuItem: MenuItem!
    internal var DocMenuItem: MenuItem!
    internal var MediMenuItem: MenuItem!
    internal var HosMenuItem: MenuItem!
    internal var PathMenuItem: MenuItem!
    
    open override func prepare() {
        super.prepare()
        view.backgroundColor = Color.blueGrey.lighten5
        
        // Menu.
        prepareAddButton()
        prepareNoteButton()
        prepareDocButton()
        prepareMediButton()
        prepareHosButton()
        preparePathButton()
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareMenu()
    }
}

/// Menu.
extension AppMenuSubRecords {
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
        guard let mc = menuController as? AppMenuSubRecords else {
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
        
    }
    
    /// Handle the menu toggle event.
    internal func handleNote(button: Button) {
        
        closeMenu()
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "NotesEdit")
        
        let note: NoteSubRecord = {
            return UIStoryboard.viewController(identifier: "NoteSubRecord") as! NoteSubRecord}()
        
        
        self.present(note, animated: true, completion: nil)
    }
    
    /// Handle the menu toggle event.
    internal func handlePath(button: Button) {
        
        closeMenu()
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "PathEdit")
        
        let path: PathSubRecord = {
            return UIStoryboard.viewController(identifier: "PathSubRecord") as! PathSubRecord}()
        
        
        self.present(path, animated: true, completion: nil)
    }
    
    /// Handle the menu toggle event.
    internal func handleDoc(button: Button) {
        
        closeMenu()
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "DocEdit")
        
        let doc: DoctorSubRecord = {
            return UIStoryboard.viewController(identifier: "DoctorSubRecord") as! DoctorSubRecord}()
        
        
        self.present(doc, animated: true, completion: nil)
    }
    
    /// Handle the menu toggle event.
    internal func handleHos(button: Button) {
        
        closeMenu()
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "HosEdit")
        
        let hos: HospitalSubRecord = {
            return UIStoryboard.viewController(identifier: "HospitalSubRecord") as! HospitalSubRecord}()
        
        
        self.present(hos, animated: true, completion: nil)
    }
    
    /// Handle the menu toggle event.
    internal func handlemedi(button: Button) {
        
        closeMenu()
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "MediEdit")
        
        let medi: MedicationSubRecord = {
            return UIStoryboard.viewController(identifier: "MedicationSubRecord") as! MedicationSubRecord}()
        
        
        self.present(medi, animated: true, completion: nil)
    }
    
    
    internal func prepareAddButton() {
        addButton = FabButton(image: Icon.cm.add, tintColor: .white)
        addButton.pulseColor = .white
        addButton.backgroundColor = UIColor(red: 0/255, green: 149/255, blue: 217/255, alpha: 1.0)
        
        
        addButton.addTarget(self, action: #selector(handleToggleMenu), for: .touchUpInside)
    }
    
    internal func prepareNoteButton() {
        
        let imageotp : UIImage = UIImage(named:"ic_note_sub")!
        NoteMenuItem = MenuItem()
        NoteMenuItem.button.image = imageotp
        NoteMenuItem.button.tintColor = .white
        NoteMenuItem.button.pulseColor = .white
        NoteMenuItem.button.backgroundColor = UIColor(red: 0/255, green: 149/255, blue: 217/255, alpha: 1.0)
        NoteMenuItem.button.depthPreset = .depth1
        NoteMenuItem.title = "Notes"
        
        NoteMenuItem.button.addTarget(self, action: #selector(handleNote), for: .touchUpInside)
        
    }
    
    internal func prepareDocButton() {
        let imageotp : UIImage = UIImage(named:"ic_doc_sub")!
        DocMenuItem = MenuItem()
        DocMenuItem.button.image = imageotp
        DocMenuItem.button.tintColor = .white
        DocMenuItem.button.pulseColor = .white
        DocMenuItem.button.backgroundColor = UIColor(red: 217/255, green: 42/255, blue: 24/255, alpha: 1.0)
        DocMenuItem.title = "Doctor Visit"
        
        DocMenuItem.button.addTarget(self, action: #selector(handleDoc), for: .touchUpInside)
    }
    
    internal func prepareMediButton() {
        
        let imageotp : UIImage = UIImage(named:"ic_medi_sub")!
        MediMenuItem = MenuItem()
        MediMenuItem.button.image = imageotp
        MediMenuItem.button.tintColor = .white
        MediMenuItem.button.pulseColor = .white
        MediMenuItem.button.backgroundColor = UIColor(red: 0/255, green: 157/255, blue: 78/255, alpha: 1.0)
        MediMenuItem.title = "Medication"
        
        MediMenuItem.button.addTarget(self, action: #selector(handlemedi), for: .touchUpInside)
    }
    
    internal func prepareHosButton() {
        
        let imageotp : UIImage = UIImage(named:"ic_hos_sub")!
        HosMenuItem = MenuItem()
        HosMenuItem.button.image = imageotp
        HosMenuItem.button.tintColor = .white
        HosMenuItem.button.pulseColor = .white
        HosMenuItem.button.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 46/255, alpha: 1.0)
        HosMenuItem.title = "Hospital Visit"
        
        HosMenuItem.button.addTarget(self, action: #selector(handleHos), for: .touchUpInside)
    }
    
    internal func preparePathButton() {
        
        let imageotp : UIImage = UIImage(named:"ic_path_sub")!
        PathMenuItem = MenuItem()
        PathMenuItem.button.image = imageotp
        PathMenuItem.button.tintColor = .white
        PathMenuItem.button.pulseColor = .white
        PathMenuItem.button.backgroundColor = UIColor(red: 169/255, green: 78/255, blue: 145/255, alpha: 1.0)
        PathMenuItem.title = "Pathology Results"
        
        PathMenuItem.button.addTarget(self, action: #selector(handlePath), for: .touchUpInside)
    }
    
    
    
    internal func prepareMenu() {
        view.layout(menu)
            .size(baseSize)
            .bottom(bottomInset)
            .right(rightInset)
        
        menu.delegate = self
        menu.baseSize = baseSize
        menu.views = [addButton, PathMenuItem,HosMenuItem,MediMenuItem,DocMenuItem,NoteMenuItem]
    }
}

/// MenuDelegate.
extension AppMenuSubRecords: MenuDelegate {
    func menu(menu: Menu, tappedAt point: CGPoint, isOutside: Bool) {
        guard isOutside else {
            return
        }
        
        guard let mc = menuController as? AppMenuSubRecords else {
            return
        }
        
        mc.closeMenu { (view) in
            (view as? MenuItem)?.hideTitleLabel()
        }
    }
}
