//
//  ColorHelpers.swift
//  pbdt
//
//  Created by Andrew M Levy on 3/31/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func brandPrimary() -> UIColor {
        //return UIColor(red: 2/255, green: 45/255, blue: 160/255, alpha: 1) // brand, dark blue
        return UIColor(red: 63/255, green: 133/255, blue: 214/255, alpha: 1) // brand, google blue
    }
    
    class func brandSecondary() -> UIColor {
        return UIColor(red: 8/255, green: 138/255, blue: 184/255, alpha: 1) // brand, light blue
    }
    
    class func brandGreyDark() -> UIColor {
        return UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1.0) // #7F7F7F
    }
    
    class func brandGreyLight() -> UIColor {
        return UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0) // #EBEBEB
    }
    
    class func brandWhite() -> UIColor {
        return UIColor.white
    }
    
    class func brandBlack() -> UIColor {
        //return UIColor.black
        return UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
    }
    
    // views
    
    class func mainViewBackground() -> UIColor {
        return UIColor.brandWhite()
    }
    
    class func viewBackground() -> UIColor {
        return UIColor.brandWhite()
    }
    
    class func viewDivider() -> UIColor {
        return UIColor.brandGreyDark()
    }
    
    // toolbar
    class func toolbarText() -> UIColor {
        return UIColor.brandWhite()
    }
    
    class func toolbarBackground() -> UIColor {
        return UIColor.brandGreyDark()
    }
    
    // spinner
    
    class func spinnerColor() -> UIColor {
        return UIColor.brandPrimary()
    }
    
    // buttons
    
    class func actionButtonBackground() -> UIColor {
        return UIColor.brandPrimary()
    }
    
    class func actionButtonText() -> UIColor {
        return UIColor.brandWhite()
    }
    
    class func actionButtonBorder() -> UIColor {
        return UIColor.brandWhite()
    }
    
    class func dateButtonBackground() -> UIColor {
        return UIColor.brandWhite()
    }
    
    class func dateButtonText() -> UIColor {
        return UIColor.brandPrimary()
    }
    
    class func dateButtonBorder() -> UIColor {
        return UIColor.brandPrimary()
    }
    
    // cells
    
    class func cellPrimaryText() -> UIColor {
        return UIColor.brandPrimary()
    }
    
    class func cellSecondaryText() -> UIColor {
        return UIColor.brandGreyDark()
    }
    
    // segmented control
    
    class func segmentedControlDefault() -> UIColor {
        return UIColor.brandGreyDark()
    }
    
    class func segmentedControlSelected() -> UIColor {
        return UIColor.brandBlack()
    }
    
    // summary
    
    class func success() -> UIColor {
        return UIColor(red: 2/255, green: 157/255, blue: 104/255, alpha: 0.5) // green
    }
    
    class func failure() -> UIColor {
        return UIColor(red: 186/255, green: 3/255, blue: 34/255, alpha: 0.5)  // red
    }
    
    // pop up
    
    class func popUpSuccess() -> UIColor {
        //return UIColor(red: 2/255, green: 157/255, blue: 104/255, alpha: 1) // green
        return UIColor.brandWhite()
    }
    
    class func popUpFailure() -> UIColor {
        //return UIColor(red: 186/255, green: 3/255, blue: 34/255, alpha: 1)  // red
        return UIColor.brandWhite()
    }
    
}
