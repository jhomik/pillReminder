//
//  Double+Extension.swift
//  PillReminder
//
//  Created by Jakub Homik on 28/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import UIKit

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
