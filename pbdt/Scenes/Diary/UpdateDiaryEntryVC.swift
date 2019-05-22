//
//  UpdateDiaryEntryVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/5/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import Alamofire
import Segmentio
import NVActivityIndicatorView

class UpdateDiaryEntryVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    // MARK: - objects and vars
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var totalServingSizeLbl: UILabel!
    @IBOutlet weak var servingSizeLbl: UILabel!
    @IBOutlet weak var numberOfServingsLbl: UILabel!
    @IBOutlet weak var servingSizeTxt: UITextField!
    @IBOutlet weak var numberOfServingsTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var tapView: UIView!
    
    var toolbar: UIToolbar!
    var spinner: NVActivityIndicatorView!
    
    var previousVC = ""
    var namesServings: [String]!
    var amountsServings: [Double]!
    var namesMacros: [String]!
    var amountsMacros: [Double]!
    
    var entry: Food!
    var ssAmtVolT_updated: Double = 0.0
    var ssAmtWtT_updated: Double = 0.0
    var servingsT_updated: Double = 0.0
    
    var item: Item!
    var ssAmtVolT_new: Double = 0.0
    var ssAmtWtT_new: Double = 0.0
    var servingsT_new: Double = 1.0
    var recipeId: String!
    
    var recipe: Recipe!
    
    var ingredient: Ingredient!
    
    var addType: String!
    var updateType: String!
    //var recipeType: String!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("entry: \(entry)")
        print("previousVC: \(previousVC)")
        
        setInitialValues()
        
        setupViews()
        setupLabels()
        setupTextFields()
        setupButtons()
        setupTableView()
        setupToolbar()
        setupSpinner()
    }
    
    // setups
    
    func setInitialValues() {
        
        namesServings = StaticLists.servingsNameArray
        namesMacros = StaticLists.macrosNameArray
        
        switch previousVC {
        case "DiaryVC", "VarietyDetailVC":
             print("setInitialValues, previousVC = DiaryVC, VarietyDetailVC")
             
             switch updateType {
             case "item":
                ssAmtWtT_updated = entry.ssAmtWtT
                ssAmtVolT_updated = entry.ssAmtVolT
             default:
                print("d")
             }
             
             amountsServings = [
                entry.beansT,
                entry.berriesT,
                entry.otherFruitsT,
                entry.cruciferousVegetablesT,
                entry.greensT,
                entry.otherVegetablesT,
                entry.flaxseedsT,
                entry.nutsT,
                entry.turmericT,
                entry.wholeGrainsT,
                entry.otherSeedsT
             ]
             
             amountsMacros = [
                entry.calsT,
                entry.fatT,
                entry.carbsT,
                entry.proteinT
             ]
             
             servingsT_updated = entry.servingsT
        case "AddDiaryEntryVC", "AddIngredientVC", "FoodGroupDetailVC":
            print("setInitialValues, previousVC = AddDiaryEntryVC, AddIngredientVC, FoodGroupDetailVC")
            
            switch addType {
            case "item":
                
                amountsServings = [
                    item.beans,
                    item.berries,
                    item.otherFruits,
                    item.cruciferousVegetables,
                    item.greens,
                    item.otherVegetables,
                    item.flaxseeds,
                    item.nuts,
                    item.turmeric,
                    item.wholeGrains,
                    item.otherSeeds
                ]
                
                amountsMacros = [
                    item.cals,
                    item.fat,
                    item.carbs,
                    item.protein
                ]
                
                ssAmtWtT_new = item.ssAmtWt
                ssAmtVolT_new = item.ssAmtVol
            case "recipe":
                
                amountsServings = [
                    recipe.beans,
                    recipe.berries,
                    recipe.otherFruits,
                    recipe.cruciferousVegetables,
                    recipe.greens,
                    recipe.otherVegetables,
                    recipe.flaxseeds,
                    recipe.nuts,
                    recipe.turmeric,
                    recipe.wholeGrains,
                    recipe.otherSeeds
                ]
                
                amountsMacros = [
                    recipe.cals,
                    recipe.fat,
                    recipe.carbs,
                    recipe.protein
                ]
            default:
                print("d")
            }
        case "UpdateRecipeVC":
            print("setInitialValues, previousVC = UpdateRecipeVC")
            
            ssAmtWtT_updated = ingredient.ssAmtWtT
            ssAmtVolT_updated = ingredient.ssAmtVolT
            servingsT_updated = ingredient.servingsT
            
            amountsServings = [
                ingredient.beansT,
                ingredient.berriesT,
                ingredient.otherFruitsT,
                ingredient.cruciferousVegetablesT,
                ingredient.greensT,
                ingredient.otherVegetablesT,
                ingredient.flaxseedsT,
                ingredient.nutsT,
                ingredient.turmericT,
                ingredient.wholeGrainsT,
                ingredient.otherSeedsT
            ]
            
            amountsMacros = [
                ingredient.calsT,
                ingredient.fatT,
                ingredient.carbsT,
                ingredient.proteinT
            ]
        default:
            print("setInitialValues, previousVC = default")
        }
    }
    
    func setupViews() {
        
        view.backgroundColor = UIColor.mainViewBackground()
        topView.backgroundColor = UIColor.viewBackground()
        dividerView.backgroundColor = UIColor.viewDivider()
        
        segmentedControlView.parentVc = "UpdateDiaryEntryVC"
        segmentedControlView.updateDiaryEntryVc = self
        
        topView.backgroundColor = .clear
        tapView.isUserInteractionEnabled = true
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView_clicked)))
    }
    
    func setupLabels() {
        
        nameLbl.font = UIFont.large()
        nameLbl.textColor = UIColor.brandPrimary()
        
        totalServingSizeLbl.font = UIFont.small()
        totalServingSizeLbl.textColor = UIColor.brandGreyDark()
        
        servingSizeLbl.font = UIFont.large()
        servingSizeLbl.textColor = UIColor.brandBlack()
        servingSizeLbl.text = "Serving size"
        
        numberOfServingsLbl.font = UIFont.large()
        numberOfServingsLbl.textColor = UIColor.brandBlack()
        numberOfServingsLbl.text = "Number of servings"
        
        updateLabels()
    }
    
    func setupTextFields() {
        
        servingSizeTxt.tag = 900
        servingSizeTxt.borderStyle = .none
        servingSizeTxt.isUserInteractionEnabled = false
        servingSizeTxt.font = UIFont.large()
        servingSizeTxt.textColor = UIColor.brandBlack()
        
        numberOfServingsTxt.tag = 901
        numberOfServingsTxt.borderStyle = .none
        numberOfServingsTxt.isUserInteractionEnabled = true
        numberOfServingsTxt.delegate = self
        numberOfServingsTxt.font = UIFont.large()
        numberOfServingsTxt.textColor = UIColor.brandSecondary()
        
        switch previousVC {
        case "DiaryVC", "VarietyDetailVC":
            print("setupTextFields, previousVC = DiaryVC, VarietyDetailVC")
            
            switch updateType {
            case "item":
                
                let ssAmtVol = (entry.ssAmtVolT / entry.servingsT).roundToPlaces(places: 1)
                let ssAmtWt = (entry.ssAmtWtT / entry.servingsT).roundToPlaces(places: 1)
                
                if let ssUnitVolT = entry.ssUnitVolT, let ssUnitWtT = entry.ssUnitWtT {
                    // round if int
                    if ssAmtVol.isInt() && ssAmtWt.isInt() {
                        servingSizeTxt.text = "\(Int(ssAmtVol)) \(ssUnitVolT), \(Int(ssAmtWt)) \(ssUnitWtT)"
                    } else if !ssAmtVol.isInt() && ssAmtWt.isInt() {
                        servingSizeTxt.text = "\(ssAmtVol) \(ssUnitVolT), \(Int(ssAmtWt)) \(ssUnitWtT)"
                    } else if ssAmtVol.isInt() && !ssAmtWt.isInt() {
                        servingSizeTxt.text = "\(Int(ssAmtVol)) \(ssUnitVolT), \(ssAmtWt) \(ssUnitWtT)"
                    } else {
                        servingSizeTxt.text = "\(ssAmtVol) \(ssUnitVolT), \(ssAmtWt) \(ssUnitWtT)"
                    }
                }
            case "recipe":
                servingSizeTxt.text = "1 recipe serving"
            default:
                print("d")
            }
            
            numberOfServingsTxt.text = "\(servingsT_updated)"
            if servingsT_updated.isInt() {
                numberOfServingsTxt.text = "\(Int(servingsT_updated))"
            }
        case "AddDiaryEntryVC", "AddIngredientVC", "FoodGroupDetailVC":
            print("setupTextFields, previousVC = AddDiaryEntryVC, AddIngredientVC, FoodGroupDetailVC")
            
            switch addType {
            case "item":
                
                if let ssUnitVol = item.ssUnitVol, let ssUnitWt = item.ssUnitWt {
                    // round if int
                    if ssAmtVolT_new.isInt() && ssAmtWtT_new.isInt() {
                        servingSizeTxt.text = "\(Int(ssAmtVolT_new)) \(ssUnitVol), \(Int(ssAmtWtT_new)) \(ssUnitWt)"
                    } else if !ssAmtVolT_new.isInt() && ssAmtWtT_new.isInt() {
                        servingSizeTxt.text = "\(ssAmtVolT_new) \(ssUnitVol), \(Int(ssAmtWtT_new)) \(ssUnitWt)"
                    } else if ssAmtVolT_new.isInt() && !ssAmtWtT_new.isInt() {
                        servingSizeTxt.text = "\(Int(ssAmtVolT_new)) \(ssUnitVol), \(ssAmtWtT_new) \(ssUnitWt)"
                    } else {
                        servingSizeTxt.text = "\(ssAmtVolT_new) \(ssUnitVol), \(ssAmtWtT_new) \(ssUnitWt)"
                    }
                }
            case "recipe":
                servingSizeTxt.text = "1 recipe serving"
            default:
                print("d")
            }
            
            numberOfServingsTxt.text = "\(servingsT_new)"
            if servingsT_new.isInt() {
                numberOfServingsTxt.text = "\(Int(servingsT_new))"
            }
        case "UpdateRecipeVC":
            print("setupTextFields, previousVC = UpdateRecipeVC")
            
            let ssAmtVol = (ingredient.ssAmtVolT / ingredient.servingsT).roundToPlaces(places: 1)
            let ssAmtWt = (ingredient.ssAmtWtT / ingredient.servingsT).roundToPlaces(places: 1)
            
            if let ssUnitVolT = ingredient.ssUnitVolT, let ssUnitWtT = ingredient.ssUnitWtT {
                // round if int
                if ssAmtVol.isInt() && ssAmtWt.isInt() {
                    servingSizeTxt.text = "\(Int(ssAmtVol)) \(ssUnitVolT), \(Int(ssAmtWt)) \(ssUnitWtT)"
                } else if !ssAmtVol.isInt() && ssAmtWt.isInt() {
                    servingSizeTxt.text = "\(ssAmtVol) \(ssUnitVolT), \(Int(ssAmtWt)) \(ssUnitWtT)"
                } else if ssAmtVol.isInt() && !ssAmtWt.isInt() {
                    servingSizeTxt.text = "\(Int(ssAmtVol)) \(ssUnitVolT), \(ssAmtWt) \(ssUnitWtT)"
                } else {
                    servingSizeTxt.text = "\(ssAmtVol) \(ssUnitVolT), \(ssAmtWt) \(ssUnitWtT)"
                }
            }
            
            numberOfServingsTxt.text = "\(servingsT_updated)"
            if servingsT_updated.isInt() {
                numberOfServingsTxt.text = "\(Int(servingsT_updated))"
            }
            
        default:
            print("setupTextFields, previousVC = default")
        }
    }
    
    func setupButtons() {
        
        switch previousVC {
        case "DiaryVC", "VarietyDetailVC":
            print("setupButtons, previousVC = DiaryVC, VarietyDetailVC")
            
            actionBtn.setTitle("Update", for: .normal)
        case "AddDiaryEntryVC", "FoodGroupDetailVC":
            print("setupButtons, previousVC = AddDiaryEntryVC, FoodGroupDetailVC")
            
            actionBtn.setTitle("Add To Diary", for: .normal)
        case "AddIngredientVC":
            print("setupButtons, previousVC = AddIngredientVC")
            
            actionBtn.setTitle("Save Ingredient", for: .normal)
        case "UpdateRecipeVC":
            print("setupButtons, previousVC = UpdateRecipeVC")
            
            actionBtn.setTitle("Update Ingredient", for: .normal)
        default:
            print("setupButtons, previousVC = default")
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
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "UpdateDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpdateDiaryEntryCell")
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 76, right: 0)
        tableView.contentInset = insets
        
        tableView.tableFooterView = UIView()
    }
    
    func setupSpinner() {
        spinner = NVActivityIndicatorView(frame: ActivityIndicatorConstants.frame, type: ActivityIndicatorConstants.type, color: ActivityIndicatorConstants.color, padding: nil)
        spinner.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
    }
    
    // updates
    
    func updateLabels() {
        print("updateLabels: start")
        
        switch previousVC {
        case "DiaryVC", "VarietyDetailVC":
            print("updateLabels, previousVC = DiaryVC, VarietyDetailVC")
            
            if let name = entry.name {
                nameLbl.text = "\(name)"
            }
            
            switch updateType {
            case "item":
                
                if let ssUnitVolT = entry.ssUnitVolT, let ssUnitWtT = entry.ssUnitWtT {
                    
                    // round if int
                    if ssAmtVolT_updated.isInt() && ssAmtWtT_updated.isInt() {
                        totalServingSizeLbl.text = "\(Int(ssAmtVolT_updated)) \(ssUnitVolT), \(Int(ssAmtWtT_updated)) \(ssUnitWtT)"
                    } else if !ssAmtVolT_updated.isInt() && ssAmtWtT_updated.isInt() {
                        totalServingSizeLbl.text = "\(ssAmtVolT_updated) \(ssUnitVolT), \(Int(ssAmtWtT_updated)) \(ssUnitWtT)"
                    } else if ssAmtVolT_updated.isInt() && !ssAmtWtT_updated.isInt() {
                        totalServingSizeLbl.text = "\(Int(ssAmtVolT_updated)) \(ssUnitVolT), \(ssAmtWtT_updated) \(ssUnitWtT)"
                    } else {
                        totalServingSizeLbl.text = "\(ssAmtVolT_updated) \(ssUnitVolT), \(ssAmtWtT_updated) \(ssUnitWtT)"
                    }
                }
            case "recipe":
                
                if servingsT_updated == 1 {
                    totalServingSizeLbl.text = "\(servingsT_updated) recipe serving"
                } else {
                    totalServingSizeLbl.text = "\(servingsT_updated) recipe servings"
                }
                
                if servingsT_updated.isInt() {
                    if servingsT_updated == 1 {
                        totalServingSizeLbl.text = "\(Int(servingsT_updated)) recipe serving"
                    } else {
                        totalServingSizeLbl.text = "\(Int(servingsT_updated)) recipe servings"
                    }
                }
            default:
                print("d")
            }
        case "AddDiaryEntryVC", "AddIngredientVC", "FoodGroupDetailVC":
            print("updateLabels, previousVC = AddDiaryEntryVC, AddIngredientVC, FoodGroupDetailVC")
            
            switch addType {
            case "item":
                
                if let name = item.name {
                    nameLbl.text = "\(name)"
                }
                
                if let ssUnitVol = item.ssUnitVol, let ssUnitWt = item.ssUnitWt {
                    
                    // round if int
                    if ssAmtVolT_new.isInt() && ssAmtWtT_new.isInt() {
                        totalServingSizeLbl.text = "\(Int(ssAmtVolT_new)) \(ssUnitVol), \(Int(ssAmtWtT_new)) \(ssUnitWt)"
                    } else if !ssAmtVolT_new.isInt() && ssAmtWtT_new.isInt() {
                        totalServingSizeLbl.text = "\(ssAmtVolT_new) \(ssUnitVol), \(Int(ssAmtWtT_new)) \(ssUnitWt)"
                    } else if ssAmtVolT_new.isInt() && !ssAmtWtT_new.isInt() {
                        totalServingSizeLbl.text = "\(Int(ssAmtVolT_new)) \(ssUnitVol), \(ssAmtWtT_new) \(ssUnitWt)"
                    } else {
                        totalServingSizeLbl.text = "\(ssAmtVolT_new) \(ssUnitVol), \(ssAmtWtT_new) \(ssUnitWt)"
                    }
                }
            case "recipe":
                
                if let name = recipe.name {
                    nameLbl.text = "\(name)"
                }
                
                if servingsT_updated == 1 {
                    totalServingSizeLbl.text = "\(servingsT_new) recipe serving"
                } else {
                    totalServingSizeLbl.text = "\(servingsT_new) recipe servings"
                }
                
                if servingsT_updated.isInt() {
                    if servingsT_updated == 1 {
                        totalServingSizeLbl.text = "\(Int(servingsT_new)) recipe serving"
                    } else {
                        totalServingSizeLbl.text = "\(Int(servingsT_new)) recipe servings"
                    }
                }
            default:
                print("d")
            }
        case "UpdateRecipeVC":
            print("updateLabels, previousVC = UpdateRecipeVC")
            
            print("ingredient: \(ingredient)")
            
            if let name = ingredient.name {
                nameLbl.text = "\(name)"
            }
            
            //print("ingredient.ssUnitVolT: \(ingredient.ssUnitVolT), ingredient.ssUnitWtT : \(ingredient.ssUnitWtT)")
            
            if let ssUnitVolT = ingredient.ssUnitVolT, let ssUnitWtT = ingredient.ssUnitWtT {
                
                // round if int
                if ssAmtVolT_updated.isInt() && ssAmtWtT_updated.isInt() {
                    totalServingSizeLbl.text = "\(Int(ssAmtVolT_updated)) \(ssUnitVolT), \(Int(ssAmtWtT_updated)) \(ssUnitWtT)"
                } else if !ssAmtVolT_updated.isInt() && ssAmtWtT_updated.isInt() {
                    totalServingSizeLbl.text = "\(ssAmtVolT_updated) \(ssUnitVolT), \(Int(ssAmtWtT_updated)) \(ssUnitWtT)"
                } else if ssAmtVolT_updated.isInt() && !ssAmtWtT_updated.isInt() {
                    totalServingSizeLbl.text = "\(Int(ssAmtVolT_updated)) \(ssUnitVolT), \(ssAmtWtT_updated) \(ssUnitWtT)"
                } else {
                    totalServingSizeLbl.text = "\(ssAmtVolT_updated) \(ssUnitVolT), \(ssAmtWtT_updated) \(ssUnitWtT)"
                }
            }
        default:
            print("updateLabels, previousVC = default")
        }
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
        
        numberOfServingsTxt.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked() {
        // end editing
        view.endEditing(true)
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
            let amountServing = amountsServings[indexPath.row]
            
            cell.nameLbl.text = name
            cell.amountLbl.text = "\(amountServing)"
            if amountServing.isInt() {
                cell.amountLbl.text = "\(Int(amountServing))"
            }
        case 1:
            let name = namesMacros[indexPath.row]
            let amountServing = amountsMacros[indexPath.row]
            
            cell.nameLbl.text = name
            cell.amountLbl.text = "\(amountServing)"
            if amountServing.isInt() {
                cell.amountLbl.text = "\(Int(amountServing))"
            }
        default:
            print("d")
        }
        
        return cell
    }
    
    // text fields
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText : NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string) as NSString
        
        switch previousVC {
        case "DiaryVC", "VarietyDetailVC":
            print("shouldChangeCharactersIn, previousVC = DiaryVC, VarietyDetailVC")
            
            self.ssAmtVolT_updated = (entry.ssAmtVolT / entry.servingsT * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            self.ssAmtWtT_updated = (entry.ssAmtWtT / entry.servingsT * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            self.servingsT_updated = (txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            
            amountsServings = [
                ((entry.beansT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.berriesT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.otherFruitsT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.cruciferousVegetablesT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.greensT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.otherVegetablesT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.flaxseedsT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.nutsT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.turmericT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.wholeGrainsT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.otherSeedsT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            ]
            
            amountsMacros = [
                ((entry.calsT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.fatT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.carbsT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((entry.proteinT / entry.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            ]
        case "AddDiaryEntryVC", "AddIngredientVC", "FoodGroupDetailVC":
            print("shouldChangeCharactersIn, previousVC = AddDiaryEntryVC, AddIngredientVC, FoodGroupDetailVC")
            
            self.servingsT_new = (txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            
            switch addType {
            case "item":
                
                self.ssAmtVolT_new = (item.ssAmtVol * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
                self.ssAmtWtT_new = (item.ssAmtWt * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
                
                amountsServings = [
                    (item.beans * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.berries * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.otherFruits * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.cruciferousVegetables * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.greens * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.otherVegetables * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.flaxseeds * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.nuts * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.turmeric * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.wholeGrains * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.otherSeeds * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
                ]
                
                amountsMacros = [
                    (item.cals * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.fat * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.carbs * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (item.protein * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
                ]
            case "recipe":
                
                amountsServings = [
                    (recipe.beans * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.berries * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.otherFruits * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.cruciferousVegetables * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.greens * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.otherVegetables * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.flaxseeds * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.nuts * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.turmeric * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.wholeGrains * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.otherSeeds * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
                ]
                
                amountsMacros = [
                    (recipe.cals * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.fat * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.carbs * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                    (recipe.protein * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
                ]
            default:
                print("d")
            }
        case "UpdateRecipeVC":
            print("shouldChangeCharactersIn, previousVC = UpdateRecipeVC")
            
            self.ssAmtVolT_updated = (ingredient.ssAmtVolT / ingredient.servingsT * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            self.ssAmtWtT_updated = (ingredient.ssAmtWtT / ingredient.servingsT * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            self.servingsT_updated = (txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            
            amountsServings = [
                ((ingredient.beansT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.berriesT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.otherFruitsT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.cruciferousVegetablesT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.greensT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.otherVegetablesT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.flaxseedsT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.nutsT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.turmericT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.wholeGrainsT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.otherSeedsT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            ]
            
            amountsMacros = [
                ((ingredient.calsT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.fatT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.carbsT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1),
                ((ingredient.proteinT / ingredient.servingsT) * txtAfterUpdate.doubleValue).roundToPlaces(places: 1)
            ]
            
        default:
            print("shouldChangeCharactersIn, previousVC = default")
        }
        
        updateLabels()
        
        tableView.reloadData()
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        switch previousVC {
        case "DiaryVC", "UpdateRecipeVC", "VarietyDetailVC":
            textField.text = "\(servingsT_updated)"
            if servingsT_updated.isInt() {
                numberOfServingsTxt.text = "\(Int(servingsT_updated))"
            }
        case "AddDiaryEntryVC", "AddIngredientVC", "FoodGroupDetailVC":
            textField.text = "\(servingsT_new)"
            if servingsT_new.isInt() {
                numberOfServingsTxt.text = "\(Int(servingsT_new))"
            }
        default:
            print("d")
        }
        
        return true
    }
    
    // notifications
    
    func postNotificationFoodModification() {
        print("postNotificationFoodModification")
        NotificationCenter.default.post(name: NSNotification.Name("FoodModification"), object: nil)
    }
    
    func postNotificationIngredientUpdateToExistingRecipe() {
        print("postNotificationIngredientUpdateToExistingRecipe")
        NotificationCenter.default.post(name: NSNotification.Name("IngredientUpdateToExistingRecipe"), object: nil)
    }
    
    // MARK: - actions
    
    func updateFood() {
        
        self.startSpinner()
        
        var ssAmtWtT = ""
        var ssAmtVolT = ""
        
        let id = "\(entry.objectId!)"
        let servingsT = "\(servingsT_updated)"
        //let ssAmtWtT = "\(ssAmtWtT_updated)"
        //let ssAmtVolT = "\(ssAmtVolT_updated)"
        let beansT = "\(amountsServings[0])"
        let berriesT = "\(amountsServings[1])"
        let otherFruitsT = "\(amountsServings[2])"
        let cruciferousVegetablesT = "\(amountsServings[3])"
        let greensT = "\(amountsServings[4])"
        let otherVegetablesT = "\(amountsServings[5])"
        let flaxseedsT = "\(amountsServings[6])"
        let nutsT = "\(amountsServings[7])"
        let turmericT = "\(amountsServings[8])"
        let wholeGrainsT = "\(amountsServings[9])"
        let otherSeedsT = "\(amountsServings[10])"
        let calsT = "\(amountsMacros[0])"
        let fatT = "\(amountsMacros[1])"
        let carbsT = "\(amountsMacros[2])"
        let proteinT = "\(amountsMacros[3])"
        //let logDate = "\(appDelegate.dateFilter.toString(format: "yyyy-MM-dd"))"
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "\(baseUrl)/v1/foods/\(id)"
        
        switch updateType {
        case "item":
            ssAmtWtT = "\(ssAmtWtT_updated)"
            ssAmtVolT = "\(ssAmtVolT_updated)"
        case "recipe":
            ssAmtWtT = "0"
            ssAmtVolT = "0"
        default:
            print("d")
        }
        
        let params = ["food": [
            "servings_t": servingsT,
            "ss_amt_wt_t": ssAmtWtT,
            "ss_amt_vol_t": ssAmtVolT,
            "beans_t": beansT,
            "berries_t": berriesT,
            "other_fruits_t": otherFruitsT,
            "cruciferous_vegetables_t": cruciferousVegetablesT,
            "greens_t": greensT,
            "other_vegetables_t": otherVegetablesT,
            "flaxseeds_t": flaxseedsT,
            "nuts_t": nutsT,
            "turmeric_t": turmericT,
            "whole_grains_t": wholeGrainsT,
            "other_seeds_t": otherSeedsT,
            "cals_t": calsT,
            "fat_t": fatT,
            "carbs_t": carbsT,
            "protein_t": proteinT
            ]
        ]
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for food in JSON {
                        Food.findOrCreateFromJSON(food, context: context)
                    }
                    appDelegate.showInfoView(message: UIMessages.kEntryUpdated, color: UIColor.popUpSuccess())
                    self.postNotificationFoodModification()
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
            
            self.stopSpinner()
        }
    }
    
    func newFood() {
        
        self.startSpinner()
        
        var name = ""
        var variety = ""
        var ssAmtWtT = ""
        var ssAmtVolT = ""
        var ssUnitWtT = ""
        var ssUnitVolT = ""
        let servingsT = "\(servingsT_new)"
        
        let beansT = "\(amountsServings[0])"
        let berriesT = "\(amountsServings[1])"
        let otherFruitsT = "\(amountsServings[2])"
        let cruciferousVegetablesT = "\(amountsServings[3])"
        let greensT = "\(amountsServings[4])"
        let otherVegetablesT = "\(amountsServings[5])"
        let flaxseedsT = "\(amountsServings[6])"
        let nutsT = "\(amountsServings[7])"
        let turmericT = "\(amountsServings[8])"
        let wholeGrainsT = "\(amountsServings[9])"
        let otherSeedsT = "\(amountsServings[10])"
        let calsT = "\(amountsMacros[0])"
        let fatT = "\(amountsMacros[1])"
        let carbsT = "\(amountsMacros[2])"
        let proteinT = "\(amountsMacros[3])"
        let logDate = "\(appDelegate.dateFilter.toString(format: "yyyy-MM-dd"))"
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "\(baseUrl)/v1/foods"
        
        switch addType {
        case "item":
            name = "\(item.name!)"
            variety = "\(item.variety!)"
            ssAmtWtT = "\(ssAmtWtT_new)"
            ssAmtVolT = "\(ssAmtVolT_new)"
            ssUnitWtT = "\(item.ssUnitWt!)"
            ssUnitVolT = "\(item.ssUnitVol!)"
        case "recipe":
            name = "\(recipe.name!)"
            variety = "recipe"
            ssAmtWtT = "0"
            ssAmtVolT = "0"
            ssUnitWtT = "na"
            ssUnitVolT = "na"
        default:
            print("d")
        }
        
        let params = ["food": [
            "name": name,
            "variety": variety,
            "servings_t": servingsT,
            "ss_amt_wt_t": ssAmtWtT,
            "ss_amt_vol_t": ssAmtVolT,
            "ss_unit_wt_t": ssUnitWtT,
            "ss_unit_vol_t": ssUnitVolT,
            "beans_t": beansT,
            "berries_t": berriesT,
            "other_fruits_t": otherFruitsT,
            "cruciferous_vegetables_t": cruciferousVegetablesT,
            "greens_t": greensT,
            "other_vegetables_t": otherVegetablesT,
            "flaxseeds_t": flaxseedsT,
            "nuts_t": nutsT,
            "turmeric_t": turmericT,
            "whole_grains_t": wholeGrainsT,
            "other_seeds_t": otherSeedsT,
            "cals_t": calsT,
            "fat_t": fatT,
            "carbs_t": carbsT,
            "protein_t": proteinT,
            "log_date": logDate
            ]
        ]
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            //print(response)
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String: AnyObject] {
                    //print("JSON: \(JSON)")
                    Food.findOrCreateFromJSON(JSON, context: context)
                    appDelegate.showInfoView(message: UIMessages.kEntryAdded, color: UIColor.popUpSuccess())
                    self.postNotificationFoodModification()
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
            
            self.stopSpinner()
        }
    }
    
    func newIngredient() {
        
        self.startSpinner()
        
        let recipeId = "\(self.recipeId!)"
        print("recipeId: \(recipeId)")
        
        let name = "\(item.name!)"
        let variety = "\(item.variety!)"
        let ssAmtWtT = "\(ssAmtWtT_new)"
        let ssAmtVolT = "\(ssAmtVolT_new)"
        let ssUnitWtT = "\(item.ssUnitWt!)"
        let ssUnitVolT = "\(item.ssUnitVol!)"
        
        let servingsT = "\(servingsT_new)"
        
        let beansT = "\(amountsServings[0])"
        let berriesT = "\(amountsServings[1])"
        let otherFruitsT = "\(amountsServings[2])"
        let cruciferousVegetablesT = "\(amountsServings[3])"
        let greensT = "\(amountsServings[4])"
        let otherVegetablesT = "\(amountsServings[5])"
        let flaxseedsT = "\(amountsServings[6])"
        let nutsT = "\(amountsServings[7])"
        let turmericT = "\(amountsServings[8])"
        let wholeGrainsT = "\(amountsServings[9])"
        let otherSeedsT = "\(amountsServings[10])"
        let calsT = "\(amountsMacros[0])"
        let fatT = "\(amountsMacros[1])"
        let carbsT = "\(amountsMacros[2])"
        let proteinT = "\(amountsMacros[3])"
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "\(baseUrl)/v1/recipes/\(recipeId)/ingredients"
        
        let params = ["ingredient": [
            "recipeId": recipeId,
            "name": name,
            "variety": variety,
            "servings_t": servingsT,
            "ss_amt_wt_t": ssAmtWtT,
            "ss_amt_vol_t": ssAmtVolT,
            "ss_unit_wt_t": ssUnitWtT,
            "ss_unit_vol_t": ssUnitVolT,
            "beans_t": beansT,
            "berries_t": berriesT,
            "other_fruits_t": otherFruitsT,
            "cruciferous_vegetables_t": cruciferousVegetablesT,
            "greens_t": greensT,
            "other_vegetables_t": otherVegetablesT,
            "flaxseeds_t": flaxseedsT,
            "nuts_t": nutsT,
            "turmeric_t": turmericT,
            "whole_grains_t": wholeGrainsT,
            "other_seeds_t": otherSeedsT,
            "cals_t": calsT,
            "fat_t": fatT,
            "carbs_t": carbsT,
            "protein_t": proteinT
            ]
        ]
        
        print("params: \(params)")
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            print(response)
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String: AnyObject] {
                    print("JSON: \(JSON)")
                    
                    Ingredient.findOrCreateFromJSON(JSON, context: context)
                    
                    self.postNotificationIngredientUpdateToExistingRecipe()
                    
                    /*
                    switch self.recipeType {
                    case "update":
                        self.postNotificationIngredientUpdateToExistingRecipe()
                    default:
                        print("d")
                        self.postNotificationIngredientModification()
                    }
                    */
                    
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
            
            self.stopSpinner()
        }
    }
    
    func updateIngredient() {
        
        self.startSpinner()
        
        //print("ingredient: \(ingredient)")
        
        let id = self.ingredient.objectId!
        print("id: \(id)")
        
        let recipeId = self.ingredient.recipeId!
        print("recipeId: \(recipeId)")
        
        let ssAmtWtT = "\(ssAmtWtT_updated)"
        let ssAmtVolT = "\(ssAmtVolT_updated)"
        
        let servingsT = "\(servingsT_updated)"
        
        let beansT = "\(amountsServings[0])"
        let berriesT = "\(amountsServings[1])"
        let otherFruitsT = "\(amountsServings[2])"
        let cruciferousVegetablesT = "\(amountsServings[3])"
        let greensT = "\(amountsServings[4])"
        let otherVegetablesT = "\(amountsServings[5])"
        let flaxseedsT = "\(amountsServings[6])"
        let nutsT = "\(amountsServings[7])"
        let turmericT = "\(amountsServings[8])"
        let wholeGrainsT = "\(amountsServings[9])"
        let otherSeedsT = "\(amountsServings[10])"
        let calsT = "\(amountsMacros[0])"
        let fatT = "\(amountsMacros[1])"
        let carbsT = "\(amountsMacros[2])"
        let proteinT = "\(amountsMacros[3])"
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "\(baseUrl)/v1/recipes/\(recipeId)/ingredients/\(id)"
        
        print("url: \(url)")
        
        let params = ["ingredient": [
            "id": id,
            "recipeId": recipeId,
            "servings_t": servingsT,
            "ss_amt_wt_t": ssAmtWtT,
            "ss_amt_vol_t": ssAmtVolT,
            "beans_t": beansT,
            "berries_t": berriesT,
            "other_fruits_t": otherFruitsT,
            "cruciferous_vegetables_t": cruciferousVegetablesT,
            "greens_t": greensT,
            "other_vegetables_t": otherVegetablesT,
            "flaxseeds_t": flaxseedsT,
            "nuts_t": nutsT,
            "turmeric_t": turmericT,
            "whole_grains_t": wholeGrainsT,
            "other_seeds_t": otherSeedsT,
            "cals_t": calsT,
            "fat_t": fatT,
            "carbs_t": carbsT,
            "protein_t": proteinT
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
                    
                    for ingredientJSON in JSON {
                        Ingredient.findOrCreateFromJSON(ingredientJSON, context: context)
                    }
                    appDelegate.showInfoView(message: UIMessages.kIngredientUpdated, color: UIColor.popUpSuccess())
                    self.postNotificationIngredientUpdateToExistingRecipe()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
            
            self.stopSpinner()
        }
    }
    
    @objc func tapView_clicked() {
        print("tapView_clicked")
        self.numberOfServingsTxt.becomeFirstResponder()
    }
    
    @IBAction func actionBtn_clicked(_ sender: Any) {
        
        if ("\(numberOfServingsTxt.text)").dotsCheck() {
            appDelegate.showInfoView(message: UIMessages.kInputFormatIncorrect, color: UIColor.popUpFailure())
            return
        }
        
        if numberOfServingsTxt.text == "" {
            appDelegate.showInfoView(message: UIMessages.kInputBlank, color: UIColor.popUpFailure())
            return
        }
        
        if (numberOfServingsTxt.text as! NSString).doubleValue.isInt() && (Int(numberOfServingsTxt.text!) == 0) {
            appDelegate.showInfoView(message: UIMessages.kInputZero, color: UIColor.popUpFailure())
            return
        }
        
        switch previousVC {
        case "DiaryVC", "VarietyDetailVC":
            print("actionBtn_clicked, previousVC = DiaryVC, VarietyDetailVC")
            updateFood()
        case "AddDiaryEntryVC", "FoodGroupDetailVC":
            print("actionBtn_clicked, previousVC = AddDiaryEntryVC, FoodGroupDetailVC")
            newFood()
        case "AddIngredientVC":
            print("actionBtn_clicked, previousVC = AddIngredientVC")
            newIngredient()
        case "UpdateRecipeVC":
            print("actionBtn_clicked, previousVC = UpdateRecipeVC")
            updateIngredient()
        default:
            print("actionBtn_clicked, previousVC = default")
        }
        
    }
    
    @IBAction func cancelBtn_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    // MARK: - navigation
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
