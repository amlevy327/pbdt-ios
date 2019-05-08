//
//  DoubleHelpers.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/19/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation

extension Double {
    
    func isInt() -> Bool {
        return self.truncatingRemainder(dividingBy: 1) == 0
        
        /*
        if input.truncatingRemainder(dividingBy: 1) == 0 {
            return true
        } else {
            return false
        }
        */
    }
    
    func roundToPlaces(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
