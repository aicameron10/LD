//
//  PageViewController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/15.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var Container: UIView!
    var tutorialPageViewController: ShowPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageControl.addTarget(self, action: #selector(PageViewController.didChangePageControlValue), for: .valueChanged)
        prepareLoginButton()
        prepareSignUpButton()
        
        
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func buttonTapActionLogin(sender: UIButton!) {
       
        
        self.dismiss(animated: true, completion: nil)
        
        let loginController: LoginController = {
            return UIStoryboard.viewController(identifier: "LoginController") as! LoginController
        }()
        
        self.present(loginController, animated: true, completion: nil)
        
        
    }
    func buttonTapActionSignUp(sender: UIButton!) {
        
        
        self.dismiss(animated: true, completion: nil)
        
        let signUpController: SignUpController = {
            return UIStoryboard.viewController(identifier: "SignUpController") as! SignUpController
        }()
        
        
        self.present(signUpController, animated: true, completion: nil)
        
        
        
    }
    
    private func prepareLoginButton() {
        loginButton.addTarget(self, action: #selector(self.buttonTapActionLogin), for: .touchUpInside)
        
    }
    
    private func prepareSignUpButton() {
        
        signUpButton.addTarget(self, action:#selector(self.buttonTapActionSignUp), for: .touchUpInside)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? ShowPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        self.tutorialPageViewController?.scrollToNextViewController()
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        self.tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}

extension PageViewController: ShowPageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: ShowPageViewController,
                                    didUpdatePageCount count: Int) {
        self.pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: ShowPageViewController,
                                    didUpdatePageIndex index: Int) {
        self.pageControl.currentPage = index
    }
    
}
