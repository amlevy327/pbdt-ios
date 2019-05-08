//
//  StringHelpers.swift
//  pbdt
//
//  Created by Andrew M Levy on 5/6/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation

extension String {
    
    func dotsCheck() -> Bool {
        return !((self.filter() { $0 == "." }).count <= 1)
    }
}
