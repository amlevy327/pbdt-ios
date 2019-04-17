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

class Onboarding {
    
    func saveUserInfo(_ JSON: [String: Any]) {
        
        print("JSON: \(JSON)")
        
        let name = JSON["name"] as! String
        let email = JSON["email"] as! String
        let authorizationToken = JSON["authentication_token"] as! String
        let beans = JSON["beans_g"] as! String
        let berries = JSON["berries_g"] as! String
        let otherFruits = JSON["other_fruits_g"] as! String
        let cruciferousVegetables = JSON["cruciferous_vegetables_g"] as! String
        let greens = JSON["greens_g"] as! String
        let otherVegetables = JSON["other_vegetables_g"] as! String
        let flaxseeds = JSON["flaxseeds_g"] as! String
        let nuts = JSON["nuts_g"] as! String
        let turmeric = JSON["turmeric_g"] as! String
        let wholeGrains = JSON["whole_grains_g"] as! String
        let otherSeeds = JSON["other_seeds_g"] as! String
        let cals = JSON["cals_g"] as! String
        let fat = JSON["fat_g"] as! String
        let carbs = JSON["carbs_g"] as! String
        let protein = JSON["protein_g"] as! String
        
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(authorizationToken, forKey: "authenticationToken")
        UserDefaults.standard.set(beans, forKey: "beans")
        UserDefaults.standard.set(berries, forKey: "berries")
        UserDefaults.standard.set(otherFruits, forKey: "otherFruits")
        UserDefaults.standard.set(cruciferousVegetables, forKey: "cruciferousVegetables")
        UserDefaults.standard.set(greens, forKey: "greens")
        UserDefaults.standard.set(otherVegetables, forKey: "otherVegetables")
        UserDefaults.standard.set(flaxseeds, forKey: "flaxseeds")
        UserDefaults.standard.set(nuts, forKey: "nuts")
        UserDefaults.standard.set(turmeric, forKey: "turmeric")
        UserDefaults.standard.set(wholeGrains, forKey: "wholeGrains")
        UserDefaults.standard.set(otherSeeds, forKey: "otherSeeds")
        UserDefaults.standard.set(cals, forKey: "cals")
        UserDefaults.standard.set(fat, forKey: "fat")
        UserDefaults.standard.set(carbs, forKey: "carbs")
        UserDefaults.standard.set(protein, forKey: "protein")
        
        
        // test
        
        let userFoods = JSON["foods"] as! [[String: AnyObject]]
        //print("userFoods.count: \(userFoods.count)")
        
        for userFood in userFoods {
            Food.findOrCreateFromJSON(userFood, context: context)
        }
        
        //
        
        self.goToTabBarController()
    }
    
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
        appDelegate.window?.rootViewController = rvc
    }
    
    func loadItems() {
        
        let email = "\(UserDefaults.standard.string(forKey: "email")!)"
        let authenticationToken = "\(UserDefaults.standard.string(forKey: "authenticationToken")!)"
        
        let url = "http://localhost:3000/v1/items"
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        //print("url: \(url)")
        //print("headers: \(headers)")
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            //print(response)
            
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
                self.goToTabBarController()
            case .failure(let error):
                print("response failure from get items: \(error)")
            }
        }
    }
    
}
