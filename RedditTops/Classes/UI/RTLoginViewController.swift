//
//  ViewController.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 06.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTLoginViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: RTAppFacade.shared.networkManager.authURL)!)
        webView.loadRequest(request)
        spinner.startAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        RTAppFacade.shared.processAuthRequest(request: request) {[unowned self] (success) in
            self.spinner.stopAnimating()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            if success {
                self.performSegue(withIdentifier: "ShowTops", sender: self)
            } else {
                
            }
        }
        return true;
    }
}


