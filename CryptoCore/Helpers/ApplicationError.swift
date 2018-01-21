//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public enum ApplicationError: Error {
    case internalError
    case malformedResponse
    case networkOperationCancelled
    case networkOperationTimedOut
    case unknown
}

extension Error {

    public var applicationError: ApplicationError {
        os_log("Expected ApplicationError, got %@", self.localizedDescription)
        return self as? ApplicationError ?? ApplicationError.unknown
    }
}

