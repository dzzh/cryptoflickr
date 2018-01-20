//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import UIKit

protocol ImageBrowserViewModelDelegate: class {

    func didCompleteSearch()

    func didFetchMoreResults()
}

protocol ImageBrowserViewModelType: UICollectionViewDataSource {

    var delegate: ImageBrowserViewModelDelegate? { get set }

    func search(for term: String)

    func fetchMoreResults()
}

class ImageBrowserViewModel: NSObject {

    private var imageIds = [String]()
    weak var delegate: ImageBrowserViewModelDelegate?
}

extension ImageBrowserViewModel: ImageBrowserViewModelType {

    func search(for term: String) {
        delegate?.didCompleteSearch()
    }

    func fetchMoreResults() {
        delegate?.didFetchMoreResults()
    }
}

// MARK: - UICollectionViewDataSource

extension ImageBrowserViewModel {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
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