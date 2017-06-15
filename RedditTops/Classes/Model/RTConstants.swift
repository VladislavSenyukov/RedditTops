//
//  RTConstants.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

enum RTKeys: String {
    case title
    case author
    case created = "created_utc"
    case comments = "num_comments"
    case preview
    case images
    case source
    case url
    case width
    case height
    case thumbnail
    case after
    case limit
    case data
    case children
    
    var key: String {
        return rawValue
    }
}

enum RTError : Error {
    case WrongURL
}

