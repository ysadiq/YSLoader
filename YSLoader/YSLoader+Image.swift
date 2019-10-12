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
        guard let url = URL(string: url) else {
            let error = NSError(domain: "Error while creating URL from a string", code: 1, userInfo: nil)
            completionHandler(.failure(error))
            return
        }

        request = Alamofire
            .SessionManager
            .default
            .request(url, method: .get)
            .validate()
            .responseImage { response in
                guard response.result.isSuccess,
                    let image = response.result.value else {
                        if let error = response.result.error {
                            print("Error while fetching image with url \(url): \(error)")
                            completionHandler(.failure(error))
                        }
                        return
                }
                completionHandler(.success(image))
        }
    }
}
