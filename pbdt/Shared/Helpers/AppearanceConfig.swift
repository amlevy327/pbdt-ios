//
//  AppearanceConfig.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/21/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation
import UIKit

class AppearanceConfig {
    
    class func setupNavigationBar() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.brandPrimary()
        UINavigationBar.appearance().tintColor = UIColor.brandWhite()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.brandWhite(),
                                                            NSAttributedString.Key.font: UIFont.navigationTitle()]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.brandWhite(),
                                                             NSAttributedString.Key.font: UIFont.navigationTitle()], for: .normal)
        
    }
    
    class func setupStatusBar() {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.brandPrimary()
    }
    
    class func setupTabBar() {
        UITabBar.appearance().tintColor = UIColor.brandPrimary()
    }
}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}

