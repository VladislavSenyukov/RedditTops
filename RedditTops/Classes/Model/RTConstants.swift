//
//  RTConstants.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

enum RTKeys: String {
    case id = "id"
    case title = "title"
    case author = "author"
    case created = "created_utc"
    case comments = "num_comments"
    case preview = "preview"
    case images = "images"
    case source = "source"
    case resolutions = "resolutions"
    case url = "url"
    case width = "width"
    case height = "height"
    case after = "after"
    case limit = "limit"
    case data = "data"
    case children = "children"
    
    var key: String {
        return rawValue
    }
}

enum RTError : Error {
    case WrongURL
}

