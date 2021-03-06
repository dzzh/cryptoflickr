//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

// Result of an operation, usually an asynchronous one.
public enum Result<T> {
    case success(T)
    case failure(ApplicationError)
}
