//
//  UIColor+Extensions.swift
//  PR-App
//
//  Created by Jakub Homik on 01/09/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.secondarySystemBackground
        } else {
            return UIColor(displayP3Red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        }
    }
    
    static var textFieldUnderline = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.white
        } else {
            return UIColor(displayP3Red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        }
    }
    
    static var cellBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.systemGray5
        } else {
            return UIColor.systemBackground
        }
    }
    
    static var mainColor: UIColor {
        return UIColor(displayP3Red: 21/255, green: 236/255, blue: 202/255, alpha: 1)
    }
    
    static var backgroundColorTapToChangeLabel = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(white: 255, alpha: 0.5)
        } else {
            return UIColor(white: 0, alpha: 0.7)
        }
    }
}
