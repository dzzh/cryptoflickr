//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import UIKit

class ImageBrowserViewController: UIViewController {

    // MARK: - State

    private let viewModel: ImageBrowserViewModelType
    private let castedView: ImageBrowserView
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Initialization

    init(viewModel: ImageBrowserViewModelType) {
        self.viewModel = viewModel
        self.castedView = ImageBrowserView(searchBar: searchController.searchBar)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - UIViewController lifecycle

    override func loadView() {
        view = castedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchBar.placeholder = "crypto search"
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false

        castedView.collectionView.dataSource = viewModel
        castedView.collectionView.delegate = self

        definesPresentationContext = true
    }
}

extension ImageBrowserViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {
            os_log("Expected to have text in a search bar")
            return
        }

        castedView.switchState(to: .searching)
        viewModel.search(for: searchTerm) { [weak self] error in
            if let error = error {
                self?.searchController.presentError(error)
                self?.castedView.switchState(to: .initial)
            } else {
                self?.castedView.scrollToTop()
                self?.castedView.updateSearchResults()
                self?.castedView.switchState(to: .searchResults)
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        castedView.switchState(to: .initial)
    }
}

extension ImageBrowserViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return castedView.cellSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: castedView.cellMargin, left: castedView.cellMargin,
            bottom: castedView.cellMargin, right: castedView.cellMargin)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return castedView.cellMargin
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return castedView.cellMargin
    }
}