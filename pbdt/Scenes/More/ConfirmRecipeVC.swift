//
//  ConfirmRecipeVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 5/4/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ConfirmRecipeVC: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK: - objects and vars
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var totalServingsLbl: UILabel!
    @IBOutlet weak var totalServingsTxt: UITextField!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    @IBOutlet weak var perServingLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var dividerView: UIView!
    
    var toolbar: UIToolbar!
    var spinner: NVActivityIndicatorView!
    
    var previousVc: String!
    
    var recipe: Recipe!
    var ingredients: [Ingredient]!
    var recipeName: String!
    
    var amountsServingsInitial: [Double]!
    var amountsServingsUpdated: [Double]!
    
    var amountsMacrosInitial: [Double]!
    var amountsMacrosUpdated: [Double]!
    
    var namesServings: [String]!
    var namesMacros: [String]!
    
    var servings_updated: Double = 0.0
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialValues()
        setupNavigationBar()
        setupViews()
        setupLabels()
        setupTextFields()
        setupTableView()
        setupButtons()
        setupToolbar()
        setupSpinner()
    }
    
    // setups
    
    func setInitialValues() {
        
        namesServings = StaticLists.servingsNameArray
        namesMacros = StaticLists.macrosNameArray
        
        servings_updated = recipe.servings
        recipeName = recipe.name
        
        var sumBeans: Double = 0
        var sumBerries: Double = 0
        var sumOtherFruits: Double = 0
        var sumCruciferousVegetables: Double = 0
        var sumGreens: Double = 0
        var sumOtherVegetables: Double = 0
        var sumFlaxseeds: Double = 0
        var sumNuts: Double = 0
        var sumTurmeric: Double = 0
        var sumWholeGrains: Double = 0
        var sumOtherSeeds: Double = 0
        
        var sumCals: Double = 0
        var sumFat: Double = 0
        var sumCarbs: Double = 0
        var sumProtein: Double = 0
        
        ingredients = recipe.ingredient?.allObjects as? [Ingredient]
        ingredients.sort(by: { $0.updatedAt!.compare($1.updatedAt! as Date) == ComparisonResult.orderedAscending })
        
        for ingredient in ingredients {
            sumBeans += ingredient.beansT
            sumBerries += ingredient.berriesT
            sumOtherFruits += ingredient.otherFruitsT
            sumCruciferousVegetables += ingredient.cruciferousVegetablesT
            sumGreens += ingredient.greensT
            sumOtherVegetables += ingredient.otherVegetablesT
            sumFlaxseeds += ingredient.flaxseedsT
            sumNuts += ingredient.nutsT
            sumTurmeric += ingredient.turmericT
            sumWholeGrains += ingredient.wholeGrainsT
            sumOtherSeeds += ingredient.otherSeedsT
            sumCals += ingredient.calsT
            sumFat += ingredient.fatT
            sumCarbs += ingredient.carbsT
            sumProtein += ingredient.proteinT
        }
        
        amountsServingsInitial = [
            (sumBeans / servings_updated).roundToPlaces(places: 1),
            (sumBerries / servings_updated).roundToPlaces(places: 1),
            (sumOtherFruits / servings_updated).roundToPlaces(places: 1),
            (sumCruciferousVegetables / servings_updated).roundToPlaces(places: 1),
            (sumGreens / servings_updated).roundToPlaces(places: 1),
            (sumOtherVegetables / servings_updated).roundToPlaces(places: 1),
            (sumFlaxseeds / servings_updated).roundToPlaces(places: 1),
            (sumNuts / servings_updated).roundToPlaces(places: 1),
            (sumTurmeric / servings_updated).roundToPlaces(places: 1),
            (sumWholeGrains / servings_updated).roundToPlaces(places: 1),
            (sumOtherSeeds / servings_updated).roundToPlaces(places: 1)
        ]
        
        amountsMacrosInitial = [
            (sumCals / servings_updated).roundToPlaces(places: 1),
            (sumFat / servings_updated).roundToPlaces(places: 1),
            (sumCarbs / servings_updated).roundToPlaces(places: 1),
            (sumProtein / servings_updated).roundToPlaces(places: 1)
        ]
        
        amountsServingsUpdated = amountsServingsInitial
        amountsMacrosUpdated = amountsMacrosInitial
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Recipe Summary"
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.mainViewBackground()
        topView.backgroundColor = UIColor.mainViewBackground()
        dividerView.backgroundColor = UIColor.viewDivider()
        
        segmentedControlView.parentVc = "ConfirmRecipeVC"
        segmentedControlView.confirmRecipeVc = self
    }
    
    func setupLabels() {
        
        nameLbl.text = "Name"
        nameLbl.textColor = UIColor.brandBlack()
        nameLbl.font = UIFont.large()
        
        totalServingsLbl.text = "Total Servings"
        totalServingsLbl.textColor = UIColor.brandBlack()
        totalServingsLbl.font = UIFont.large()
        
        let attributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.large(),
            NSAttributedString.Key.foregroundColor : UIColor.brandBlack(),
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        let attributeString = NSMutableAttributedString(string: "Per 1 serving:",
                                                        attributes: attributes)
        perServingLbl.attributedText = attributeString
    }
    
    func setupTextFields() {
        
        switch previousVc {
        case "RecipesVC":
            print("previousVc = RecipesVC")
            nameTxt.textColor = UIColor.brandBlack()
            nameTxt.isUserInteractionEnabled = false
            totalServingsTxt.textColor = UIColor.brandBlack()
            totalServingsTxt.isUserInteractionEnabled = false
        default:
            print("previousVc = d")
            nameTxt.textColor = UIColor.brandPrimary()
            nameTxt.isUserInteractionEnabled = true
            totalServingsTxt.textColor = UIColor.brandPrimary()
            totalServingsTxt.isUserInteractionEnabled = true
        }
        
        
        nameTxt.font = UIFont.large()
        nameTxt.delegate = self
        nameTxt.tag = 0
        nameTxt.borderStyle = .none
        nameTxt.text = "\(recipe.name!)"
        
        totalServingsTxt.text = "\(recipe.servings)"
        if (recipe.servings).isInt() {
            totalServingsTxt.text = "\(Int(recipe.servings))"
        }
        
        
        totalServingsTxt.font = UIFont.large()
        totalServingsTxt.delegate = self
        totalServingsTxt.tag = 1
        totalServingsTxt.borderStyle = .none
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "UpdateDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpdateDiaryEntryCell")
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 76, right: 0)
        tableView.contentInset = insets
        tableView.tableFooterView = UIView()
    }
    
    func setupButtons() {
        
        switch previousVc {
        case "RecipesVC":
            print("previousVc = RecipesVC")
            actionBtn.setTitle("Edit Recipe", for: .normal)
        default:
            print("previousVc = d")
            actionBtn.setTitle("Save Recipe", for: .normal)
        }
        
        actionBtn.backgroundColor = UIColor.actionButtonBackground()
        actionBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        actionBtn.titleLabel?.font = UIFont.actionButtonText()
        actionBtn.layer.shadowColor = UIColor.brandGreyDark().cgColor
        actionBtn.layer.shadowOffset = ButtonConstants.shadowOffset
        actionBtn.layer.shadowOpacity = ButtonConstants.shadowOpacity
        let height = actionBtn.frame.height
        actionBtn.layer.cornerRadius = height / 2
    }
    
    func setupToolbar() {
        
        toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.isUserInteractionEnabled = true
        toolbar.tintColor = UIColor.toolbarText()
        toolbar.barTintColor = UIColor.toolbarBackground()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        
        nameTxt.inputAccessoryView = toolbar
        totalServingsTxt.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked() {
        // end editing
        view.endEditing(true)
    }
    
    func setupSpinner() {
        spinner = NVActivityIndicatorView(frame: ActivityIndicatorConstants.frame, type: ActivityIndicatorConstants.type, color: ActivityIndicatorConstants.color, padding: nil)
        spinner.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
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
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            return namesServings.count
        case 1:
            return namesMacros.count
        default:
            print("d")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateDiaryEntryCell", for: indexPath) as! UpdateDiaryEntryCell
        
        switch self.segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            let name = namesServings[indexPath.row]
            let amountServing = amountsServingsUpdated[indexPath.row]
            
            cell.nameLbl.text = name
            cell.amountLbl.text = "\(amountServing)"
//            if amountServing.isInt() {
//                cell.amountLbl.text = "\(Int(amountServing))"
//            }
        case 1:
            let name = namesMacros[indexPath.row]
            let amountServing = amountsMacrosUpdated[indexPath.row]
            
            cell.nameLbl.text = name
            cell.amountLbl.text = "\(amountServing)"
//            if amountServing.isInt() {
//                cell.amountLbl.text = "\(Int(amountServing))"
//            }
        default:
            print("d")
        }
        
        return cell
    }
    
    // text fields
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 1:
            
            let textFieldText : NSString = (textField.text ?? "") as NSString
            let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string) as NSString
            
            self.servings_updated = (txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            
            if txtAfterUpdate == "" {
                amountsServingsUpdated = [
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
                ]
                
                amountsMacrosUpdated = [
                    0,
                    0,
                    0,
                    0
                ]
            } else {
                amountsServingsUpdated = [
                    ((amountsServingsInitial[0] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[1] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[2] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[3] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[4] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[5] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[6] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[7] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[8] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[9] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsServingsInitial[10] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
                ]
                
                amountsMacrosUpdated = [
                    ((amountsMacrosInitial[0] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsMacrosInitial[1] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsMacrosInitial[2] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    ((amountsMacrosInitial[3] * recipe.servings) / txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
                ]
            }
            
            tableView.reloadData()
        default:
            print("d")
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 0:
            self.recipeName = textField.text
        case 1:
            
            if ("\(textField.text)").dotsCheck() {
                appDelegate.showInfoView(message: UIMessages.kInputFormatIncorrect, color: UIColor.popUpFailure())
                return false
            }
            
            if textField.text == "" {
                appDelegate.showInfoView(message: UIMessages.kInputBlank, color: UIColor.popUpFailure())
                return false
            }
            
            if textField.text == "0" || textField.text == "0.0" {
                appDelegate.showInfoView(message: UIMessages.kInputZero, color: UIColor.popUpFailure())
                return false
            }
        default:
            print("d")
        }
        
        return true
    }
    
    /*
    // notifications
    
    func postNotificationRecipeModification() {
        print("postNotificationRecipeModification")
        NotificationCenter.default.post(name: NSNotification.Name("RecipeModification"), object: nil)
    }
    */
    
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
    
    @IBAction func actionBtn_clicked(_ sender: Any) {
        print("actionBtn_clicked")
        
        switch previousVc {
        case "RecipesVC":
            print("previousVc = RecipesVC")
            goToUpdateRecipeVC(recipe: self.recipe)
        default:
            print("previousVc = d")
            self.view.endEditing(true)
            updateRecipe()
        }
    }
    
    func updateRecipe() {
        
        self.startSpinner()
        
        let recipeId = "\(self.recipe.objectId!)"
        print("recipeId: \(recipeId)")
        
        //let id = "\(recipeId)"
        let name = self.recipeName
        let servings = "\(servings_updated)"
        let beans = "\(amountsServingsUpdated[0])"
        let berries = "\(amountsServingsUpdated[1])"
        let otherFruits = "\(amountsServingsUpdated[2])"
        let cruciferousVegetables = "\(amountsServingsUpdated[3])"
        let greens = "\(amountsServingsUpdated[4])"
        let otherVegetables = "\(amountsServingsUpdated[5])"
        let flaxseeds = "\(amountsServingsUpdated[6])"
        let nuts = "\(amountsServingsUpdated[7])"
        let turmeric = "\(amountsServingsUpdated[8])"
        let wholeGrains = "\(amountsServingsUpdated[9])"
        let otherSeeds = "\(amountsServingsUpdated[10])"
        let cals = "\(amountsMacrosUpdated[0])"
        let fat = "\(amountsMacrosUpdated[1])"
        let carbs = "\(amountsMacrosUpdated[2])"
        let protein = "\(amountsMacrosUpdated[3])"
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "\(baseUrl)/v1/recipes/\(recipeId)"
        
        print("url: \(url)")
        
        let params = ["recipe": [
            "name": name,
            "servings": servings,
            "beans": beans,
            "berries": berries,
            "other_fruits": otherFruits,
            "cruciferous_vegetables": cruciferousVegetables,
            "greens": greens,
            "other_vegetables": otherVegetables,
            "flaxseeds": flaxseeds,
            "nuts": nuts,
            "turmeric": turmeric,
            "whole_grains": wholeGrains,
            "other_seeds": otherSeeds,
            "cals": cals,
            "fat": fat,
            "carbs": carbs,
            "protein": protein
            ]
        ]
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            print(response)
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    print("JSON: \(JSON)")
                    
                    for recipe in JSON {
                        Recipe.findOrCreateFromJSON(recipe, context: context)
                    }
                    
                    self.postNotificationRecipeChange()
                    appDelegate.showInfoView(message: UIMessages.kRecipeUpdated, color: UIColor.popUpSuccess())
                    self.popBack(toControllerType: RecipesVC.self)
                }
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
            
            self.stopSpinner()
        }
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
    
    func goToUpdateRecipeVC(recipe: Recipe) {
        print("goToUpdateRecipeVC")
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "UpdateRecipeVC") as! UpdateRecipeVC
        vc.recipe = self.recipe
        vc.previousVc = "ConfirmRecipeVC"
        //vc.recipeType = "update"
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
