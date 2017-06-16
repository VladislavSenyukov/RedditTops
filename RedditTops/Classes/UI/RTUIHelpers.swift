//
//  RTUIHelpers.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 16.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

extension UIViewController {
    func showOKAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
