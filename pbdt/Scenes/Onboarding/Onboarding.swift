//
//  Onboarding.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/7/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import NVActivityIndicatorView

class Onboarding {
    
    func goToTabBarController() {
        //self.performSegue(withIdentifier: "goToTabBarController", sender: self)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let rvc = sb.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let subs = appDelegate.window?.rootViewController?.view.subviews {
            for view in subs {
                view.removeFromSuperview()
            }
        }
        appDelegate.loadFoods()
        appDelegate.window?.rootViewController = rvc
    }
    
    func loadItems(spinner: NVActivityIndicatorView) {
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "\(baseUrl)/v1/items"
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        print("url: \(url)")
        print("headers: \(headers)")
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            print(response)
            
            switch response.result {
            case .success:
                //print("response success")
                //print("response.result.value: \(response.result.value)")
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    //print("JSON: \(JSON)")
                    for itemJSON in JSON {
                        Item.findOrCreateFromJSON(itemJSON, context: context)
                    }
                } else {
                    print("could not create item json")
                }
                //print("currentUser: \(appDelegate.currentUser)")
                self.goToTabBarController()
            case .failure(let error):
                print("response failure from get items: \(error)")
            }
            
            spinner.removeFromSuperview()
        }
    }
    
}
