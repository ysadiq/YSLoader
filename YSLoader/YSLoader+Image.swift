//
//  YSLoader+Image.swift
//  YSLoader
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension YSLoader {
    internal func loadImage(with url: String, completionHandler: @escaping Handler<UIImage>) {
        // guards for duplicate requests
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            if tasks.firstIndex(where: { $0.originalRequest?.url?.absoluteString == url }) == nil {
                print("skip download this image \(url)")
                return
            }
        }

        // return image if cached
        if let image = imageCache.image(withIdentifier: url) {
            completionHandler(.success(image))
            return
        }
        print("download this image \(url)")
        request = Alamofire
            .SessionManager
            .default
            .request(url, method: .get)
            .validate()
            .responseImage { [weak self] response in
                guard response.result.isSuccess,
                    let image = response.result.value else {
                        if let error = response.result.error {
                            print("Error while fetching image with url \(url): \(error)")
                            completionHandler(.failure(error))
                        }
                        return
                }
                // cache the image
                self?.imageCache.add(image, withIdentifier: url)
                completionHandler(.success(image))
        }
    }
}
