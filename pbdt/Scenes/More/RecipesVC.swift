//
//  RecipesVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/28/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import DZNEmptyDataSet

class RecipesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newBtn: UIButton!
    
    var recipes: [Recipe]!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecipes()
        setupNavigationBar()
        setupViews()
        setupTableView()
        setupButtons()
        setupNotfications()
    }
    
    // setups
    
    func setupNavigationBar() {
        
        navigationItem.title = "Recipes"
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
//        let backArrow = UIImage.backArrow()
//        let backBtn = UIBarButtonItem(image: UIImage.backArrow(), style: .plain, target: self, action: #selector(goToNavigationRoot))
//        
//        navigationController?.navigationBar.backIndicatorImage = backArrow
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrow
//        navigationItem.leftBarButtonItem = backBtn
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.mainViewBackground()
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        let nib = UINib(nibName: "AddDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddDiaryEntryCell")
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 76, right: 0)
        tableView.contentInset = insets
        tableView.tableFooterView = UIView()
    }
    
    func setupButtons() {
        
        newBtn.setTitle("Create a Recipe", for: .normal)
        newBtn.backgroundColor = UIColor.actionButtonBackground()
        newBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        newBtn.titleLabel?.font = UIFont.actionButtonText()
        newBtn.layer.shadowColor = UIColor.brandGreyDark().cgColor
        newBtn.layer.shadowOffset = ButtonConstants.shadowOffset
        newBtn.layer.shadowOpacity = ButtonConstants.shadowOpacity
        let height = newBtn.frame.height
        newBtn.layer.cornerRadius = height / 2
    }
    
    func setupNotfications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterRecipeChange), name: NSNotification.Name("RecipeChanged"), object: nil)
    }
    
    // updates
    
    @objc func updateAfterRecipeChange() {
        
        print("updateAfterRecipeChange")
        
        fetchRecipes()
    }
    
    // notifications
    
    func postNotificationRecipeChange() {
        print("postNotificationRecipeChange")
        NotificationCenter.default.post(name: NSNotification.Name("RecipeChanged"), object: nil)
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddDiaryEntryCell", for: indexPath) as! AddDiaryEntryCell
        
        let recipe = recipes[indexPath.row]
        cell.nameLbl.text = recipe.name
        
        //cell.isUserInteractionEnabled = false
        
        //print("recipe \(recipe.name?: ingredients.count = \(recipe.ingredient?.count)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recipe = recipes[indexPath.row]
        goToConfirmRecipeVC(recipe: recipe)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action:UITableViewRowAction, indexPath:IndexPath) in
            
            let alert = UIAlertController(title: "Are you sure you want to delete this recipe", message: "", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                print("delete tapped")
                
                if let recipe = self.recipes[indexPath.row] as? Recipe {
                    self.deleteRecipe(recipe: recipe)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        return [deleteAction]
    }
    
    // empty data set
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return recipes.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "No recipes"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetTitle(),
                          NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "Recipes you create will appear here"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetDescription(),
                          NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // core data
    
    func fetchRecipes() {
        
        //print("fetchRecipes: start")
        
        let fetch: NSFetchRequest<Recipe> = NSFetchRequest(entityName: "Recipe")
        
        let sectionSortDescriptions = NSSortDescriptor(key: "updatedAt", ascending: false)
        let sortDescripters = [sectionSortDescriptions]
        fetch.sortDescriptors = sortDescripters
        
        do {
            print("fetchRecipes: request success")
            let fetchRequest = try context.fetch(fetch)
            print("fetchRequest.count: \(fetchRequest.count)")
            self.recipes = fetchRequest
            self.recipes.sort(by: { $0.updatedAt!.compare($1.updatedAt! as Date) == ComparisonResult.orderedDescending })
            
            print("recipes.count: \(recipes.count)")
            
            tableView.reloadData()
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
    
    // MARK: - actions
    
    @IBAction func newBtn_clicked(_ sender: Any) {
        
        goToCreateRecipeVC()
    }
    
    func deleteRecipe(recipe: Recipe) {
        
        print("deleteRecipe")
        
        let id = (recipe.objectId!)
        print("id: \(id)")
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "\(baseUrl)/v1/recipes/\(id)"
        
        let params = ["recipe": [
            "id": id
            ]
        ]
        
        print("params: \(params)")
        print("url: \(url)")
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            print(response)
            
            switch response.result {
            case .success:
                
                do {
                    try context.delete(recipe)
                    try context.save()
                    self.postNotificationRecipeChange()
                    self.fetchRecipes()
                } catch {
                    print("errors: \(error)")
                }
                
                appDelegate.showInfoView(message: UIMessages.kRecipeDeleted, color: UIColor.popUpSuccess())
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
        }
    }
    
    // MARK: - navigation
    
    @objc func goToNavigationRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToConfirmRecipeVC(recipe: Recipe) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ConfirmRecipeVC") as! ConfirmRecipeVC
        vc.previousVc = "RecipesVC"
        vc.recipe = recipe
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCreateRecipeVC() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CreateRecipeVC") as! CreateRecipeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
