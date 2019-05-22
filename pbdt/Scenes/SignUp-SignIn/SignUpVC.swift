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
import NVActivityIndicatorView

class SignUpVC: UIViewController {
    
    // MARK: - objects and vars
    
    // ui objects
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var passwordConfirmationTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
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
        
        nameTxt.becomeFirstResponder()
    }
    
    func setupButtons() {
        
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.backgroundColor = UIColor.actionButtonBackground()
        signUpBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        signUpBtn.titleLabel?.font = UIFont.actionButtonText()
        signUpBtn.layer.shadowColor = UIColor.brandGreyDark().cgColor
        signUpBtn.layer.shadowOffset = ButtonConstants.shadowOffset
        signUpBtn.layer.shadowOpacity = ButtonConstants.shadowOpacity
        let heightSignUpBtn = signUpBtn.frame.height
        signUpBtn.layer.cornerRadius = heightSignUpBtn / 2
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
        
        nameTxt.inputAccessoryView = toolbar
        emailTxt.inputAccessoryView = toolbar
        passwordTxt.inputAccessoryView = toolbar
        passwordConfirmationTxt.inputAccessoryView = toolbar
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
        
        self.startSpinner()
        
        /*
        do {
            let fetch: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
            //let fetch: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let fetchCheck = try context.fetch(fetch)
            print("fetchCheck.count = \(fetchCheck.count)")
        } catch {
            print("error")
        }
        */
        
        let name = nameTxt.text
        let email = emailTxt.text
        let password = passwordTxt.text
        let passwordConfirmation = passwordConfirmationTxt.text
        
        let url = "\(baseUrl)/v1/users"
        
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
                    
                    print("JSON: \(JSON)")
                    
                    if let user = User.findOrCreateFromJSON(JSON, context: context) {
                        appDelegate.currentUser = user
                        print("user: \(user)")
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
