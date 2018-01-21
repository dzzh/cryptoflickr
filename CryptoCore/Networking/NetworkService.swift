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
}

class NetworkService {

    // MARK: - Constants

    private let operationQueueName = "networkQueue"

    // MARK: - State

    private let operationQueue = OperationQueue()

    // MARK: - Initialization

    init() {
        operationQueue.name = operationQueueName
        operationQueue.maxConcurrentOperationCount = 4
    }
}

extension NetworkService: NetworkServiceType {

    func requestModel<T: NetworkModel>(_ request: URLRequest,
                                       completion: @escaping (Result<T>) -> Void) {
        performRawRequest(request) { data, response, error in
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
        }
    }
}

private extension NetworkService {

    func performRawRequest(_ request: URLRequest,
                           completion externalCompletion: @escaping (Data?, URLResponse?, ApplicationError?) -> Void) {
        let internalCompletion: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            externalCompletion(data, response, error?.applicationError)
        }

        let operation = NetworkOperation(type: .data, request: request, completion: internalCompletion)
        operationQueue.addOperation(operation)
    }
}