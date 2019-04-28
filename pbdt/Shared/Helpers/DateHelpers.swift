//
//  DateHelpers.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/10/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func removeTimeStamp(fromDate: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.current
        
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to remove time stamp from Date object")
        }
        
        return date
    }
    
    func toString(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
