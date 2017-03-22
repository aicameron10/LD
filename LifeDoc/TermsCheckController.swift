//
//  TermsCheckController.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2017/02/14.
//  Copyright © 2017 MediSwitch. All rights reserved.
//

import Foundation
import UIKit
import Material




class TermsCheckController: UIViewController,UIWebViewDelegate  {
    
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
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.checkTerms()
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
}

