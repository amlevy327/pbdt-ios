//
//  AddIngredientVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 5/3/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class AddIngredientVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    
    var previousVc: String!
    //var recipeType: String!
    
    var recipe: Recipe!
    var items: [Item]!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
        setupNavigationBar()
        setupViews()
        setupTableView()
        setupNotfications()
    }
    
    // setups
    
    func setupNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.mainViewBackground()
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        let nib = UINib(nibName: "AddDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddDiaryEntryCell")
        
        tableView.tableFooterView = UIView()
    }
    
    func setupNotfications() {
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterIngredientModification), name: NSNotification.Name("IngredientModification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterIngredientUpdateToExistingRecipe), name: NSNotification.Name("IngredientUpdateToExistingRecipe"), object: nil)
    }
    
    // updates
    
    /*
    @objc func updateAfterIngredientModification() {
        
        print("updateAfterIngredientModification, AddIngredientVC")
        navigationController?.popViewController(animated: true)
    }
    */
    
    @objc func updateAfterIngredientUpdateToExistingRecipe() {
        
        print("updateAfterIngredientUpdateToExistingRecipe, AddIngredientVC")
        navigationController?.popViewController(animated: true)
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
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
        presentItemUpdateDiaryEntryVC(item: item, recipeId: "\(recipe!.objectId)")
    }
    
    // empty data set
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return items.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let string = "No items"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetTitle(),
                      NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let string = ""
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetDescription(),
                      NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
        
        return NSAttributedString(string: string, attributes: attributes)
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
    
    func presentItemUpdateDiaryEntryVC(item: Item, recipeId: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDiaryEntryVC") as! UpdateDiaryEntryVC
        vc.item = item
        vc.recipeId = "\(recipe.objectId!)"
        vc.addType = "item"
        vc.previousVC = "AddIngredientVC"
        //vc.recipeType = self.recipeType
        self.present(vc, animated: true)
    }
    
    // MARK: - navigation
    
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        print("popBack - VC")
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
