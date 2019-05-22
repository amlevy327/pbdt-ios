//
//  SignInVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/4/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import NVActivityIndicatorView

class SignInVC: UIViewController {

    // MARK: - objects and vars
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    let onboarding = Onboarding()
    var toolbar: UIToolbar!
    var spinner: NVActivityIndicatorView!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupViews()
        setupTextFields()
        setupButtons()
        setupToolbar()
        setupSpinner()
    }
    
    // setups
    
    func setupNavigation() {
        
        navigationItem.title = "pbdt"
    }
    
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
        
        emailTxt.becomeFirstResponder()
    }
    
    func setupButtons() {
        
        signInBtn.setTitle("Sign In", for: .normal)
        signInBtn.backgroundColor = UIColor.actionButtonBackground()
        signInBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        signInBtn.titleLabel?.font = UIFont.actionButtonText()
        //signInBtn.layer.borderWidth = CGFloat(2)
        //signInBtn.layer.borderColor = UIColor.actionButtonBorder().cgColor
        signInBtn.layer.shadowColor = UIColor.brandGreyDark().cgColor
        signInBtn.layer.shadowOffset = ButtonConstants.shadowOffset
        signInBtn.layer.shadowOpacity = ButtonConstants.shadowOpacity
        let heightSignInBtn = signInBtn.frame.height
        signInBtn.layer.cornerRadius = heightSignInBtn / 2
    }
    
    func setupToolbar() {
        
        toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.isUserInteractionEnabled = true
        toolbar.tintColor = UIColor.toolbarText()
        toolbar.barTintColor = UIColor.toolbarBackground()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        
        emailTxt.inputAccessoryView = toolbar
        passwordTxt.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked() {
        // end editing
        view.endEditing(true)
    }
    
    func setupSpinner() {
        spinner = NVActivityIndicatorView(frame: ActivityIndicatorConstants.frame, type: ActivityIndicatorConstants.type, color: ActivityIndicatorConstants.color, padding: nil)
        spinner.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
    }
    
    // MARK: - actions
    
    func startSpinner() {
        
        self.view.addSubview(spinner)
        spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopSpinner() {
        self.view.isUserInteractionEnabled = true
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    @IBAction func signInBtn_clicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            
            return
        }
        
        self.startSpinner()
        
        let email = emailTxt.text
        let password = passwordTxt.text
        
        let url = "\(baseUrl)/v1/sessions"
        
        print("url: \(url)")
        
        let params = ["email": email,
                      "password": password
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String: AnyObject] {
                    
                    //print("JSON: \(JSON)")
                    
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
                    
                    self.onboarding.loadItems(spinner: self.spinner)
                }
            case .failure(let error):
                print("response failure from post session: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
            
            self.stopSpinner()
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
