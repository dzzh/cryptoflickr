//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import XCTest

@testable import CryptoCore
@testable import CryptoFlickr

class ImageBrowserViewModelTests: XCTestCase {

    func testSearchFlow() {
        let expectation = self.expectation(description: "ready")
        let viewModel = ImageBrowserViewModel(imageDownloadService: imageDownloadService)

        viewModel.search(for: "query") { result in
            switch result {
            case .success(let imagesCount):
                XCTAssertEqual(3, imagesCount.totalImages)
                XCTAssertEqual(3, imagesCount.addedImages)

                viewModel.fetchMoreResults { result in
                    switch result {
                    case .success(let imagesCount):
                        XCTAssertEqual(2, imagesCount.addedImages)
                        XCTAssertEqual(5, imagesCount.totalImages)
                    case .failure(_):
                        XCTFail("Unexpected result")
                    }
                    expectation.fulfill()
                }

            case .failure(_):
                XCTFail("Unexpected result")
            }
        }

        wait(for: [expectation], timeout: 1)
    }

}

private extension ImageBrowserViewModelTests {

    var imageDownloadService: ImageDownloadServiceType {
        let firstPageUrls: [URL] = [
            URL(string: "https://example.com/1")!,
            URL(string: "https://example.com/2")!,
            URL(string: "https://example.com/3")!,
        ]

        let secondPageUrls: [URL] = [
            URL(string: "https://example.com/3")!, // a duplicate of a first-page url
            URL(string: "https://example.com/4")!,
            URL(string: "https://example.com/5")!,
        ]

        let urls: [Int: [URL]] = [
            1: firstPageUrls,
            2: secondPageUrls
        ]

        return StubImageDownloadService(imageUrlsPerPage: urls)
    }
}
