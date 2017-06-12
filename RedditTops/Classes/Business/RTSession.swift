//
//  RTSessionManager.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTSession: NSObject {
    
    let token: String
    let expiresIn: Int
    
    init?(tokenInfo: [String:AnyObject]) {
        guard
            let token = tokenInfo["access_token"] as? String,
            let expiresIn = tokenInfo["expires_in"] as? Int
        else {
            return nil
        }
        self.token = token
        self.expiresIn = expiresIn
    }
}
