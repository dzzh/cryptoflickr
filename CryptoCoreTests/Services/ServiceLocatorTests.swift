//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import XCTest
@testable import CryptoCore

class ServiceLocatorTests: XCTestCase {

    func testAddService() {
        let serviceLocator = ServiceLocator()

        var stubService: StubServiceType? = serviceLocator.getOptional()
        XCTAssertNil(stubService)

        serviceLocator.add(StubService() as StubServiceType)
        stubService = serviceLocator.getOptional()
        XCTAssertNotNil(stubService)
        XCTAssert(stubService is StubService)
    }

    func testRegistersAllServices() {
        let serviceLocator = ServiceLocator()

        guard let flickrService: ImageDownloadServiceType = serviceLocator.getOptional() else {
            XCTFail("No service")
            return
        }
        XCTAssert(flickrService is ImageDownloadServiceFlickr)
    }
}

private protocol StubServiceType {

}

private class StubService: StubServiceType {

}