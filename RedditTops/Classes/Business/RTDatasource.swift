//
//  RTDatasource.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

protocol RTDatasourceInterface {
    associatedtype T
    func load(completion: @escaping RTDatasourceIndicesCompletion)
    subscript(index: Int) -> T {get}
}

typealias RTDatasourceIndicesCompletion = (_ indices: [NSIndexPath], _ error: Error?) -> ()

class RTDatasource<T:RTEntity> : RTDatasourceInterface, RTPageLoaderDelegate {
    
    var preset: RTCollectionPreset
    
    private var objects = NSMutableArray()
    private var count: Int {
        return objects.count
    }
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
    
    subscript(index: Int) -> T {
        return objects[index] as! T
    }
    
    func pageLoaderDidLoadPage(pageObjects: NSMutableArray) {
        let startIndex = (objects.count == 0 ? 0 : objects.count)
        pageObjects.forEach { (obj) in
            objects.add(obj)
        }
        let endIndex = (pageObjects.count == 0 ? startIndex : objects.count-1)
        var addedIndices = [NSIndexPath]()
        if startIndex != endIndex {
            for i in startIndex...endIndex {
                addedIndices.append(NSIndexPath(row: i, section: 0))
            }
        }
        self.indicesCompletion?(addedIndices, nil)
    }
    
    func pageLoaderDidFailWithError(error: Error) {
        self.indicesCompletion?([NSIndexPath](), error)
    }
}
