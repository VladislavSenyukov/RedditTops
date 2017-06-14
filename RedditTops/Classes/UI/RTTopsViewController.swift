//
//  RTTopsViewController.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTTopsViewController: UIViewController {
    
    let topsDatasource = RTTopsDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        topsDatasource.load {[unowned self] (indices, error) in
            print(indices)
            self.topsDatasource.load { (indices, error) in
                print(indices)
            }
        }
    }

}
