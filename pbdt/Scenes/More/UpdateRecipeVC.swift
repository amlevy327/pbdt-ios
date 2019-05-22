//
//  UpdateRecipeVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/30/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import Alamofire
import DZNEmptyDataSet
import NVActivityIndicatorView

class UpdateRecipeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    var spinner: NVActivityIndicatorView!
    
    var previousVc: String!
    var recipe: Recipe!
    var ingredients: [Ingredient]!
    //var recipeType: String!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialValues()
        setupNavigationBar()
        setupViews()
        setupTableView()
        setupButtons()
        setupNotifications()
        setupSpinner()
    }
    
    // setups
    
    func setupInitialValues() {
        
        ingredients = recipe.ingredient?.allObjects as? [Ingredient]
        // need to sort by updated by
    }
    
    func setupNavigationBar() {
        
        switch previousVc {
        case "ConfirmRecipeVC":
            print("previousVc = ConfirmRecipeVC")
            navigationItem.hidesBackButton = false
        case "CreateRecipeVC":
            print("previousVc = CreateRecipeVC")
            navigationItem.hidesBackButton = true
            
            let deleteBtn = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteBtn_clicked))
            navigationItem.leftBarButtonItem = deleteBtn
        default:
            print("previousVc = d")
            navigationItem.hidesBackButton = true
        }
        
        navigationItem.title = "Recipe Ingredients"
       
        let nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextBtn_clicked))
        navigationItem.rightBarButtonItem = nextBtn
        
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
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        let nib = UINib(nibName: "AddDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddDiaryEntryCell")
        
        tableView.tableFooterView = UIView()
    }
    
    func setupButtons() {
        
        addBtn.setTitle("Add Ingredient", for: .normal)
        addBtn.backgroundColor = UIColor.actionButtonBackground()
        addBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        addBtn.titleLabel?.font = UIFont.actionButtonText()
        addBtn.layer.shadowColor = UIColor.brandGreyDark().cgColor
        addBtn.layer.shadowOffset = ButtonConstants.shadowOffset
        addBtn.layer.shadowOpacity = ButtonConstants.shadowOpacity
        let height = addBtn.frame.height
        addBtn.layer.cornerRadius = height / 2
    }
    
    func setupNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterIngredientUpdateToExistingRecipe), name: NSNotification.Name("IngredientUpdateToExistingRecipe"), object: nil)
    }
    
    func setupSpinner() {
        spinner = NVActivityIndicatorView(frame: ActivityIndicatorConstants.frame, type: ActivityIndicatorConstants.type, color: ActivityIndicatorConstants.color, padding: nil)
        spinner.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
    }
    
    // updates
    
    func updateValues() {
        
        ingredients = recipe.ingredient?.allObjects as? [Ingredient]
        tableView.reloadData()
    }
    
    @objc func updateAfterIngredientUpdateToExistingRecipe() {
        
        print("updateAfterIngredientUpdateToExistingRecipe, UpdateRecipeVC")
        navigationItem.hidesBackButton = true
        
        let deleteBtn = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteBtn_clicked))
        navigationItem.leftBarButtonItem = deleteBtn
        
        updateRecipeIngredients()
    }
    
    /*
    @objc func updateAfterIngredientModification() {
        print("updateAfterIngredientModification, UpdateRecipeVC")
        updateRecipeIngredients()
    }
    */
    
    func updateRecipeIngredients() {
        
        ingredients = recipe.ingredient?.allObjects as? [Ingredient]
        ingredients.sort(by: { $0.updatedAt!.compare($1.updatedAt! as Date) == ComparisonResult.orderedDescending })
        tableView.reloadData()
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddDiaryEntryCell", for: indexPath) as! AddDiaryEntryCell
        
        let ingredient = ingredients[indexPath.row]
        cell.nameLbl.text = ingredient.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ingredient = ingredients[indexPath.row]
        presentIngredientUpdateDiaryEntryVC(ingredient: ingredient)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action:UITableViewRowAction, indexPath:IndexPath) in
            
            let alert = UIAlertController(title: "Are you sure you want to delete this entry", message: "", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                print("delete tapped")
                
                if let ingredient = self.ingredients[indexPath.row] as? Ingredient {
                    self.deleteIngredient(ingredient: ingredient, indexPathRow: indexPath.row)
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
        return ingredients.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "No ingredients"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetTitle(),
                          NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "Ingredients you add will appear here"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetDescription(),
                          NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: - actions
    
    func startSpinner() {
        
        self.view.addSubview(spinner)
        spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopSpinner() {
        self.view.isUserInteractionEnabled = true
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    func deleteIngredient(ingredient: Ingredient, indexPathRow: Int) {
        
        print("deleteIngredient")
        
        self.startSpinner()
        
        let id = "\(ingredient.objectId!)"
        let recipeId = "\(ingredient.recipeId!)"
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "\(baseUrl)/v1/recipes/\(recipeId)/ingredients/\(id)"
        
        let params = ["ingredient": [
            "id": id,
            "recipe_id": recipeId
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
                    try context.delete(ingredient)
                    try context.save()
                    self.updateAfterIngredientUpdateToExistingRecipe()
                } catch {
                    print("errors: \(error)")
                }
                
                //appDelegate.showInfoView(message: UIMessages.kIngredientDeleted, color: UIColor.popUpSuccess())
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
            
            self.stopSpinner()
        }
    }
    
    func deleteRecipe() {
        
        print("deleteRecipe")
        
        let id = (self.recipe.objectId!)
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
                    try context.delete(self.recipe)
                    try context.save()
                    self.postNotificationRecipeChange()
                    self.popBack(toControllerType: RecipesVC.self)
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
    
    func postNotificationRecipeChange() {
        print("postNotificationRecipeChange")
        NotificationCenter.default.post(name: NSNotification.Name("RecipeChanged"), object: nil)
    }
    
    @IBAction func addBtn_clicked(_ sender: Any) {
        print("addBtn_clicked")
        
        goToAddIngredientVC(recipe: self.recipe)
    }
    
    @objc func deleteBtn_clicked() {
        print("deleteBtn_clicked")
        
        let id = (self.recipe.objectId!)
        print("id: \(id)")
        
        //deleteRecipe()
        showDeleteAlertController()
    }
    
    // alert controller
    func showDeleteAlertController() {
        
        let alertController = UIAlertController(title: "Are you sure you want to delete this recipe?", message: "", preferredStyle: .alert)
        let signOutAction = UIAlertAction(title: "Delete", style: .default) { (response) in
            print("delete clicked")
            self.deleteRecipe()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (response) in
            print("cancel")
        }
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    // MARK: - navigation
    
    @objc func nextBtn_clicked() {
        print("nextBtn_clicked")
        
        self.view.endEditing(true)
        goToConfirmRecipeVC()
    }
    
    func goToConfirmRecipeVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmRecipeVC") as! ConfirmRecipeVC
        vc.recipe = self.recipe
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToAddIngredientVC(recipe: Recipe) {
        print("goToAddIngredientVC")
        
        print("recipe.objectId: \(self.recipe.objectId!)")
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddIngredientVC") as! AddIngredientVC
        vc.recipe = self.recipe
        //vc.recipeType = self.recipeType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentIngredientUpdateDiaryEntryVC(ingredient: Ingredient) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDiaryEntryVC") as! UpdateDiaryEntryVC
        vc.ingredient = ingredient
        vc.updateType = "ingredient"
        vc.previousVC = "UpdateRecipeVC"
        self.present(vc, animated: true)
    }
    
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
