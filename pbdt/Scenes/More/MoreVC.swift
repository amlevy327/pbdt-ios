//
//  MoreVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 3/31/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class MoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - objects and vars
    
    // objects
    @IBOutlet weak var tableView: UITableView!
    
    // vars
    let names = ["Sign Out"]
    
    // MARK: - functions
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // tableview
    
    func setupTableView() {
        
        let nib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MoreCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell
        cell.nameLbl.text = names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt: \(indexPath.row)")
        switch indexPath.row {
        case 0:
            print("0")
            showSignOutAlertController()
        default:
            print("switch default")
        }
    }
    
    // alert controller
    func showSignOutAlertController() {
        
        let alertController = UIAlertController(title: "Are you sure you want to sign out?", message: "", preferredStyle: .alert)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (response) in
            print("sign out clicked")
            self.clearUserDefaults()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (response) in
            print("cancel")
        }
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func goToSignInVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        appDelegate.window?.rootViewController = signUpVC
    }
    
    func clearUserDefaults() {
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        goToSignInVC()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
