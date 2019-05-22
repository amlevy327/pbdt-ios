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

class AddIngredientVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate {

    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    var searchBarText = ""
    
    var previousVc: String!
    
    var recipe: Recipe!
    var items: [Item]!
    var itemsFiltered: [Item]!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
        setupNavigationBar()
        setupSearch()
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
    
    func setupSearch() {
        
        searchBar = UISearchBar()
        
        var textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.brandBlack()
        textFieldInsideSearchBar?.font = UIFont.small()
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.placeholder = "Search by name"
        searchBar.sizeToFit()
        
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = searchBarContainer
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
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 76, right: 0)
        tableView.contentInset = insets
        
        tableView.tableFooterView = UIView()
    }
    
    func setupNotfications() {
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterIngredientModification), name: NSNotification.Name("IngredientModification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterIngredientUpdateToExistingRecipe), name: NSNotification.Name("IngredientUpdateToExistingRecipe"), object: nil)
    }
    
    // updates
    
    @objc func updateAfterIngredientUpdateToExistingRecipe() {
        
        print("updateAfterIngredientUpdateToExistingRecipe, AddIngredientVC")
        navigationController?.popViewController(animated: true)
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddDiaryEntryCell", for: indexPath) as! AddDiaryEntryCell
        
        let item = itemsFiltered[indexPath.row]
        cell.nameLbl.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = itemsFiltered[indexPath.row]
        presentItemUpdateDiaryEntryVC(item: item, recipeId: "\(recipe!.objectId)")
    }
    
    // search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("searchText: \(searchText)")
        
        self.searchBarText = searchText
        
        guard !searchText.isEmpty else {
            print("blank")
            
            itemsFiltered = items
            tableView.reloadData()
            
            return
        }
        
        itemsFiltered = items.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
        print("itemsFiltered.count: \(itemsFiltered.count)")
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        self.searchBar.endEditing(true)
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
            self.items.sort(by: { $0.name!.compare($1.name! as String) == ComparisonResult.orderedAscending })
            self.itemsFiltered = self.items
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
