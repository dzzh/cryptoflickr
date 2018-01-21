//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
@testable import CryptoCore

class StubImageDownloadService: ImageDownloadServiceType {

    var imageUrlsPerPage = [Int: [URL]]()

    init(imageUrlsPerPage: [Int: [URL]]? = nil) {
        if let imageUrlsPerPage = imageUrlsPerPage {
            self.imageUrlsPerPage = imageUrlsPerPage
        }
    }

    func fetchImageUrls(searchTerm: String, page: Int, completion: @escaping (Result<[URL]>) -> Void) {
        if let urls = imageUrlsPerPage[page] {
            completion(.success(urls))
        } else {
            completion(.failure(.internalError))
        }
    }

    func downloadImageData(at url: URL, completion: @escaping (Result<Data>) -> Void) {
        completion(.failure(.internalError))
    }

    func cancelPendingImageDownloads() {

    }
}

