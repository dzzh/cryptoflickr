//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public enum HttpMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}

class NetworkUtils {

    class func jsonRequest(urlComponents: URLComponents, method: HttpMethod = .get, body: Data? = nil) -> URLRequest? {
        guard let url = urlComponents.url else {
            os_log("Couldn't create a URL from given url components %@", urlComponents.string ?? "n/a")
            return nil
        }

        var request = baseJsonRequest(for: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}

private extension NetworkUtils {

    class func baseJsonRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

