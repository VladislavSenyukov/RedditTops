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
    let networkManager = RTRedditNetworkManager()
    var session: RTSession?
    
    func processAuthRequest(request: URLRequest, completion: @escaping (Bool) -> ()) {
        networkManager.processAuthRequest(request: request) {[unowned self] (tokenInfoDic) in
            if tokenInfoDic != nil {
                self.session = RTSession(tokenInfo: tokenInfoDic!)
                if self.session != nil {
                    completion(true)
                }
            }
            completion(false)
        }
    }
}
