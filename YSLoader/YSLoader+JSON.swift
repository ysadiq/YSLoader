//
//  YSLoader+JSON.swift
//  YSLoader
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import Alamofire

extension YSLoader {

    internal func loadJSON(with url: String, completionHandler: @escaping Handler<Data>) {
        Alamofire
        .SessionManager
        .default
        .request(url, method: .get)
        .validate()
        .responseJSON { response in
            guard response.result.isSuccess,
                let data = response.data else {
                    if let error = response.result.error {
                        print("Error while fetching JSON: \(error))")
                        completionHandler(.failure(error))
                    }
                    return
            }
            completionHandler(.success(data))
        }
    }
}
