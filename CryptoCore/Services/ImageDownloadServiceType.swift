//
// Created by Zmicier Zaleznicenka on 20/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public protocol ImageDownloadServiceType {

    func fetchImageUrls(searchTerm: String, page: Int, completion: @escaping (Result<[URL]>) -> Void)
}
