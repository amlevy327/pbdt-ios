//
//  SplashVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/28/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import NVActivityIndicatorView

class SplashVC: UIViewController {

    // MARK: - objects and vars
    let onboarding = Onboarding()
    var spinner: NVActivityIndicatorView!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupSpinner()
        checkForUser()
    }
    
    // setups
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.brandPrimary()
    }
    
    func setupSpinner() {
        
        spinner = NVActivityIndicatorView(frame: ActivityIndicatorConstants.frame, type: ActivityIndicatorConstants.type, color: UIColor.brandWhite(), padding: nil)
        spinner.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        
        startSpinner()
    }
    
    // MARK: - actions
    
    func startSpinner() {
        
        print("startSpinner")
        
        self.view.addSubview(spinner)
        spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopSpinner() {
        self.view.isUserInteractionEnabled = true
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    func checkForUser() {
        
        do {
            
            let fetch: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
            let fetchCheck = try context.fetch(fetch)
            print("fetchCheck.count = \(fetchCheck.count)")
            
            if fetchCheck.count > 0 {
                
                appDelegate.currentUser = fetchCheck.first
                self.onboarding.loadItems(spinner: self.spinner)
                
            } else {
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let rvc = sb.instantiateViewController(withIdentifier: "RegistrationNC") as! RegistrationNC
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let subs = appDelegate.window?.rootViewController?.view.subviews {
                    for view in subs {
                        view.removeFromSuperview()
                    }
                }
                appDelegate.window?.rootViewController = rvc
            }
            
            //self.stopSpinner()
            
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
