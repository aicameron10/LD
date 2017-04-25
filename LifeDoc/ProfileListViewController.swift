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
      
        
        let myString = "My Profile"
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
                                        length:10 ))
        
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

