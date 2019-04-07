//
//  OnboardingVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/3/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {

    // MARK: - objects and vars
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // setups
    
    func setupViews() {
        view.backgroundColor = .red
    }
    
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
