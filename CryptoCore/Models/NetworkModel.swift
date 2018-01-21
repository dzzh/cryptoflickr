//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

protocol NetworkModel: Decodable, CustomDebugStringConvertible {

    static var decoder: JSONDecoder { get }

    static func decode<T: NetworkModel>(from json: String) -> T?
    static func decode<T: NetworkModel>(from data: Data) -> T?

    static func decodeArray<T: NetworkModel>(from data: Data) -> [T]?
    static func decodeArray<T: NetworkModel>(from json: String) -> [T]?
}

extension NetworkModel {

    // MARK: - Decoding

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

    public static func decode<T: NetworkModel>(from json: String) -> T? {
        guard let data = json.data(using: .utf8) else {
            os_log("Couldn't convert json string \"%@\" to data", json)
            return nil
        }
        return T.decode(from: data)
    }

    public static func decodeArray<T: NetworkModel>(from data: Data) -> [T]? {
        do {
            let dict = try decoder.decode([String: T].self, from: data)
            return dict.map { (key, value) -> T in return value }
        } catch {
            os_log("Caught an error when decoding [%@]: %@", String(describing: T.self), error.localizedDescription)
            return nil
        }
    }

    public static func decodeArray<T: NetworkModel>(from json: String) -> [T]? {
        guard let data = json.data(using: .utf8) else {
            os_log("Couldn't convert json string \"%@\" to data", json)
            return nil
        }
        return T.decodeArray(from: data)
    }

    // MARK: - CustomDebugStringConvertible

    public var debugDescription: String {
        return "\(type(of: self))"
    }
}
