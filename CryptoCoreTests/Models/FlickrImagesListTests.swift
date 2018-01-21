//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import XCTest
@testable import CryptoCore

class FlickrImagesListTests: XCTestCase {

    func testDecodeResultsJson() {
        guard let data = FlickrImagesListFixtures.resultsJson.data(using: .utf8),
            let imagesListWrapper: FlickrImagesListWrapper = FlickrImagesListWrapper.decode(from: data) else {
            XCTFail("Couldn't decode data")
            return
        }

        XCTAssertEqual(FlickrImagesListWrapper.Status.success, imagesListWrapper.status)
        XCTAssertNil(imagesListWrapper.errorCode)
        XCTAssertNil(imagesListWrapper.errorMessage)

        guard let imagesList = imagesListWrapper.imagesList, 
            let firstImage = imagesList.images.first else {
            XCTFail("No images found")
            return
        }

        XCTAssertEqual(1, imagesList.pageNumber)
        XCTAssertEqual(2921, imagesList.numberOfPages)
        XCTAssertEqual(100, imagesList.imagesPerPage)
        XCTAssertEqual("292073", imagesList.totalNumberOfImages)
        XCTAssertEqual(7, imagesList.images.count)

        XCTAssertEqual("28033364809", firstImage.id)
        XCTAssertEqual("132791403@N08", firstImage.owner)
        XCTAssertEqual("f5a3538047", firstImage.secret)
        XCTAssertEqual("4614", firstImage.server)
        XCTAssertEqual(5, firstImage.farm)
        XCTAssertEqual("first image title", firstImage.title)
        XCTAssertEqual(1, firstImage.isPublic)
        XCTAssertEqual(0, firstImage.isFriend)
        XCTAssertEqual(0, firstImage.isFamily)

        let expectedUrl = "https://farm5.staticflickr.com/4614/28033364809_f5a3538047.jpg"
        XCTAssertEqual(expectedUrl, firstImage.url?.absoluteString)
    }

    func decodeErrorJson() {
        guard let data = FlickrImagesListFixtures.resultsJson.data(using: .utf8),
              let imagesListWrapper: FlickrImagesListWrapper = FlickrImagesListWrapper.decode(from: data) else {
            XCTFail("Couldn't decode data")
            return
        }

        XCTAssertEqual(FlickrImagesListWrapper.Status.failure, imagesListWrapper.status)
        XCTAssertEqual(112, imagesListWrapper.errorCode)
        XCTAssertEqual("Something went wrong", imagesListWrapper.errorMessage)
        XCTAssertNil(imagesListWrapper.imagesList)
    }
}