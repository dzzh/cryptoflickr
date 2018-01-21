//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import CryptoCore

extension UIViewController {

    /// Present an alert with an error description
    /// - parameter error: error to present
    func presentError(_ error: ApplicationError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Agree and proceed", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
