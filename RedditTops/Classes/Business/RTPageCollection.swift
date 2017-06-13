//
//  RTPageCollection.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTPageCollection<T: RTEntity> {
    
    let url: String
    var count = 20
    var lastMark: String?
    var loading = false
    
    init(url: String) {
        self.url = url
    }
}
