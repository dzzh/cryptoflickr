//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
@testable import CryptoCore

class StubNetworkService {

    var imagesListWrapper: FlickrImagesListWrapper?

    init(imagesListWrapper: FlickrImagesListWrapper?) {
        self.imagesListWrapper = imagesListWrapper
    }
}

extension StubNetworkService: NetworkServiceType {

    func requestModel<T: NetworkModel>(_ request: URLRequest, completion: @escaping (Result<T>) -> Void) {
        let modelType = String(describing: T.self)
        switch modelType {
        case String(describing: FlickrImagesListWrapper.self):
            if let imagesListWrapper = imagesListWrapper, let castedWrapper = imagesListWrapper as? T {
                completion(.success(castedWrapper))
            } else {
                completion(.failure(.internalError))
            }
        default:
            completion(.failure(.internalError))
        }
    }

    func downloadImage(at url: URL, completion: @escaping (Result<Data>) -> Void) {
        completion(.failure(.internalError))
    }

    func resetImageDownloadSession() {

    }
}
