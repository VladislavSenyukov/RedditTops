//
//  RTRedditNetworkManager.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 06.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

typealias RTNetworkCompletion = (_ responseDic: [String:AnyObject]?, _ error: Error?) -> ()

class RTRedditNetworkManager: NSObject {
    
    var delegate: RTAuthorizable?
    var authURL: String {
        return "\(self.baseURL)/authorize?client_id=\(secretKey)&response_type=code&state=auth&redirect_uri=\(redirectURI)&duration=temporary&scope=read&raw_json=1"
    }
    
    private let secretKey = "yf1CtQDWPxZaCA"
    private let baseURL = "https://www.reddit.com/api/v1"
    private let redirectURI = "http://127.0.0.1/authorize_callback"
    private let accessTokenUrl = "https://www.reddit.com/api/v1/access_token"
    
    func processAuthRequest(request: URLRequest, completion: @escaping ([String:AnyObject]?) -> ()) {
        if let urlString = request.url?.absoluteString {
            if urlString.contains(redirectURI) == true {
                let components = urlString.components(separatedBy: "?")
                if components.count == 2 && components.first! == redirectURI {
                    components.last!.components(separatedBy: "&").forEach({ (attributes) in
                        let attributePair = attributes.components(separatedBy: "=")
                        if attributePair.count == 2 && attributePair.first! == "code" {
                            let codeValue = attributePair.last!
                            requestAccessToken(code: codeValue, completion: { (tokenInfo) in
                                completion(tokenInfo)
                            })
                        }
                    })
                }
            }
        }
    }
    
    func requestAccessToken(code: String, completion: @escaping ([String:AnyObject]?) -> ()) {
        var tokenRequest = URLRequest(url: URL(string: accessTokenUrl)!)
        tokenRequest.httpMethod = "POST"
        let authString = "\(secretKey): "
        let authBase64 = Data(authString.utf8).base64EncodedString()
        let basicAuth = "Basic \(authBase64)"
        tokenRequest.setValue(basicAuth, forHTTPHeaderField: "Authorization")
        let bodyStr = "grant_type=authorization_code&code=\(code)&redirect_uri=\(redirectURI)"
        tokenRequest.httpBody = Data(bodyStr.utf8)
        URLSession.shared.dataTask(with: tokenRequest) { (data, response, error) in
            if error == nil {
                if let aResponse = response as? HTTPURLResponse, aResponse.statusCode == 200, let aData = data {
                    if let jsonObj = try? JSONSerialization.jsonObject(with: aData, options: JSONSerialization.ReadingOptions.mutableContainers) {
                        if let jsonDic = jsonObj as? [String:AnyObject] {
                            completion(jsonDic)
                        }
                    }
                }
                completion(nil)
            }
        }.resume()
    }
    
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
