//
//  RTDatasource.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

typealias RTDatasourceIndicesCompletion = (_ indices: [IndexPath], _ error: Error?) -> ()

class RTDatasource<T:RTDeserializable> : RTPageLoaderDelegate {
    
    var preset: RTCollectionPreset
    
    var count: Int {
        return objects.count
    }
    
    private var objects = NSMutableArray()
    private var indicesCompletion: RTDatasourceIndicesCompletion?
    private var pageLoader = RTPageLoader<T>()
    
    init(preset: RTCollectionPreset) {
        self.preset = preset
        pageLoader.delegate = self
    }
    
    func load(completion: @escaping RTDatasourceIndicesCompletion) {
        indicesCompletion = completion
        pageLoader.load(preset: preset)
    }
    
    typealias Item = T
    
    subscript(index: Int) -> T {
        return objects[index] as! T
    }
    
    func shouldLoadNextPage(indexPath: IndexPath) -> Bool {
        let hasNextItems = count >= self.preset.limit
        let lastItem = indexPath.row == count-1
        return hasNextItems && lastItem
    }
    
    func pageLoaderDidLoadPage(pageObjects: NSMutableArray) {
        let startIndex = (objects.count == 0 ? 0 : objects.count)
        pageObjects.forEach { (obj) in
            objects.add(obj)
        }
        let endIndex = (pageObjects.count == 0 ? startIndex : objects.count-1)
        var addedIndices = [IndexPath]()
        if startIndex != endIndex {
            for i in startIndex...endIndex {
                addedIndices.append(IndexPath(row: i, section: 0))
            }
        }
        self.indicesCompletion?(addedIndices, nil)
    }
    
    func pageLoaderDidFailWithError(error: Error) {
        self.indicesCompletion?([IndexPath](), error)
    }
}
