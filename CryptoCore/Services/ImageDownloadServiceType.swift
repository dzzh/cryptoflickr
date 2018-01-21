//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public protocol ImageDownloadServiceType {

    /// Fetch the images matching a given search term
    /// - parameter searchTerm: search term
    /// - parameter page: search results page
    /// - parameter completion: completion block
    func fetchImageUrls(searchTerm: String, page: Int, completion: @escaping (Result<[URL]>) -> Void)

    /// Download the image available at a provided URL and return it in Data format
    /// - parameter url: image URL
    /// - parameter completion: completion block
    func downloadImageData(at url: URL, completion: @escaping (Result<Data>) -> Void)

    /// If there are pending image downloads in the network queue, cancel them
    func cancelPendingImageDownloads()
}
