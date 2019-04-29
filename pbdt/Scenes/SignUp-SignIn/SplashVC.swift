//
//  SplashVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/28/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData

class SplashVC: UIViewController {

    // MARK: - objects and vars
    
    let onboarding = Onboarding()
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForUser()
    }
    
    // setups
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.brandPrimary()
    }
    
    // MARK: - actions
    
    func checkForUser() {
        
        do {
            
            let fetch: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
            let fetchCheck = try context.fetch(fetch)
            print("fetchCheck.count = \(fetchCheck.count)")
            
            if fetchCheck.count > 0 {
                
                appDelegate.currentUser = fetchCheck.first
                self.onboarding.loadItems()
            } else {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let rvc = sb.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let subs = appDelegate.window?.rootViewController?.view.subviews {
                    for view in subs {
                        view.removeFromSuperview()
                    }
                }
                appDelegate.window?.rootViewController = rvc
            }
            
        } catch {
            print("error")
        }
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
