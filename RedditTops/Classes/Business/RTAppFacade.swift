//
//  RTAppFacade.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 06.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTAppFacade: NSObject {

    static let shared = RTAppFacade()
    
    func login(login: String, pass: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            completion(false)
        }
    }
}
