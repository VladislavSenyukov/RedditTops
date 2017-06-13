//
//  RTItem.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTItem: RTEntity {
    
    let title: String
    let author: String
    let date: Date
    let comments: Int
    var thumbSmall: String?
    var thumbBig: String?
    
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
        super.init(jsonDic: jsonDic)
    }
}
