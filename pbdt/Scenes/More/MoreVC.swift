//
//  MoreVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 3/31/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData

class MoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - objects and vars
    
    // objects
    @IBOutlet weak var tableView: UITableView!
    
    // vars
    let names = ["Recipes", "Goals", "Sign Out"]
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
    }
    
    // setups
    
    func setupNavigationBar() {
        
        navigationItem.title = "More"
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func setupTableView() {
        
        let nib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MoreCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    // tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
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
            goToRecipesVC()
        case 1:
            print("1")
            goToGoalsVC()
        case 2:
            print("2")
            showSignOutAlertController()
        default:
            print("switch default")
        }
    }
    
    // clear
    
    func clearCoreData() {
        
        clearUser()
        clearItem()
        clearFood()
        clearRecipe()
        clearIngredient()
        
        goToRegistrationVC()
    }
    
    func clearUser() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            appDelegate.saveContext()
        } catch {
            print ("Error deleting User")
        }
    }
    
    func clearItem() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            appDelegate.saveContext()
        } catch {
            print ("Error deleting Item")
        }
    }
    
    func clearFood() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            appDelegate.saveContext()
        } catch {
            print ("Error deleting Food")
        }
    }
    
    func clearRecipe() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            appDelegate.saveContext()
        } catch {
            print ("Error deleting Recipe")
        }
    }
    
    func clearIngredient() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Ingredient")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            appDelegate.saveContext()
        } catch {
            print ("Error deleting Ingredient")
        }
    }
    
    // alert controller
    func showSignOutAlertController() {
        
        let alertController = UIAlertController(title: "Are you sure you want to sign out?", message: "", preferredStyle: .alert)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (response) in
            print("sign out clicked")
            //self.clearUserDefaults()
            self.clearCoreData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (response) in
            print("cancel")
        }
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    // MARK: - navigation
    
    func goToRecipesVC() {
        self.performSegue(withIdentifier: "goToRecipesVC", sender: self)
    }
    
    func goToGoalsVC() {
        self.performSegue(withIdentifier: "goToGoalsVC", sender: self)
    }
    
    func goToRegistrationVC() {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let signUpVC = storyboard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
//        appDelegate.window?.rootViewController = signUpVC
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let rvc = sb.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC

        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let subs = appDelegate.window?.rootViewController?.view.subviews {
            for view in subs {
                view.removeFromSuperview()
            }
        }
        appDelegate.window?.rootViewController = rvc
    }
    
    @objc func goToNavigationRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
