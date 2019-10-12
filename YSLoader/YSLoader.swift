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

enum FileType {
    case Image
    case PDF
    case JSON
    case XML
    case ZIP
}

public protocol YSLoaderProtocol {
    func image(with url: String, completion: @escaping (UIImage?) -> Void)
    func json(with url: String, completion: @escaping (Data?) -> Void)
    func cancelRequest()
}

public class YSLoader: YSLoaderProtocol {
    var request: DataRequest?
    public static let shared: YSLoader = YSLoader()

    public func image(with url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }

        request = Alamofire.request(url, method: .get)
            .validate()
            .responseImage { response in
                guard response.result.isSuccess,
                let image = response.result.value else {
                    print("Error while fetching image: \(String(describing: response.result.error))")
                    completion(nil)
                    return
                }
                completion(image)
        }
    }

    public func json(with url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }

        request = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON(completionHandler: { response in
                guard response.result.isSuccess,
                    let data = response.data else {
                        print("Error while fetching JSON: \(String(describing: response.result.error))")
                        completion(nil)
                        return
                }
                completion(data)
            })
    }

    public func cancelRequest() {
        guard let request = request else {
            return
        }
        request.cancel()
    }
}
