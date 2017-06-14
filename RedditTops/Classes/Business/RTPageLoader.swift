//
//  RTPageLoader.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

struct RTCollectionPreset {
    var url: String
    var limit: Int
    var limitKey: String
    var afterKey: String
    var itemKey: String
    var itemPath: [String]
    var afterPath: [String]
}

protocol RTPageLoaderDelegate: class {
    func pageLoaderDidLoadPage(pageObjects: NSMutableArray)
    func pageLoaderDidFailWithError(error: Error)
}

class RTPageLoader<T: RTEntity> {
    
    var after = ""
    var loading = false
    weak var delegate: RTPageLoaderDelegate?
    let networkManager = RTRedditNetworkManager()
    
    func load(preset: RTCollectionPreset) {
        if !loading {
            if let url = prepareUrl(preset: preset, after: after) {
                loading = true
                networkManager.get(url: url, completion: {[unowned self] (responseDic, error) in
                    self.loading = false
                    if error != nil {
                        self.delegate?.pageLoaderDidFailWithError(error: error!)
                    } else {
                        var objects = [T]()
                        if let aResponseDic = responseDic {
                            let rawItems = self.extractObjects(data: aResponseDic, atPath: preset.itemPath)
                            rawItems.forEach({ (rawItem) in
                                if let aRawItem = rawItem as? [String:AnyObject] {
                                    if let aRawItemDataDic = aRawItem[preset.itemKey] as? [String:AnyObject] {
                                        if let item = T(jsonDic: aRawItemDataDic) {
                                            objects.append(item)
                                        }
                                    }
                                }
                            })
                            self.updateAfter(responseDic: aResponseDic, preset: preset)
                        }
                        self.delegate?.pageLoaderDidLoadPage(pageObjects: NSMutableArray(array: objects))
                    }
                })
            } else {
                self.delegate?.pageLoaderDidFailWithError(error: RTError.WrongURL)
            }
        }
    }
    
    func prepareUrl(preset: RTCollectionPreset, after: String) -> URL? {
        var url = "\(preset.url)?\(preset.limitKey)=\(preset.limit)"
        if !after.isEmpty {
            url = "\(url)&\(preset.afterKey)=\(after)"
        }
        return URL(string: url)
    }
    
    func extractObjects(data: [String:AnyObject], atPath path: [String]) -> [AnyObject] {
        var objects = [AnyObject]()
        var tempData = data
        for (idx, pathComponent) in path.enumerated() {
            if idx == path.count-1 {
                if let foundObjects = tempData[pathComponent] as? [AnyObject] {
                    objects.append(contentsOf: foundObjects)
                }
            } else {
                if let aData = tempData[pathComponent] as? [String:AnyObject] {
                    tempData = aData
                }
            }
        }
        return objects
    }
    
    func extractString(data: [String:AnyObject], atPath path: [String]) -> String {
        var string = ""
        var tempData = data
        for (idx, pathComponent) in path.enumerated() {
            if idx == path.count-1 {
                if let foundString = tempData[pathComponent] as? String {
                    string = foundString
                }
            } else {
                if let aData = tempData[pathComponent] as? [String:AnyObject] {
                    tempData = aData
                }
            }
        }
        return string
    }
    
    
    func updateAfter(responseDic: [String:AnyObject], preset: RTCollectionPreset) {
        after = extractString(data: responseDic, atPath: preset.afterPath)
    }
}
