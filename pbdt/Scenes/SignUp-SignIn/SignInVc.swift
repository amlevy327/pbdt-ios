//
//  SignInVc.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/4/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class SignInVc: UIViewController {

    // MARK: - objects and vars
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    let onboarding = Onboarding()
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // setups
    
    func setupViews() {
        view.backgroundColor = .cyan
    }
    
    // MARK: - actions
    @IBAction func signInBtn_clicked(_ sender: Any) {
        
        let email = emailTxt.text
        let password = passwordTxt.text
        
        let url = "http://localhost:3000/v1/sessions"
        let params = ["email": email,
                      "password": password
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            //print(response)
            
            switch response.result {
            case .success:
                //print("response.result.value: \(response.result.value)")
                if let JSON = response.result.value as? [String: AnyObject] {
                    
                    //Onboarding().saveUserInfo(JSON)
                    
                    //print("JSON: \(JSON)")
                    
                    let name = JSON["name"] as! String
                    let email = JSON["email"] as! String
                    let authenticationToken = JSON["authentication_token"] as! String
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
                    UserDefaults.standard.set(authenticationToken, forKey: "authenticationToken")
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
                    
                    let userFoods = JSON["foods"] as! [[String: AnyObject]]
                    for userFood in userFoods {
                        Food.findOrCreateFromJSON(userFood, context: context)
                    }
                    
                    self.onboarding.loadItems()
                }
            case .failure(let error):
                print("response failure from post session: \(error)")
            }
        }
    }
    
    
    // MARK: - navigation
    
    func goToTabBarController() {
        self.performSegue(withIdentifier: "goToTabBarController", sender: self)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
