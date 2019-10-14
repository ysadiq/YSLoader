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
    internal func loadImage(with url: String, completionHandler: @escaping Handler<UIImage>) -> DataRequest? {
        // return image if cached
        if let image = imageCache.image(withIdentifier: url) {
            completionHandler(.success(image))
            return nil
        }
        
        return Alamofire
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
