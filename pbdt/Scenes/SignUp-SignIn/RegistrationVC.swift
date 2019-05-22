//
//  RegistrationVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/28/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {

    // MARK: - objects and vars
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var disclaimerLbl: UILabel!
    @IBOutlet weak var termsOfServiceLbl: UILabel!
    @IBOutlet weak var andLbl: UILabel!
    @IBOutlet weak var privacyPolicyLbl: UILabel!
    
    
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupButtons()
        setupLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // setups
    
    func setupNavigation() {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
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
        
        signInBtn.setTitle("Sign In", for: .normal)
        signInBtn.backgroundColor = UIColor.actionButtonText()
        signInBtn.setTitleColor(UIColor.actionButtonBackground(), for: .normal)
        signInBtn.titleLabel?.font = UIFont.actionButtonText()
        signInBtn.layer.borderWidth = CGFloat(2)
        signInBtn.layer.borderColor = UIColor.actionButtonBackground().cgColor
        signInBtn.layer.shadowColor = UIColor.brandGreyDark().cgColor
        signInBtn.layer.shadowOffset = ButtonConstants.shadowOffset
        signInBtn.layer.shadowOpacity = ButtonConstants.shadowOpacity
        let heightSignInBtn = signInBtn.frame.height
        signInBtn.layer.cornerRadius = heightSignInBtn / 2
    }
    
    func setupLabels() {
        
        messageLbl.textColor = UIColor.brandBlack()
        messageLbl.font = UIFont.brandViewSmall()
        messageLbl.text = "Track by food group\n+\nProve you're hitting\ncalorie and macro goals"
        
        disclaimerLbl.font = UIFont.disclaimer()
        disclaimerLbl.textColor = UIColor.brandGreyDark()
        disclaimerLbl.text = "By signing up, I agree to pbdt's"
        
        termsOfServiceLbl.font = UIFont.disclaimer()
        termsOfServiceLbl.textColor = UIColor.brandPrimary()
        termsOfServiceLbl.text = "Terms of Service"
        termsOfServiceLbl.isUserInteractionEnabled = true
        termsOfServiceLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsOfService_clicked)))
        
        andLbl.font = UIFont.disclaimer()
        andLbl.textColor = UIColor.brandGreyDark()
        andLbl.text = "and"
        
        privacyPolicyLbl.font = UIFont.disclaimer()
        privacyPolicyLbl.textColor = UIColor.brandPrimary()
        privacyPolicyLbl.text = "Privacy Policy"
        privacyPolicyLbl.isUserInteractionEnabled = true
        privacyPolicyLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyPolicy_clicked)))
    }
    
    // table view
    
    // MARK: - actions
    
    @objc func termsOfService_clicked() {
        print("termsOfService_clicked")
    }
    
    @objc func privacyPolicy_clicked() {
        print("privacyPolicy_clicked")
    }
    
    // MARK: - navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
