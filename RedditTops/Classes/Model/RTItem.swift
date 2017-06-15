//
//  RTItem.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTItem: RTDeserializable {
    
    let title: String
    let author: String
    let date: Date
    let comments: Int
    var originalPreview: RTItemPreview?
    var thumbUrl: String?
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let title = jsonDic[RTKeys.title.rawValue] as? String,
            let author = jsonDic[RTKeys.author.rawValue] as? String,
            let createdAt = jsonDic[RTKeys.created.rawValue] as? TimeInterval,
            let comments = jsonDic[RTKeys.comments.rawValue] as? Int
        else {
            return nil
        }
        
        self.title = title
        self.author = author
        self.date = Date(timeIntervalSince1970: createdAt)
        self.comments = comments
        
        if let previewsDic = jsonDic[RTKeys.preview.key] as? [String : AnyObject] {
            if let imagesObj = previewsDic[RTKeys.images.key] as? [AnyObject] {
                if let imagesDic = imagesObj.first as?  [String : AnyObject] {
                    if let sourceDic = imagesDic[RTKeys.source.key] as? [String : AnyObject] {
                        self.originalPreview = RTItemPreview(jsonDic: sourceDic)
                    }
                }
            }
        }
        
        if let thumbUrl = jsonDic[RTKeys.thumbnail.rawValue] as? String {
            self.thumbUrl = thumbUrl
        }
    }
}
