//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

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
    }
}

extension ImageBrowserViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked search with text \(searchBar.text)")
    }
}