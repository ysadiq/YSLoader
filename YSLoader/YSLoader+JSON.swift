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
        guard let url = URL(string: url) else {
            let error = NSError(domain: "Error while creating URL from a string", code: 1, userInfo: nil)
            completionHandler(.failure(error))
            return
        }

        request = Alamofire.request(url, method: .get)
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
