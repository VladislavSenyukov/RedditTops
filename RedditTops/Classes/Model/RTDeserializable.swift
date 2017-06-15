//
//  RTDeserializable.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

protocol RTDeserializable {
    init?(jsonDic: [String:AnyObject])
}
