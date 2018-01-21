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

        cell.update(with: UIImage.imageWithColor(.red, size: CGSize(width: 1000, height: 1000)))
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

// TODO kill, testing code

private extension UIImage {

    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)

        let context = UIGraphicsGetCurrentContext()
        let frame = CGRect(origin: CGPoint.zero, size: size)
        context?.setFillColor(color.cgColor)
        context?.fill(frame)

        let result = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return result!
    }
}