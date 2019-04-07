//
//  HomeVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/2/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {

    // MARK: - objects and vars
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // setups
    
    func setupViews() {
        view.backgroundColor = .green
    }
    
    // MARK: - actions
    
    @IBAction func check2Btn_clicked(_ sender: Any) {
        
        print("clicked - check")
        
        do {
            let fetch: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
            let fetchCheck = try context.fetch(fetch)
            print("fetchCheck.count = \(fetchCheck.count)")
        } catch {
            print("error")
        }
    }
    
    @IBAction func checkBtn_clicked(_ sender: Any) {
        
        print("clicked - delete")
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print ("Error deleting")
        }

    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
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
