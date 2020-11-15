//
//  UIImage+Extensions.swift
//  PR-App
//
//  Created by Jakub Homik on 15/11/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

extension UIImage {
    
    func withAlphaComponent(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
