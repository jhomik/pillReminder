//
//  PillModelViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 10/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class PillModelViewModel {
    
    private var model = PillModel()
    
    var morning: [String] {
        return model.morning
    }
    var noon: [String] {
        return model.noon
    }
    var evening: [String] {
        return model.evening
    }
    var sections: [String] {
        return model.sections
    }
}
