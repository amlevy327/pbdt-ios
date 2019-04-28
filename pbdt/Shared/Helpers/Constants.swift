//
//  Constants.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/6/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation

struct UIMessages {
    
    // input errors
    static let kInputFormatIncorrect = "Input format incorrect"
    static let kInputBlank = "Input cannot be blank"
    static let kInputZero = "Input must be greater than zero"
    
    // entries
    static let kEntryAdded = "Food added!"
    static let kEntryUpdated = "Food updated!"
    
    // goals
    static let kGoalsUpdated = "Goals updated!"
    
    // error
    static let kErrorGeneral = "We encountered an error. Please try again later."
}

struct StaticLists {
    
    static let servingsNameArray = [
        "Beans",
        "Berries",
        "Other fruits",
        "Cruciferous vegetables",
        "Greens",
        "Other vegetables",
        "Flaxseeds",
        "Nuts",
        "Turmeric",
        "Whole grains",
        "Other seeds"
    ]
    
    static let macrosNameArray = [
        "Calories",
        "Fat",
        "Carbs",
        "Protein"
    ]
    
    static let beansArray = [
        "Beans"
    ]
}
