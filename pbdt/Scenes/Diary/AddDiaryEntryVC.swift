//
//  AddDiaryEntryVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/8/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData

class AddDiaryEntryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Item]!
    
    // MARK: - functions
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
        setupTableView()
        setupNotfications()
    }
    
    // setups
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "AddDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddDiaryEntryCell")
        
        tableView.tableFooterView = UIView()
    }
    
    func setupNotfications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFoodModification), name: NSNotification.Name("FoodModification"), object: nil)
    }
    
    // updates
    
    @objc func updateAfterFoodModification() {
        //print("updateAfterFoodModification: start")
        goToNavigationRoot()
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddDiaryEntryCell", for: indexPath) as! AddDiaryEntryCell
        
        let item = items[indexPath.row]
        cell.nameLbl.text = item.name?.capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        presentUpdateDiaryEntryVC(item)
    }
    
    // core data
    
    func fetchItems() {
        
        //print("fetchItems: start")
        
        let fetch: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
        do {
            print("fetchItems: request success")
            let fetchRequest = try context.fetch(fetch)
            self.items = fetchRequest
            tableView.reloadData()
        } catch {
            print("Error fetching items: \(error)")
        }
    }
    
    // MARK: - actions
    
    func presentUpdateDiaryEntryVC(_ item: Item) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDiaryEntryVC") as! UpdateDiaryEntryVC
        vc.item = item
        vc.previousVC = "AddDiaryEntryVC"
        self.present(vc, animated: true)
    }
    
    // MARK: - navigation
    
    func goToNavigationRoot() {
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
