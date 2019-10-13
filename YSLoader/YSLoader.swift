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

public typealias Handler<T> = (Result<T, Error>) -> Void

public class YSLoader: YSLoaderProtocol {

    public static let shared: YSLoader = YSLoader()

    // Assign memory capacity for a URL network cache
    internal static let memoryCacheSizeMegabytes = 30

    // The AutoPurgingImageCache is an in-memory image cache used to store images up to a given memory capacity.
    // When the memory capacity is reached, the image cache is sorted by last access date,
    // then the oldest image is continuously purged until the preferred memory usage after purge is met.
    // Each time an image is accessed through the cache, the internal access date of the image is updated
    internal let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
    var request: DataRequest?

    public func load<T>(with url: String,
                        dataType: DataType,
                        completionHandler: @escaping Handler<T>) {
        load(with: url,
             parameters: nil,
             dataType: dataType,
             completionHandler: completionHandler)
    }

    public func load<T>(with url: String,
                        parameters: [String: String]?,
                        dataType: DataType,
                        completionHandler: @escaping Handler<T>) {
        switch dataType {
        case .image:
            loadImage(with: url) { result in
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
            loadJSON(with: url) { result in
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
    }

    public func cancelRequest(with url: String) {
        //Cancel specific request
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach({ task in
                if task.currentRequest?.url?.absoluteString == url {
                    task.cancel()
                }
            })
        }
    }
}
