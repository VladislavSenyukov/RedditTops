//
//  RTItemPreview.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 15.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTItemPreview: RTDeserializable {
    
    let url: String
    let size: CGSize
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let url = jsonDic[RTKeys.url.rawValue] as? String,
            let width = jsonDic[RTKeys.width.rawValue] as? Int,
            let height = jsonDic[RTKeys.height.rawValue] as? Int
        else {
            return nil
        }
        self.url = url
        self.size = CGSize(width: width, height: height)
    }
}
