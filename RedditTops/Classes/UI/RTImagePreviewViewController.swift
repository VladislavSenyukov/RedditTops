//
//  RTImagePreviewViewController.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 16.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTImagePreviewViewController: UIViewController {

    var url: String?
    @IBOutlet private weak var previewImageView: UIImageView?
    @IBOutlet private weak var spinner: UIActivityIndicatorView?
    @IBOutlet private weak var errorLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel?.isHidden = true
        if let aURL = url {
            print(aURL)
            // some images don't load for unknown reasons
            RTImageLoader.downloadImage(url: aURL, completion: {[unowned self] (image) in
                DispatchQueue.main.async {
                    if image == nil {
                        self.errorLabel?.isHidden = false
                    }
                    self.previewImageView?.image = image
                    self.spinner?.stopAnimating()
                }
            })
        } else {
            errorLabel?.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
