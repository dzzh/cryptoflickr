//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

protocol NetworkModel: Decodable {

    static var decoder: JSONDecoder { get }

    static func decode<T: NetworkModel>(from data: Data) -> T?
}

extension NetworkModel {

    public static var decoder: JSONDecoder {
        return JSONDecoder()
    }

    public static func decode<T: NetworkModel>(from data: Data) -> T? {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            os_log("Caught an error when decoding %@: %@", String(describing: T.self), error.localizedDescription)
            return nil
        }
    }
}
