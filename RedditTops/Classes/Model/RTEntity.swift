//
//  RTEntity.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTEntity: PLDeserializable {
    
    let id: String
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let id = jsonDic[RTKeys.id.rawValue] as? String
        else {
            return nil
        }
        self.id = id
    }
}

protocol PLDeserializable {
    init?(jsonDic: [String:AnyObject])
}
