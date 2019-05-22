//
//  FeedbackVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 5/15/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController {

    // MARK: - objects and vars
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
    
    // setups
    
    func setupNavigationBar() {
        
        navigationItem.title = "Send Feedback"
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.mainViewBackground()
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
