//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import CryptoCore
import os.log
import UIKit

protocol ImageBrowserViewModelType: UICollectionViewDataSource {

    func search(for term: String, completion: @escaping (ApplicationError?) -> Void)

    func fetchMoreResults(completion: @escaping (ApplicationError?) -> Void)
}

class ImageBrowserViewModel: NSObject {

    private let imageDownloadService: ImageDownloadServiceType

    private var imageURLs = [URL]()
    private var currentSearchTerm = ""
    private var nextSearchPage = 0

    init(imageDownloadService: ImageDownloadServiceType) {
        self.imageDownloadService = imageDownloadService
    }
}

extension ImageBrowserViewModel: ImageBrowserViewModelType {

    func search(for term: String, completion: @escaping (ApplicationError?) -> Void) {
        nextSearchPage = 1
        currentSearchTerm = term
        fetchImages(completion: completion)
    }

    func fetchMoreResults(completion: @escaping (ApplicationError?) -> Void) {
        fetchImages(completion: completion)
    }
}

// MARK: - UICollectionViewDataSource

extension ImageBrowserViewModel {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ImageCollectionViewCell else {
            os_log("Cannot dequeue image cell")
            return UICollectionViewCell()
        }

        cell.update(with: UIImage.imageWithColor(.lightGray, size: CGSize(width: 1000, height: 1000)))

        guard let url = imageURLs[safe: indexPath.row] else {
            return cell
        }

        imageDownloadService.downloadImageData(at: url) { [weak cell] (result: Result<Data>) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    cell?.update(with: image)
                }
            case.failure(let error):
                os_log("%@", error.localizedDescription)
            }
        }

        return cell
    }
}

private extension ImageBrowserViewModel {

    func fetchImages(completion: @escaping (ApplicationError?) -> Void) {
        guard !currentSearchTerm.isEmpty, nextSearchPage > 0 else {
            os_log("Inconsistent state")
            completion(.internalError)
            return
        }

        if nextSearchPage == 1 {
            imageDownloadService.cancelPendingImageDownloads()
        }

        imageDownloadService.fetchImageUrls(searchTerm: currentSearchTerm, page: nextSearchPage) { [weak self] (result: Result<[URL]>) in
            switch result {
            case .success(let urls):
                // First search for the new query, need to reset current images
                if self?.nextSearchPage == 1 {
                    self?.imageURLs = urls
                    completion(nil)
                // Search for one of consequent pages, add new results to the list
                } else {
                    self?.imageURLs.append(contentsOf: urls)
                    completion(nil)
                }
                self?.nextSearchPage += 1
            case .failure(let error):
                completion(error)
            }
        }
    }
}