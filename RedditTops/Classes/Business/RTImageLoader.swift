//
//  RTImageLoader.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 15.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

typealias RTImageCacheCompletion = (_ image: UIImage?) -> ()

private func sync(obj: Any, block: () -> ()) {
    objc_sync_enter(obj)
    defer {
        objc_sync_exit(obj)
    }
    block()
}

class RTImageCache {
    
    private var images = [String : UIImage]()
    
    subscript(url: String) -> UIImage? {
        var image: UIImage?
        sync(obj: self) { 
            image = images[url]
        }
        return image
    }
    
    func add(url: String, image: UIImage) {
        sync(obj: self) { 
            images[url] = image
        }
    }
    
    func clear() {
        sync(obj: self) { 
            images.removeAll()
        }
    }
}

class RTImageLoader {
    static let shared = RTImageLoader()
    private let downloadQueue = RTImageCacheOperationQueue()
    private let imageCache = RTImageCache()
    
    static func downloadImage(url: String, completion: @escaping RTImageCacheCompletion) {
        shared.downloadImage(url: url, completion: completion)
    }
    
    static func cancelDownloadingImage(url: String) {
        shared.cancelDownloadingImage(url: url)
    }
    
    private func downloadImage(url: String, completion: @escaping RTImageCacheCompletion) {
        if let cachedImage = imageCache[url] {
            completion(cachedImage)
        } else {
            if downloadQueue[url] == nil {
                 let downloadOperation = RTImageDownloadOperation(url: url, completion: {[unowned self] (image) in
                    if let anImage = image {
                        self.imageCache.add(url: url, image: anImage)
                    }
                    completion(image)
                })
                downloadQueue.addOperation(downloadOperation)
            } else {
                completion(nil)
            }
        }
    }
    
    private func cancelDownloadingImage(url: String) {
        if let operation = downloadQueue[url] {
            operation.cancel()
        }
    }
    
}

class RTImageCacheOperationQueue: OperationQueue {
    
    subscript(url: String) -> RTImageDownloadOperation? {
        var foundOperation: RTImageDownloadOperation?
        sync(obj: self) { 
            for op in operations {
                if let operation = op as? RTImageDownloadOperation, operation.url == url {
                    foundOperation = operation
                    break
                }
            }
        }
        return foundOperation
    }
}

class RTImageDownloadOperation: Operation {
    
    let url: String
    var downloadTask: URLSessionDownloadTask?
    let completion: RTImageCacheCompletion
    
    init(url: String, completion: @escaping RTImageCacheCompletion) {
        self.url = url
        self.completion = completion
    }
    
    override func cancel() {
        downloadTask?.cancel()
        super.cancel()
    }
    
    override func main() {
        if isCancelled { return }
        guard
            let aURL = url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let encodedURL = URL(string: aURL)
        else {
            completion(nil)
            return
        }
        if isCancelled { return }
        
        var imageLocation: URL?
        let semaphore = DispatchSemaphore(value: 0)
        downloadTask = URLSession.shared.downloadTask(with: encodedURL, completionHandler: { (location, response, error) in
            imageLocation = location
            semaphore.signal()
        })
        
        if isCancelled { return }
        
        downloadTask?.resume()
        let timeout = DispatchTime.now() + .seconds(30)
        if semaphore.wait(timeout: timeout) == .timedOut {
            // time out
        }
        
        if isCancelled { return }
        
        if let location = imageLocation {
            if let data = try? Data(contentsOf: location) {
                // the next conversion is needed because a UIImage created with Data is rendered by the time it is assigned to its UIImageView (on main thread), so by creating an image via a CGImage we boost performance
                if let provider = CGDataProvider(data: data as CFData) {
                    if isCancelled { return }
                    if let cgImage = CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) {
                        if isCancelled { return }
                        let image = UIImage(cgImage: cgImage)
                        completion(image)
                        return
                    }
                }
            }
        }
        completion(nil)
    }
    
    override var isConcurrent: Bool {
        return true
    }
    
    override var isAsynchronous: Bool {
        return true
    }
}
