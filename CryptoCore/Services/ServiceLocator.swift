//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public protocol ServiceLocatorType {

    func add<T>(_ service: T)

    func getOptional<T>() -> T?

    func getUnwrapped<T>() -> T
}

public class ServiceLocator {

    private var services: Dictionary<String, Any> = [:]

    public init() {
        registerServices()
    }
}

extension ServiceLocator: ServiceLocatorType {

    public func add<T>(_ service: T) {
        let serviceKey = "\(type(of: service))"
        services[serviceKey] = service
    }

    public func getOptional<T>() -> T? {
        let serviceKey = String(describing: T.self)
        return services[serviceKey] as? T
    }

    public func getUnwrapped<T>() -> T {
        return getOptional()!
    }
}

private extension ServiceLocator {

    private func registerServices() {
        let networkService = NetworkService()
        guard let flickrService = ImageDownloadServiceFlickr(networkService: networkService) else {
            fatalError("Couldn't instantiate Flickr service")
        }
        add(flickrService as ImageDownloadServiceType)
    }

    private func name(of some: Any) -> String {
        return some is Any.Type ? String(describing: some) : "\(type(of: some))"
    }
}

