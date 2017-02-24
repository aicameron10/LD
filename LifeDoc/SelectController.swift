//
//  SelectController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/12/13.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import Foundation
import UIKit


class SelectContoller: UIViewController {
    
    @IBOutlet weak var scrollViewAssess: UIScrollView!
    
    @IBOutlet weak var Chronic: UIView!
    @IBOutlet weak var Allergy: UIView!
    @IBOutlet weak var Weight: UIView!
    @IBOutlet weak var Pulse: UIView!
    @IBOutlet weak var Height: UIView!
    @IBOutlet weak var BodyTemp: UIView!
    @IBOutlet weak var BMI: UIView!
    @IBOutlet weak var BloodPressure: UIView!
    @IBOutlet weak var BloodGlucose: UIView!
    @IBOutlet weak var Cholesterol: UIView!
    @IBOutlet weak var scrollViewRecords: UIScrollView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollViewRecords)
        view.addSubview(scrollViewRecords)
        prepareCloseButton()
        prepareCholesterol()
        preparebg()
        preparebp()
        preparebmi()
        preparebt()
        prepareHeight()
        preparePulse()
        prepareWeight()
        
         prepareAllergy()
         prepareChronic()
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "singleMeasurement")
        prefs.removeObject(forKey: "mainAllergyChronic")
        prefs.removeObject(forKey: "globalReason")
        prefs.removeObject(forKey: "globalDoctor")
        
        prefs.removeObject(forKey: "Notes")
        prefs.removeObject(forKey: "NotesEdit")
        prefs.removeObject(forKey: "Pathology")
        prefs.removeObject(forKey: "PathEdit")
        
        prefs.removeObject(forKey: "Doctors")
        prefs.removeObject(forKey: "DocEdit")
        
        prefs.removeObject(forKey: "Hospitals")
        prefs.removeObject(forKey: "HosEdit")
        
        prefs.removeObject(forKey: "Medication")
        prefs.removeObject(forKey: "MediEdit")
        
        
        
        
    }
    
    private func prepareCloseButton() {
        
        let leftNavItem = cancelButton
        leftNavItem?.action = #selector(SelectContoller.buttonTapActionClose)
        
    }
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func prepareCholesterol() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapCholesterol))
        
        Cholesterol.addGestureRecognizer(tap)
        
    }
    
    private func prepareAllergy() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapAllergy))
        
        Allergy.addGestureRecognizer(tap)
        
    }
    
    private func prepareChronic() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapChronic))
        
        Chronic.addGestureRecognizer(tap)
        
    }
    
    private func preparebg() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapbg))
        
        BloodGlucose.addGestureRecognizer(tap)
        
    }
    
    private func preparebp() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapbp))
        
        BloodPressure.addGestureRecognizer(tap)
        
    }
    
    private func preparebmi() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapbmi))
        
        BMI.addGestureRecognizer(tap)
        
    }
    
    private func preparebt() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapbt))
        
        BodyTemp.addGestureRecognizer(tap)
        
    }
    
    private func prepareHeight() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapHeight))
        
        Height.addGestureRecognizer(tap)
        
    }
    
    private func preparePulse() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapPulse))
        
        Pulse.addGestureRecognizer(tap)
        
    }
    private func prepareWeight() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapWeight))
        
        Weight.addGestureRecognizer(tap)
        
    }
    
    
    func handleTapAllergy(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
   
        let allergy: MainAllergy = {
            return UIStoryboard.viewController(identifier: "MainAllergy") as! MainAllergy
        }()
        
        let allergyView = AppMenuSubRecords(rootViewController: allergy)
        
        self.present(allergyView, animated: false, completion: nil)
        
    }

    func handleTapChronic(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
        
    
        
        let chronic: MainChronic = {
            return UIStoryboard.viewController(identifier: "MainChronic") as! MainChronic
        }()
        
        let chronicView = AppMenuSubRecords(rootViewController: chronic)
        
        self.present(chronicView, animated: false, completion: nil)
    }

    
    func handleTapWeight(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
        
        
        let weightContoller: WeightContoller = {
            return UIStoryboard.viewController(identifier: "WeightContoller") as! WeightContoller
        }()
        
        self.present(weightContoller, animated: false, completion: nil)
        
    }
    
    func handleTapPulse(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
        
        
        let pulseContoller: PulseContoller = {
            return UIStoryboard.viewController(identifier: "PulseContoller") as! PulseContoller
        }()
        
        self.present(pulseContoller, animated: false, completion: nil)
        
    }
    
    
    
    func handleTapHeight(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
        
        
        let heightContoller: HeightContoller = {
            return UIStoryboard.viewController(identifier: "HeightContoller") as! HeightContoller
        }()
        
        self.present(heightContoller, animated: false, completion: nil)
        
    }
    
    
    func handleTapbt(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
        
        
        let bodyTempContoller: BodyTempContoller = {
            return UIStoryboard.viewController(identifier: "BodyTempContoller") as! BodyTempContoller
        }()
        
        self.present(bodyTempContoller, animated: false, completion: nil)
        
    }
    
    
    func handleTapbmi(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
        
        
        let bmiController: BmiController = {
            return UIStoryboard.viewController(identifier: "BmiController") as! BmiController
        }()
        
        self.present(bmiController, animated: false, completion: nil)
        
    }
    
    
    func handleTapbg(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
        
        
        let bloodGlucoseContoller: BloodGlucoseContoller = {
            return UIStoryboard.viewController(identifier: "BloodGlucoseContoller") as! BloodGlucoseContoller
        }()
        
        self.present(bloodGlucoseContoller, animated: false, completion: nil)
        
    }
    
    func handleTapbp(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
        
        
        let bloodPresssureContoller: BloodPresssureContoller = {
            return UIStoryboard.viewController(identifier: "BloodPresssureContoller") as! BloodPresssureContoller
        }()
        
        self.present(bloodPresssureContoller, animated: false, completion: nil)
        
    }
    
    
    func handleTapCholesterol(sender: UITapGestureRecognizer? = nil) {
        print("handling code")
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.dismissSelect()
        
        let cholesterolController: CholesterolController = {
            return UIStoryboard.viewController(identifier: "CholesterolController") as! CholesterolController
        }()
        
        self.present(cholesterolController, animated: false, completion: nil)
        
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollViewRecords.contentSize = CGSize(width: 400, height: 180)
        scrollViewAssess.contentSize = CGSize(width: 1400, height: 180)
    }
    
}



