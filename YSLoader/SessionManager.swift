//
//  SessionManager.swift
//  YSLoader
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import Alamofire

extension Alamofire.SessionManager{
    @discardableResult
    open func request(_ url: URLConvertible,
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil) -> DataRequest {

        // Assign memory (but not disk space) for a URL network cache:
        let cacheSizeMegabytes = YSLoader.memoryCacheSizeMegabytes
        URLCache.shared = URLCache(memoryCapacity: cacheSizeMegabytes*1024*1024,
                                   diskCapacity: 0,
                                   diskPath: nil)

        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .returnCacheDataElseLoad
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            // TODO: find a better way to handle error
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}
