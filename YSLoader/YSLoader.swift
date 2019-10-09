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

public class YSLoader: NSObject {
    public func loadImage(with url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }

        Alamofire.request(url, method: .get)
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
}
