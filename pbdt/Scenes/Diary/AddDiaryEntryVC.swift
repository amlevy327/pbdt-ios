//
//  AddDiaryEntryVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/8/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet
import IQKeyboardManagerSwift

class AddDiaryEntryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UISearchBarDelegate {

    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    
    var searchBar: UISearchBar!
    var searchBarText = ""
    
    var items: [Item]!
    var itemsFiltered: [Item]!
    var recipes: [Recipe]!
    var recipesFiltered: [Recipe]!
    
    // MARK: - functions
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
        fetchRecipes()
        setupNavigation()
        setupSearch()
        setupViews()
        setupTableView()
        setupNotfications()
    }
    
    // setups
    
    func setupNavigation() {
        
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
        
        segmentedControlView.parentVc = "AddDiaryEntryVC"
        segmentedControlView.addDiaryEntryVc = self
        segmentedControlView.setupSegmentedControl()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFoodModification), name: NSNotification.Name("FoodModification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterRecipeModification), name: NSNotification.Name("RecipeChanged"), object: nil)
    }
    
    // updates
    
    @objc func updateAfterFoodModification() {
        //print("updateAfterFoodModification: start")
        goToNavigationRoot()
    }
    
    @objc func updateAfterRecipeModification() {
        print("updateAfterRecipeModification: start")
        fetchRecipes()
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            return itemsFiltered.count
        case 1:
            return recipesFiltered.count
        default:
            print("d")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddDiaryEntryCell", for: indexPath) as! AddDiaryEntryCell
        
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            let item = itemsFiltered[indexPath.row]
            cell.nameLbl.text = item.name
        case 1:
            let recipe = recipesFiltered[indexPath.row]
            cell.nameLbl.text = recipe.name
        default:
            print("d")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            let item = itemsFiltered[indexPath.row]
            presentItemUpdateDiaryEntryVC(item)
        case 1:
            let recipe = recipesFiltered[indexPath.row]
            presentRecipeUpdateDiaryEntryVC(recipe)
        default:
            print("d")
        }
    }
    
    // search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("searchText: \(searchText)")
        
        self.searchBarText = searchText
        
        guard !searchText.isEmpty else {
            print("blank")
            
            switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
            case 0:
                itemsFiltered = items
            case 1:
                recipesFiltered = recipes
            default:
                print("d")
            }
            
            tableView.reloadData()
            return
        }
        
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            itemsFiltered = items.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
            print("itemsFiltered.count: \(itemsFiltered.count)")
        case 1:
            recipesFiltered = recipes.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
            print("recipesFiltered.count: \(recipesFiltered.count)")
        default:
            print("d")
        }
        
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
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            return itemsFiltered.count == 0
        case 1:
            return recipesFiltered.count == 0
        default:
            print("d")
            return false
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var string = ""
        var attributes: [NSAttributedString.Key : NSObject]!
        
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            string = "No items"
            attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetTitle(),
                              NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
            return NSAttributedString(string: string, attributes: attributes)
        case 1:
            string = "No recipes"
            attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetTitle(),
                              NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        default:
            print("d")
        }
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var string = ""
        var attributes: [NSAttributedString.Key : NSObject]!
        
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            string = ""
            attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetDescription(),
                              NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
            return NSAttributedString(string: string, attributes: attributes)
        case 1:
            string = ""
            attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetDescription(),
                              NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        default:
            print("d")
        }
        
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
            self.itemsFiltered = items
            tableView.reloadData()
        } catch {
            print("Error fetching items: \(error)")
        }
    }
    
    func fetchRecipes() {
        
        //print("fetchRecipes: start")
        
        let fetch: NSFetchRequest<Recipe> = NSFetchRequest(entityName: "Recipe")
        do {
            print("fetchRecipes: request success")
            let fetchRequest = try context.fetch(fetch)
            self.recipes = fetchRequest
            self.recipes.sort(by: { $0.updatedAt!.compare($1.updatedAt! as Date) == ComparisonResult.orderedDescending })
            self.recipesFiltered = recipes
            tableView.reloadData()
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
    
    // MARK: - actions
    
    func presentItemUpdateDiaryEntryVC(_ item: Item) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDiaryEntryVC") as! UpdateDiaryEntryVC
        vc.item = item
        vc.addType = "item"
        vc.previousVC = "AddDiaryEntryVC"
        self.present(vc, animated: true)
    }
    
    func presentRecipeUpdateDiaryEntryVC(_ recipe: Recipe) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDiaryEntryVC") as! UpdateDiaryEntryVC
        vc.recipe = recipe
        vc.addType = "recipe"
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
