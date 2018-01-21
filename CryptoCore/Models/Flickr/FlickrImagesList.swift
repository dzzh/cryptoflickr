//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

struct FlickrImagesListWrapper: NetworkModel {

    enum Status: String {
        case success = "ok"
        case failure = "fail"
    }

    enum CodingKeys: String, CodingKey {
        case imagesList = "photos"
        case statusMessage = "stat"
        case errorCode = "code"
        case errorMessage = "message"
    }

    let imagesList: FlickrImagesList?
    let statusMessage: String
    let errorCode: Int?
    let errorMessage: String?

    var status: Status {
        return Status(rawValue: statusMessage) ?? .failure
    }
}

struct FlickrImagesList: NetworkModel {

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page"
        case numberOfPages = "pages"
        case imagesPerPage = "perpage"
        case totalNumberOfImages = "total"
        case images = "photo"
    }

    let pageNumber: Int
    let numberOfPages: Int
    let imagesPerPage: Int
    let totalNumberOfImages: String
    let images: [FlickrImageModel]
}
