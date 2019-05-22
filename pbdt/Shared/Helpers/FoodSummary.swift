//
//  FoodSummary.swift
//  pbdt
//
//  Created by Andrew M Levy on 5/13/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation

struct SummaryItem {
    
    var name: String!
    var amount: Double = 0.0
    var goal: Double = 0.0
}

class SummaryArray {
    
    var beans = SummaryItem(name: "Beans", amount: 0, goal: appDelegate.currentUser.beansG)
    var berries: SummaryItem!
    
    var foodGroupsArray: [SummaryItem]!
    var nutritionArray: [SummaryItem]!
    
    
    func setInitialValues() {
        foodGroupsArray = [beans, berries]
        
        //let sumBeans = foodGroupsArray.firstIndex { ( $0.name == "beans" ) }
        //beans.amount =
    }
}
