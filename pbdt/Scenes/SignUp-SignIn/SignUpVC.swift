//
//  SignUpVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 3/30/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class SignUpVC: UIViewController {
    
    // MARK: - objects and vars
    
    // ui objects
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var passwordConfirmationTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    let onboarding = Onboarding()
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTextFields()
        setupButtons()
    }
    
    // setups
    
    func setupViews() {
        
        view.backgroundColor = UIColor.mainViewBackground()
    }
    
    func setupTextFields() {
        
        nameTxt.font = UIFont.large()
        nameTxt.textColor = UIColor.brandBlack()
        nameTxt.placeholder = "name"
        
        emailTxt.font = UIFont.large()
        emailTxt.textColor = UIColor.brandBlack()
        emailTxt.placeholder = "email"
        
        passwordTxt.font = UIFont.large()
        passwordTxt.textColor = UIColor.brandBlack()
        passwordTxt.placeholder = "password"
        
        passwordConfirmationTxt.font = UIFont.large()
        passwordConfirmationTxt.textColor = UIColor.brandBlack()
        passwordConfirmationTxt.placeholder = "confirm password"
    }
    
    func setupButtons() {
        
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.backgroundColor = UIColor.actionButtonBackground()
        signUpBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        signUpBtn.titleLabel?.font = UIFont.actionButtonText()
        signUpBtn.layer.borderWidth = CGFloat(2)
        signUpBtn.layer.borderColor = UIColor.actionButtonBorder().cgColor
    }
    
    // MARK: - actions
    
    @IBAction func signUpBtn_clicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if nameTxt.text!.isEmpty || emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty || passwordConfirmationTxt.text!.isEmpty {
            
            nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            passwordConfirmationTxt.attributedPlaceholder = NSAttributedString(string: "confirm password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            
            return
        }
        
        if (passwordTxt.text?.characters.count)! < 6 {
            
            appDelegate.showInfoView(message: UIMessages.kErrorPasswordLength, color: UIColor.popUpFailure())
            return
        }
        
        if passwordTxt.text != passwordConfirmationTxt.text {
            
            appDelegate.showInfoView(message: UIMessages.kErrorPasswordNoMatch, color: UIColor.popUpFailure())
            return
        }
        
        do {
            let fetch: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
            //let fetch: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let fetchCheck = try context.fetch(fetch)
            print("fetchCheck.count = \(fetchCheck.count)")
        } catch {
            print("error")
        }
        
        /*
        let name = nameTxt.text
        let email = emailTxt.text
        let password = passwordTxt.text
        let passwordConfirmation = passwordConfirmationTxt.text
        
        let url = "http://localhost:3000/v1/users"
        let params = ["user":
            ["name": name,
             "email": email,
             "password": password,
             "password_confirmation": passwordConfirmation
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String: AnyObject] {
                    
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
                    
                    self.onboarding.loadItems()
                }
            case .failure(let error):
                print("response failure from post user: \(error)")
            }
        }
        */
    }
    
    // MARK: - navigation
    
    func goToTabBarController() {
        self.performSegue(withIdentifier: "goToTabBarController", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
