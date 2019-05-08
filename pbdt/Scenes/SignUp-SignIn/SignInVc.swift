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
        setupTextFields()
        setupButtons()
    }
    
    // setups
    
    func setupViews() {
        
        view.backgroundColor = UIColor.mainViewBackground()
    }
    
    func setupTextFields() {
        
        emailTxt.font = UIFont.large()
        emailTxt.textColor = UIColor.brandBlack()
        emailTxt.placeholder = "email"
        
        passwordTxt.font = UIFont.large()
        passwordTxt.textColor = UIColor.brandBlack()
        passwordTxt.placeholder = "password"
    }
    
    func setupButtons() {
        
        signInBtn.setTitle("Sign In", for: .normal)
        signInBtn.backgroundColor = UIColor.actionButtonBackground()
        signInBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        signInBtn.titleLabel?.font = UIFont.actionButtonText()
        signInBtn.layer.borderWidth = CGFloat(2)
        signInBtn.layer.borderColor = UIColor.actionButtonBorder().cgColor
    }
    
    // MARK: - actions
    @IBAction func signInBtn_clicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            
            return
        }
        
        let email = emailTxt.text
        let password = passwordTxt.text
        
        let url = "http://localhost:3000/v1/sessions"
        let params = ["email": email,
                      "password": password
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String: AnyObject] {
                    
                    print("JSON: \(JSON)")
                    
                    if let user = User.findOrCreateFromJSON(JSON, context: context) {
                        appDelegate.currentUser = user
                        print("user: \(user)")
                    }
                    
                    let userFoods = JSON["foods"] as! [[String: AnyObject]]
                    for userFood in userFoods {
                        Food.findOrCreateFromJSON(userFood, context: context)
                    }
                    
                    let userRecipes = JSON["recipes"] as! [[String: AnyObject]]
                    for userRecipe in userRecipes {
                        Recipe.findOrCreateFromJSON(userRecipe, context: context)
                    }
                    
                    let userIngredients = JSON["ingredients"] as! [[String: AnyObject]]
                    for userIngredient in userIngredients {
                        Ingredient.findOrCreateFromJSON(userIngredient, context: context)
                    }
                    
                    self.onboarding.loadItems()
                }
            case .failure(let error):
                print("response failure from post session: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorEmailPassword, color: UIColor.popUpFailure())
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
