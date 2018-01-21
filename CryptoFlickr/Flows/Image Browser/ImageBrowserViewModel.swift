//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import CryptoCore
import os.log
import UIKit

struct ImagesCount {
    let totalImages: Int
    let addedImages: Int
}

protocol ImageBrowserViewModelType: UICollectionViewDataSource {

    func search(for term: String, completion: @escaping (Result<ImagesCount>) -> Void)

    var canFetchMoreResults: Bool { get }

    func fetchMoreResults(completion: @escaping (Result<ImagesCount>) -> Void)
}

class ImageBrowserViewModel: NSObject {

    private let imageDownloadService: ImageDownloadServiceType

    private var imageUrls = [URL]()

    // a storage of unique image URLs to prevent showing duplicate images
    private var uniqueUrls = Set<String>()

    // numbers of already fetched pages, is used for infinite scrolling implementation
    private var expectedPages = Set<Int>()

    private var currentSearchTerm = ""
    private var nextSearchPage = 0

    init(imageDownloadService: ImageDownloadServiceType) {
        self.imageDownloadService = imageDownloadService
    }
}

extension ImageBrowserViewModel: ImageBrowserViewModelType {

    func search(for term: String, completion: @escaping (Result<ImagesCount>) -> Void) {
        imageDownloadService.cancelPendingImageDownloads()

        nextSearchPage = 1
        currentSearchTerm = term
        expectedPages = Set<Int>()
        fetchImages(completion: completion)
    }

    var canFetchMoreResults: Bool {
        return !expectedPages.contains(nextSearchPage)
    }

    func fetchMoreResults(completion: @escaping (Result<ImagesCount>) -> Void) {
        guard canFetchMoreResults else {
            completion(.failure(.dataAlreadyFetched))
            return
        }

        expectedPages.insert(nextSearchPage)
        fetchImages { [weak self] result in
            if case .failure(_) = result {
                self?.expectedPages.remove(self?.nextSearchPage ?? 0)
            }
            completion(result)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ImageBrowserViewModel {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ImageCollectionViewCell else {
            os_log("Cannot dequeue image cell")
            return UICollectionViewCell()
        }

        cell.update(with: UIImage.imageWithColor(.lightGray, size: CGSize(width: 1000, height: 1000)))

        guard let url = imageUrls[safe: indexPath.row] else {
            return cell
        }

        let expectedTag = cell.tag
        imageDownloadService.downloadImageData(at: url) { [weak cell] (result: Result<Data>) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {

                    // Comparing the tags is necessary to prevent a dequeued cell can be updated with an image
                    // that was intended for the previous appearance of this cell. The tags are assigned randomly
                    // and are updated each time the cell is reused.
                    if expectedTag == cell?.tag {
                        cell?.update(with: image)
                    }
                }
            case.failure(let error):
                os_log("%@", error.localizedDescription)
            }
        }

        return cell
    }
}

private extension ImageBrowserViewModel {

    func fetchImages(completion: @escaping (Result<ImagesCount>) -> Void) {
        guard !currentSearchTerm.isEmpty, nextSearchPage > 0 else {
            os_log("Inconsistent state")
            completion(.failure(.internalError))
            return
        }

        imageDownloadService.fetchImageUrls(searchTerm: currentSearchTerm, page: nextSearchPage) { [weak self] (result: Result<[URL]>) in
            switch result {
            case .success(let urls):
                // First search for the new query, need to reset current images
                if self?.nextSearchPage == 1 {
                    self?.imageUrls = urls
                    self?.uniqueUrls = Set<String>()
                    for url in (self?.imageUrls ?? []) {
                        self?.uniqueUrls.insert(url.path)
                    }
                    completion(.success(ImagesCount(totalImages: urls.count, addedImages: urls.count)))
                // Search for one of consequent pages, add new results to the list
                } else {
                    var addedImages = 0
                    for url in urls {
                        if !(self?.uniqueUrls.contains(url.path) ?? true) {
                            self?.imageUrls.append(url)
                            self?.uniqueUrls.insert(url.path)
                            addedImages += 1
                        }
                    }
                    completion(.success(ImagesCount(totalImages: self?.imageUrls.count ?? 0, addedImages: addedImages)))
                }
                self?.nextSearchPage += 1
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}