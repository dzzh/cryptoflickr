//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

class NetworkOperation: Operation {

    enum OperationType {
        case imageDownload
        case generic
    }

    let type: OperationType

    private let request: URLRequest
    private let completion: (Data?, URLResponse?, ApplicationError?) -> Void

    init(request: URLRequest, type: OperationType = .generic,
         completion: @escaping (Data?, URLResponse?, ApplicationError?) -> Void) {
        self.request = request
        self.type = type
        self.completion = completion
    }

    override func main() {
        print("executing \(request.url?.query ?? "")")

        if isCancelled {
            completion(nil, nil, .networkOperationCancelled)
        }

        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if self?.isCancelled ?? false {
                self?.completion(nil, nil, .networkOperationCancelled)
            }

            self?.completion(data, response, error?.applicationError)
            print("completed \(self?.request.url?.query ?? "")")
        }.resume()
    }
}
