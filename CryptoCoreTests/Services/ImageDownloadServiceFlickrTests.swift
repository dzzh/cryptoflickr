//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import XCTest
@testable import CryptoCore

class ImageDownloadServiceFlickrTests: XCTestCase {

    func testImageUrlsMapping() {

        guard let data = FlickrImagesListFixtures.resultsJson.data(using: .utf8),
              let imagesListWrapper: FlickrImagesListWrapper = FlickrImagesListWrapper.decode(from: data) else {
            XCTFail("Couldn't decode data")
            return
        }

        let networkService = StubNetworkService(imagesListWrapper: imagesListWrapper)
        guard let service = ImageDownloadServiceFlickr(networkService: networkService) else {
            XCTFail("Couldn't create Flickr service")
            return
        }

        let expectation = self.expectation(description: "async")

        service.fetchImageUrls(searchTerm: "term", page: 1) { result in
            if case let .success(urls) = result {
                XCTAssertEqual(7, urls.count)
                XCTAssertEqual("https://farm5.staticflickr.com/4614/28033364809_f5a3538047.jpg", urls.first?.absoluteString)
            } else {
                XCTFail("Unexpected result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

}
