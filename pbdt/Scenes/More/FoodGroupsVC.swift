//
//  FoodGroupsVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 5/15/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class FoodGroupsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - objects and vars
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    
    var names: [String]!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNames()
        setupViews()
        setupLabels()
        setupTableView()
        setupNavigationBar()
    }
    
    // setups
    
    func setupViews() {
        
        view.backgroundColor = UIColor.mainViewBackground()
        headerView.backgroundColor = UIColor.mainViewBackground()
        dividerView.backgroundColor = UIColor.viewDivider()
    }
    
    func setupLabels() {
        
        headerLbl.font = UIFont.large()
        headerLbl.textColor = UIColor.brandPrimary()
        headerLbl.backgroundColor = UIColor.clear
        headerLbl.text = "Select a food group"
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "AddDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddDiaryEntryCell")
        
        tableView.tableFooterView = UIView()
    }
    
    func setupNames() {
        
        names = StaticLists.servingsNameArray
    }
    
    func setupNavigationBar() {
        
        navigationItem.title = "Food Groups"
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    // table view
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddDiaryEntryCell", for: indexPath) as! AddDiaryEntryCell
        
        let name = names[indexPath.row]
        cell.nameLbl.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let name = names[indexPath.row]
        goToFoodGroupDetailVC(foodGroupSelected: name.lowercased())
    }
    
    // MARK: - actions
    
    func goToFoodGroupDetailVC(foodGroupSelected: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FoodGroupDetailVC")  as! FoodGroupDetailVC
        vc.foodGroupSelected = foodGroupSelected
        vc.previousVC = "FoodGroupsVC"
        self.navigationController?.pushViewController(vc, animated: true)
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
