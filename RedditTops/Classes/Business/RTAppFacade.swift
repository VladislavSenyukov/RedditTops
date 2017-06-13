//
//  RTAppFacade.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 06.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

protocol RTAuthorizable {
    var accessToken: String? {get}
}

class RTAppFacade: NSObject {

    static let shared = RTAppFacade()
    let networkManager = RTRedditNetworkManager()
    var session: RTSession?
    
    override init() {
        super.init()
        networkManager.delegate = self
    }
    
    func processAuthRequest(request: URLRequest, completion: @escaping (Bool) -> ()) {
        networkManager.processAuthRequest(request: request) {[unowned self] (tokenInfoDic) in
            DispatchQueue.main.async {
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
    
    func fetchTops(completion: @escaping () -> ()) {
        networkManager.fetchTops {
            
        }
    }
}

extension RTAppFacade : RTAuthorizable {
    var accessToken: String? {
        return session?.token
    }
    
}
