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
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
    }
    
    // setups
    
    func setupButtons() {
        
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.backgroundColor = UIColor.actionButtonBackground()
        signUpBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        signUpBtn.titleLabel?.font = UIFont.actionButtonText()
        signUpBtn.layer.borderWidth = CGFloat(2)
        signUpBtn.layer.borderColor = UIColor.actionButtonBorder().cgColor
        
        signInBtn.setTitle("Sign In", for: .normal)
        signInBtn.backgroundColor = UIColor.actionButtonText()
        signInBtn.setTitleColor(UIColor.actionButtonBackground(), for: .normal)
        signInBtn.titleLabel?.font = UIFont.actionButtonText()
        signInBtn.layer.borderWidth = CGFloat(2)
        signInBtn.layer.borderColor = UIColor.actionButtonBackground().cgColor
    }
    
    // table view
    
    // MARK: - actions
    
    // MARK: - navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
