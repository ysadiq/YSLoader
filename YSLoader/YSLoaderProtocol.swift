//
//  YSLoaderProtocol.swift
//  YSLoader
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation

public protocol YSLoaderProtocol {
    func load<T>(with url: String,
                 dataType: DataType,
                 completionHandler: @escaping Handler<T>)
    func load<T>(with url: String,
                 parameters: [String: String]?,
                 dataType: DataType,
                 completionHandler: @escaping Handler<T>)
    func cancelRequest()
}
