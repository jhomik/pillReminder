//
//  Data.swift
//  PR-App
//
//  Created by Jakub Homik on 31/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

struct PillModel {

    let frequency = ["Everyday", "Every second day"]
    let howManyTimesPerDay = ["Once a day", "Twice a day", "Three times a day"]
    let dosage = ["1", "1/2", "1/4"]
    let sections = ["Frequency", "How many times per day?", "What time?", "Dosage"]
}

enum PillOfTheDay {
    case first
    case second
    case last
}
