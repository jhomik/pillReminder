//
//  PillViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 29/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class PillViewModel {
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
    var program: [String] {
        return model.program
    }
    
    func newPasswordCheck(passOne: String, passTwo: String) -> Bool {
        if passOne == passTwo {
            return true
        } else {
            return false
        }
    }
    
    func textFieldsShaker(inputFields: [CustomTextField]) {
        for x in inputFields {
            if x.text!.isEmpty {
                x.shake()
            }
        }
    }
}
