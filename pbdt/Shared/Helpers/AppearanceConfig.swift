//
//  AppearanceConfig.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/21/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

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
    
    class func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.brandWhite()
        IQKeyboardManager.shared.toolbarBarTintColor = UIColor.brandGreyDark()
    }
}

class SearchBarContainerView: UIView {
    
    let searchBar: UISearchBar
    
    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)
        
        addSubview(searchBar)
    }
    
    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}  

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}

