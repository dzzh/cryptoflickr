//
// Created by Zmicier Zaleznicenka on 21/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

extension UIImage {

    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)

        let context = UIGraphicsGetCurrentContext()
        let frame = CGRect(origin: CGPoint.zero, size: size)
        context?.setFillColor(color.cgColor)
        context?.fill(frame)

        let result = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return result
    }
}