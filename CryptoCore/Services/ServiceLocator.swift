//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

/// A storage of application services
public protocol ServiceLocatorType {

    /// Add a service to the storage
    /// - parameter service: a service to add
    func add<T>(_ service: T)

    /// Fetch the service of a given type from the storage
    /// - return: a stored service or nil if the service is not stored
    func getOptional<T>() -> T?
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

