//
//  TermsController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/11/11.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import Foundation
import UIKit
import Material





class TermsController: UIViewController,UIWebViewDelegate  {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        prepareCloseButton()
        
        webView.delegate = self
        
        let url = NSURL(string: Constants.termsUrl)
        let urlRequest = NSURLRequest(url: url! as URL)
        self.webView.loadRequest(urlRequest as URLRequest)
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
    }
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(TermsController.buttonTapActionClose)
        
        
    }
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        self.dismiss(animated: true, completion: nil)
        
        let pageViewController: PageViewController = {
            return UIStoryboard.viewController(identifier: "PageViewController") as! PageViewController
        }()
        
        self.present(pageViewController, animated: true, completion: nil)
        
        
    }
    
    
}
