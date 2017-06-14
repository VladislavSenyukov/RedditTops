//
//  RTTopsDatasource.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 14.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

var defaultCollectionPreset: RTCollectionPreset {
    let topUrl = "https://www.reddit.com/top/.json"
    let itemPath = [RTKeys.data.key, RTKeys.children.key]
    let afterPath = [RTKeys.data.key, RTKeys.after.key]
    return RTCollectionPreset(url: topUrl, limit: 20, limitKey: RTKeys.limit.key, afterKey: RTKeys.after.key, itemKey: RTKeys.data.key, itemPath: itemPath, afterPath: afterPath)
}

class RTTopsDatasource: RTDatasource<RTItem> {

    convenience init() {
        self.init(preset: defaultCollectionPreset)
    }
}
