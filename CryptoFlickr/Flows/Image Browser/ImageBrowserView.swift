//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

enum ImageBrowserViewState {
    case initial
    case noResults
    case searching
    case searchResults

    var emptyLabelText: String? {
        switch self {
        case .initial: return "all you need is 🔍,\nall you need is 🔎,\nall you need is 🔍,\n🔎,\n🔍 is all you need"
        case .noResults: return "no results, not even a single one\n¯\\_(ツ)_/¯"
        case .searching: return "patience..."
        case .searchResults: return nil
        }
    }
}

class ImageBrowserView: UIView {

    // MARK: - Constants

    let cellMargin: CGFloat = 4
    private let numberOfColumns = 3
    private let searchBarHeight: CGFloat = 56
    private let animationDuration: TimeInterval = 0.2

    // After the user scrolls the collection until bottom-distanceToBottom, we will request to fetch more search results.
    // Fetching the next results page before actually reaching the bottom of the screen makes UX better (allegedly).
    private let distanceToBottomToFetchMoreData: CGFloat = 200

    // MARK: - UI elements

    private let searchContainer = UIView()
    private let searchBar: UISearchBar

    private let contentGuide = UILayoutGuide()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let emptyStateContainer = UIView()
    private let emptyStateLabel = UILabel()

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    init(searchBar: UISearchBar) {
        self.searchBar = searchBar
        super.init(frame: CGRect.zero)
        setup()
        switchState(to: .initial, animated: false)
    }

    // MARK: - UIView

    override func layoutSubviews() {
        super.layoutSubviews()

        // Search bar doesn't play nicely with a collection view. I didn't manage to make it work properly with autolayout.
        searchBar.frame = CGRect(origin: CGPoint.zero,
            size: CGSize(width: searchContainer.bounds.size.width, height: searchBarHeight))
    }

    // MARK: - Interfaces

    var cellSize: CGSize {
        let width: CGFloat = (bounds.width - cellMargin * CGFloat(numberOfColumns + 1)) / CGFloat(numberOfColumns)
        return CGSize(width: width, height: width)
    }

    func switchState(to state: ImageBrowserViewState, animated: Bool = true) {
        emptyStateLabel.text = state.emptyLabelText
        UIView.animate(withDuration: animated ? animationDuration : 0, animations: { [unowned self] in
            if case .searchResults = state {
                self.collectionView.alpha = 1
                self.emptyStateContainer.alpha = 0
            } else {
                self.collectionView.alpha = 0
                self.emptyStateContainer.alpha = 1
            }
        })
    }

    /// Fully reload the collection view
    /// - parameter completion: completion block
    func reloadSearchResults(completion: @escaping (Bool) -> Void) {
        collectionView.performBatchUpdates({ [unowned self] in
            self.collectionView.reloadSections([0])
        }, completion: completion)
    }

    /// Update the collection view after a new page of results was added
    /// - parameter imagesCount: new count of search results
    func addSearchResults(_ imagesCount: ImagesCount) {
        let firstIndex = imagesCount.totalImages - imagesCount.addedImages
        var addedIndexPaths = [IndexPath]()
        for i in firstIndex..<imagesCount.totalImages {
            addedIndexPaths.append(IndexPath(row: i, section: 0))
        }
        collectionView.performBatchUpdates({ [unowned self] in
            self.collectionView.insertItems(at: addedIndexPaths)
        }, completion: nil)
    }

    func scrollToTop() {
        collectionView.setContentOffset(CGPoint.zero, animated: false)
    }

    func didReachBottom(_ contentOffset: CGPoint) -> Bool {
        let maxOffset = collectionView.contentSize.height - collectionView.bounds.height
        return maxOffset > 0 && maxOffset - contentOffset.y < distanceToBottomToFetchMoreData
    }
}

private extension ImageBrowserView {

    func setup() {

        // MARK: - Configure subviews

        backgroundColor = .white
        collectionView.backgroundColor = .white

        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .prominent

        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0

        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)

        // MARK: - Layout subviews

        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateContainer.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        add(searchContainer)
        searchContainer.addSubview(searchBar)

        addLayoutGuide(contentGuide)
        add(collectionView)
        add(emptyStateContainer)
        emptyStateContainer.add(emptyStateLabel)

        searchContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        searchContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchContainer.bottomAnchor.constraint(equalTo: contentGuide.topAnchor).isActive = true
        searchContainer.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true

        contentGuide.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        contentGuide.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        contentGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        collectionView.topAnchor.constraint(equalTo: contentGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1).isActive = true

        emptyStateContainer.topAnchor.constraint(equalTo: contentGuide.topAnchor).isActive = true
        emptyStateContainer.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor).isActive = true
        emptyStateContainer.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor).isActive = true
        emptyStateContainer.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor).isActive = true

        emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateContainer.centerXAnchor).isActive = true
        emptyStateLabel.centerYAnchor.constraint(equalTo: emptyStateContainer.centerYAnchor).isActive = true
    }
}
