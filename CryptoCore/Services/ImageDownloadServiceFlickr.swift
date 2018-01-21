//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

class ImageDownloadServiceFlickr {

    // MARK: - Constants

    private let apiKeyPlistKey = "FlickrApiKey"

    // MARK: - State

    private let networkService: NetworkServiceType
    private let apiKey: String

    // MARK: - Initialization

    init?(networkService: NetworkServiceType) {
        guard let infoDict = Bundle(for: ImageDownloadServiceFlickr.self).infoDictionary,
            let apiKey = infoDict[apiKeyPlistKey] as? String else {
            os_log("Cannot instantiate Flickr service: can't get API key")
            return nil
        }
        self.networkService = networkService
        self.apiKey = apiKey
    }
}

extension ImageDownloadServiceFlickr: ImageDownloadServiceType {

    public func fetchImageUrls(searchTerm: String, page: Int, completion: @escaping (Result<[URL]>) -> Void) {
        guard let request = imageUrlsRequest(text: searchTerm, page: page) else {
            os_log("Couldn't create fetch images request for search term %@ and page %d", searchTerm, page)
            completion(.failure(.internalError))
            return
        }

        networkService.requestModel(request) { (result: Result<FlickrImagesListWrapper>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let wrapper):
                    let imageUrls = wrapper.imagesList?.images.flatMap { $0.url } ?? []
                    completion(.success(imageUrls))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    public func downloadImageData(at url: URL, completion: @escaping (Result<Data>) -> Void) {
        networkService.downloadImage(at: url) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    public func cancelPendingImageDownloads() {
        networkService.resetImageDownloadSession()
    }
}

private extension ImageDownloadServiceFlickr {

    func imageUrlsRequest(text: String, page: Int) -> URLRequest? {
        var components = urlComponents
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "safe_search", value: "1"),
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "page", value: String(page))
        ])

        return NetworkUtils.jsonRequest(urlComponents: components)
    }

    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.flickr.com"
        urlComponents.path = "/services/rest"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        return urlComponents
    }
}