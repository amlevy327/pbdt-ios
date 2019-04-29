//
//  FontHelpers.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/21/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func large() -> UIFont {
        return systemFont(ofSize: 16)
    }
    
    class func small() -> UIFont {
        return systemFont(ofSize: 14)
    }
    
    // brand view
    
    class func brandViewLarge() -> UIFont {
        return systemFont(ofSize: 24, weight: .medium)
    }
    
    class func brandViewSmall() -> UIFont {
        return systemFont(ofSize: 18)
    }
    
    // date view
    
    class func dateText() -> UIFont {
        //return UIFont.large()
        return UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    // navigation title
    
    class func navigationTitle() -> UIFont {
        return systemFont(ofSize: 18, weight: .medium)
    }
    
    // buttons
    
    class func actionButtonText() -> UIFont {
        //return UIFont.large()
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    class func dateButtonText() -> UIFont {
        return UIFont.large()
    }
    
    // segmented control view
    
    class func segmentedControlDefault() -> UIFont {
        return UIFont.large()
    }
    
    class func segmentedControlSelected() -> UIFont {
        return UIFont.large()
    }
    
    // table view cell
    
    class func cellLarge() -> UIFont {
        return systemFont(ofSize: 16)
    }
    class func cellSmall() -> UIFont {
        return systemFont(ofSize: 14)
    }
    
    // home collection view cell
    
    class func homeCellName() -> UIFont {
        return UIFont.large()
    }
    
    class func homeCellAmount() -> UIFont {
        return UIFont.large()
    }
    
    class func homeCellGoal() -> UIFont {
        return UIFont.small()
    }
    
    // empty data set
    
    class func emptyDataSetTitle() -> UIFont {
        return UIFont.boldSystemFont(ofSize: 18)
    }
    class func emptyDataSetDescription() -> UIFont {
        return systemFont(ofSize: 16)
    }
    
    /*
    class func homeCellServingsName() -> UIFont {
        return systemFont(ofSize: 20)
    }
    
    class func homeCellServingsAmount() -> UIFont {
        return systemFont(ofSize: 20)
    }
    
    class func homeCellServingsGoal() -> UIFont {
        return systemFont(ofSize: 12)
    }
    
    class func homeCellMacrosName() -> UIFont {
        return systemFont(ofSize: 28)
    }
    
    class func homeCellMacrosAmount() -> UIFont {
        return systemFont(ofSize: 28)
    }
    
    class func homeCellMacrosGoal() -> UIFont {
        return systemFont(ofSize: 18)
    }
    */
    
}
