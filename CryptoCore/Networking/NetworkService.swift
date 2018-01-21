//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

// ⚠️ Be aware that the completion blocks are performed on the background queue.
protocol NetworkServiceType {

    /// Perform a request that returns a network model of a given type
    /// - parameter request: a request to execute
    /// - parameter completion: completion block
    func requestModel<T: NetworkModel>(_ request: URLRequest,
                                       completion: @escaping (Result<T>) -> Void)

    /// Download the image at a provided URL.
    /// - parameter url: download url
    /// - parameter completion: completion block
    func downloadImage(at url: URL, completion: @escaping (Result<Data>) -> Void)

    /// Cancel all the tasks related to the current image download session and start a new session.
    func resetImageDownloadSession()
}

class NetworkService {

    private var imageDownloadSession: URLSession?
}

extension NetworkService: NetworkServiceType {

    func requestModel<T: NetworkModel>(_ request: URLRequest,
                                       completion: @escaping (Result<T>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            let result: Result<T>
            if let error = error {
                result = Result.failure(error.applicationError)
            } else {
                if let data = data, let model: T = T.decode(from: data) {
                    result = Result.success(model)
                } else {
                    result = Result.failure(.malformedResponse)
                }
            }
            completion(result)
        }.resume()
    }

    func downloadImage(at url: URL, completion: @escaping (Result<Data>) -> Void) {
        if imageDownloadSession == nil {
            createNewImageDownloadSession()
        }

        imageDownloadSession?.dataTask(with: url) { (data, response, error) -> Void in
            let result: Result<Data>
            if let error = error {
                result = .failure(error.applicationError)
            } else if let data = data {
                result = .success(data)
            } else {
                result = .failure(.malformedResponse)
            }
            completion(result)
        }.resume()
    }

    func resetImageDownloadSession() {
        imageDownloadSession?.invalidateAndCancel()
        imageDownloadSession = nil
    }
}

private extension NetworkService {

    func createNewImageDownloadSession() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        imageDownloadSession = URLSession(configuration: configuration)
    }
}