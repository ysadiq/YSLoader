//
//  YSLoader.swift
//  YSLoader
//
//  Created by Yahya Saddiq on 10/9/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

public typealias Handler<T> = (Swift.Result<T, Error>) -> Void

public class YSLoader: YSLoaderProtocol {

    public init(manager: SessionManager = Alamofire.SessionManager.default) {
        self.manager = manager
    }

    internal let manager: SessionManager
    // Assign memory capacity for a URL network cache
    internal static let memoryCacheSizeMegabytes = 30

    // The AutoPurgingImageCache is an in-memory image cache used to store images up to a given memory capacity.
    // When the memory capacity is reached, the image cache is sorted by last access date,
    // then the oldest image is continuously purged until the preferred memory usage after purge is met.
    // Each time an image is accessed through the cache, the internal access date of the image is updated
    internal let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
    internal var requests: [(url: String, request: DataRequest)] = []

    public func load<T>(with url: String,
                        parameters: [String: String]?,
                        dataType: DataType,
                        completionHandler: @escaping Handler<T>) {

        var request: DataRequest?
        switch dataType {
        case .image:
            request = loadImage(with: url) { result in
                switch result {
                    case .failure(let error):
                        completionHandler(.failure(error))
                    case .success(let image):
                        guard let image = image as? T else {
                            return
                        }
                        completionHandler(.success(image))
                    }
                }
        case .json:
            request = loadJSON(with: url) { result in
                switch result {
                    case .failure(let error):
                        completionHandler(.failure(error))
                    case .success(let json):
                        guard let json = json as? T else {
                            return
                        }
                        completionHandler(.success(json))
                    }
                }
        default:
            break
        }
        
        guard let requestUnwrapped = request else {
            return
        }
        requests.append((url: url, request: requestUnwrapped))
    }

    // Cancel specific request with a griven URL
    public func cancelRequest(of url: String) {
        if let requestObject = requests.first(where: { $0.url == url }) {
            requestObject.request.cancel()
        }
    }

    public func load<T>(with url: String,
                        dataType: DataType,
                        completionHandler: @escaping Handler<T>) {
        load(with: url,
             parameters: nil,
             dataType: dataType,
             completionHandler: completionHandler)
    }
}
