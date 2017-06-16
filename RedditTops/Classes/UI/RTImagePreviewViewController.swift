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
    var isImageLoaded = false
    @IBOutlet private weak var previewImageView: UIImageView?
    @IBOutlet private weak var spinner: UIActivityIndicatorView?
    @IBOutlet private weak var errorLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(previewDidTap))
        previewImageView?.addGestureRecognizer(tapRecognizer)
        
        tryToLoadPhoto()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func tryToLoadPhoto() {
        errorLabel?.isHidden = true
        if let aURL = url {
            print(aURL)
            // some images don't load for unknown reasons
            RTImageLoader.downloadImage(url: aURL, completion: {[unowned self] (image) in
                DispatchQueue.main.async {
                    if image == nil {
                        self.errorLabel?.isHidden = false
                    } else {
                        self.isImageLoaded = true
                    }
                    self.previewImageView?.image = image
                    self.spinner?.stopAnimating()
                }
            })
        } else {
            errorLabel?.isHidden = false
        }
    }
    
    @objc private func previewDidTap() {
        if isImageLoaded, let image = self.previewImageView?.image {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Save to Photo Album", style: .default, handler: {[unowned self] (action) in
                self.saveImageToAlbum(image: image)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    private func saveImageToAlbum(image: UIImage) {
        spinner?.startAnimating()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(onImageSaveToAlbum(image:error:contextInfo:)), nil)
    }
    
    @objc private func onImageSaveToAlbum(image: UIImage, error: Error?, contextInfo:UnsafeMutableRawPointer?) {
        spinner?.stopAnimating()
        let alertMessage = error == nil ? "The image has been saved" : "Saving error"
        showOKAlert(message: alertMessage)
    }
}
