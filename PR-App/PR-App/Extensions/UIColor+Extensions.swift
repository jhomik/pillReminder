//
//  UIColor+Extensions.swift
//  PR-App
//
//  Created by Jakub Homik on 01/09/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

extension UIColor {
    static var backgroundColor: UIColor {
        return UIColor(displayP3Red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
    }
    static var mainColor: UIColor {
        return UIColor(displayP3Red: 40/255, green: 209/255, blue: 204/255, alpha: 1)
    }
    static var backgroundColorTapToChangeLabel: UIColor {
        return UIColor(white: 0, alpha: 0.7)
    }
}
