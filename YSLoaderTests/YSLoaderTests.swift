//
//  YSLoaderTests.swift
//  YSLoaderTests
//
//  Created by Yahya Saddiq on 10/9/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import XCTest
@testable import YSLoader
@testable import Alamofire

class YSLoaderTests: XCTestCase {

    var sut: YSLoader!
    override func setUp() {
        let manager: SessionManager = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()

            return SessionManager(configuration: configuration)
        }()
        sut = YSLoader(manager: manager)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testFailureLoad() {
        MockURLProtocol.responseWithFailure()
        let closureExpectation = expectation(description: "Done")
        sut?.load(with: "http://pastebin.com/raw/wgkJgazE",
                 dataType: .json) { (result: Swift.Result<Data, Error>) in
                    closureExpectation.fulfill()

        }
        wait(for: [closureExpectation], timeout: 1)
    }

    func testSuccessLoad() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        let closureExpectation = expectation(description: "Done")
        sut?.load(with: "http://pastebin.com/raw/wgkJgazE",
                  dataType: .image) { (result: Swift.Result<Data, Error>) in
                    closureExpectation.fulfill()

        }
        wait(for: [closureExpectation], timeout: 1)
    }
}
