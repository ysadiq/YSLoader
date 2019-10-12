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
    internal static let memorycacheSizeMegabytes = 30
    internal let imageCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
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

    public func cancelRequest() {
        guard let request = request else {
            return
        }
        request.cancel()
    }
}
