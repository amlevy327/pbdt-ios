//
//  Constants.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/6/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

struct ActivityIndicatorConstants {
    
    static let type: NVActivityIndicatorType = .ballSpinFadeLoader
    static let color: UIColor = UIColor.spinnerColor()
    static let frame: CGRect = CGRect(x: 0, y: 0, width: 50, height: 50)
}

struct ButtonConstants {
    
    static let shadowOffset: CGSize = CGSize(width: 0, height: 4)
    static let shadowOpacity:Float = Float(0.7)
}

struct UIMessages {
    
    // input errors
    static let kInputFormatIncorrect = "Input format incorrect"
    static let kInputBlank = "Input cannot be blank"
    static let kInputZero = "Input must be greater than zero"
    
    // entries
    static let kEntryAdded = "Food added!"
    static let kEntryUpdated = "Food updated!"
    static let kEntryDeleted = "Food deleted!"
    
    // ingredients
    static let kIngredientAdded = "Ingredient added!"
    static let kIngredientUpdated = "Ingredient updated!"
    static let kIngredientDeleted = "Ingredient deleted!"
    
    // recipe
    static let kRecipeAdded = "Recipe added!"
    static let kRecipeUpdated = "Recipe updated!"
    static let kRecipeDeleted = "Recipe deleted!"
    
    // goals
    static let kGoalsUpdated = "Goals updated!"
    
    // error
    static let kErrorGeneral = "We encountered an error. Please try again later."
    static let kErrorEmailPassword = "Email and password combination incorrect"
    static let kErrorPasswordNoMatch = "Passwords do not match"
    static let kErrorPasswordLength = "Password must be at least 6 characters"
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
