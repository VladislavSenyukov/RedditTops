//
//  RTRedditNetworkManager.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 06.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import Foundation

typealias RTNetworkCompletion = (_ responseDic: [String:AnyObject]?, _ error: Error?) -> ()

class RTRedditNetworkManager: NSObject {
    
    func get(url: URL, completion: @escaping RTNetworkCompletion) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let aResponse = response as? HTTPURLResponse, aResponse.statusCode == 200, let aData = data {
                if let jsonObj = try? JSONSerialization.jsonObject(with: aData, options: JSONSerialization.ReadingOptions.mutableContainers) {
                    if let jsonDic = jsonObj as? [String:AnyObject] {
                        completion(jsonDic, nil)
                        return
                    }
                }
            }
            completion(nil, error)
        }.resume()
    }
}
