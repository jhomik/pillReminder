//
//  Data.swift
//  PR-App
//
//  Created by Jakub Homik on 31/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

struct PillModel {

    let frequency = [Constants.everyDay]
    let howManyTimesPerDay = [Constants.onceADayArray, Constants.twiceADayArray, Constants.threeTimesADayArray]
    let dosage = ["1", "1/2", "1/4"]
}

enum PillOfTheDay {
    case first
    case second
    case last
}
