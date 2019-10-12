//
//  YSLoader+Result.swift
//  YSLoader
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation

public enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}
