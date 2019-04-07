//
//  DiaryVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/2/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData

class DiaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    
    var diaryEntries = [Food]()
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
    }
    
    // other
    
    func loadFoods() {
        
        let foodFetch: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
        do {
            let fetchRequest = try context.fetch(foodFetch)
            diaryEntries = fetchRequest
            tableView.reloadData()
        } catch {
            print("Error fetching foods: \(error)")
        }
    }
    
    // setups
    
    func setupViews() {
        view.backgroundColor = .cyan
    }
    
    func setupTableView() {
        
        let nib = UINib(nibName: "DiaryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DiaryCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        loadFoods()
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryEntries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        
        let entry = diaryEntries[indexPath.row]
        print("Entry: \(entry)")
        
        if let id = entry.objectId {
            cell.idLbl.text = "\(id)"
        }
        
        if let name = entry.name {
            cell.nameLbl.text = "\(name)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = diaryEntries[indexPath.row]
        presentUpdateDiaryEntryVC(entry)
    }
    
    
    // MARK: - actions
    
    func presentUpdateDiaryEntryVC(_ entry: Food) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDiaryEntryVC") as! UpdateDiaryEntryVC
        vc.entry = entry
        self.present(vc, animated: true)
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
