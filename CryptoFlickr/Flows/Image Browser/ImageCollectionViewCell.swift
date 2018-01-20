//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ImageCollectionViewCell"

    // MARK: - UI elements

    private let imageView = UIImageView()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - UICollectionViewCell

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - Interface

    func update(with image: UIImage) {
        imageView.image = image
    }
}

private extension ImageCollectionViewCell {

    func setup() {

        imageView.contentMode = .scaleAspectFit

        add(imageView)

        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
