//
//  ViewExtensions.swift
//  GoodLion
//
//  Created by AJ Caldwell on 5/1/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

// https://nshipster.com/ibinspectable-ibdesignable/
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UIImageView {
    func setImage(from url: URL) {
        kf.setImage(with: url)
    }
}

