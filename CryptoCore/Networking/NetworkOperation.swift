//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

// TODO: add support for download type
// TODO: decrease priority for download operation

enum NetworkOperationType {
    case data
    case download
}

class NetworkOperation: BlockOperation {

    private let request: URLRequest
    private let completion: (Data?, URLResponse?, Error?) -> Void

    init(type: NetworkOperationType, request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.request = request
        self.completion = completion
        super.init()
        addExecutionBlock(requestBlock)
    }

    private var requestBlock: () -> Void {
        return {
            URLSession.shared.dataTask(with: self.request) { [weak self] (data, response, error) in
                self?.completion(data, response, error)
            }.resume()
        }
    }
}
