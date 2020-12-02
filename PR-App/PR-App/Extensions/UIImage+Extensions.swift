//
//  UIImage+Extensions.swift
//  PillReminder
//
//  Created by Jakub Homik on 01/12/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

extension UIImage {
    
    func imageOpacity(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
