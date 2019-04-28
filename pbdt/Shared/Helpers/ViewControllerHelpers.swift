//
//  ViewControllerHelpers.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/26/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func dotsCount(inputString: String) -> Int {
        
        let filteredInput = inputString.filter() { $0 == "." }
        return filteredInput.count
    }
}
