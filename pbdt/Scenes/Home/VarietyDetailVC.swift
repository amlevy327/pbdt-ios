//
//  VarietyDetailVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/19/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class VarietyDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    // MARK: - objects and vars
    
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dividerView: UIView!
    
    var foodsFiltered: [Food]! = []
    var varietySelected: String = ""
    var numberServings: Double = 0.0
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        //loadFilteredFoods()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFilteredFoods()
        setupNavigationBar()
        setupViews()
        setupLabels()
        setupTableView()
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        foodsFiltered = []
    }
    
    // setups
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.mainViewBackground()
        dividerView.backgroundColor = UIColor.viewDivider()
    }
    
    func setupLabels() {
        
        detailLbl.backgroundColor = UIColor.viewBackground()
        detailLbl.textColor = UIColor.brandPrimary()
        detailLbl.font = UIFont.large()
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        let nib = UINib(nibName: "UpdateDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpdateDiaryEntryCell")
        
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationBar() {
        
        navigationItem.title = "\(varietySelected.capitalized)"
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func setupNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFoodModification), name: NSNotification.Name("FoodModification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterDateChange), name: NSNotification.Name("DateChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterUserGoalsModification), name: NSNotification.Name("UserGoalsModification"), object: nil)
    }
    
    // updates
    
    func updateLabels() {
        
        print("updateLabels - VarietyDetailVC")
        
        switch varietySelected {
        case "calories":
            print("calories")
            if numberServings == 1 {
                detailLbl.text = "\(numberServings.roundToPlaces(places: 1)) calorie"
            } else {
                detailLbl.text = "\(numberServings.roundToPlaces(places: 1)) calories"
            }
            
            if numberServings.isInt() {
                if numberServings == 1 {
                    detailLbl.text = "\(Int(numberServings)) calorie"
                } else {
                    detailLbl.text = "\(Int(numberServings)) calories"
                }
            }
        case "fat", "carbs", "protein":
            print("fat, carbs, protein")
            if numberServings == 1 {
                detailLbl.text = "\(numberServings.roundToPlaces(places: 1)) gram"
            } else {
                detailLbl.text = "\(numberServings.roundToPlaces(places: 1)) grams"
            }
            
            if numberServings.isInt() {
                if numberServings == 1 {
                    detailLbl.text = "\(Int(numberServings)) gram"
                } else {
                    detailLbl.text = "\(Int(numberServings)) grams"
                }
            }
        default:
            print("d")
            if numberServings == 1 {
                detailLbl.text = "\(numberServings.roundToPlaces(places: 1)) serving"
            } else {
                detailLbl.text = "\(numberServings.roundToPlaces(places: 1)) servings"
            }
            
            if numberServings.isInt() {
                if numberServings == 1 {
                    detailLbl.text = "\(Int(numberServings)) serving"
                } else {
                    detailLbl.text = "\(Int(numberServings)) servings"
                }
            }
        }
    }
    
    @objc func updateAfterDateChange() {
        //print("updateAfterDateChange: start")
        
        self.loadFilteredFoods()
    }
    
    @objc func updateAfterUserGoalsModification() {
        //print("updateAfterUserGoalsModification")
        goToNavigationRoot()
    }
    
    @objc func updateAfterFoodModification() {
        print("updateAfterFoodModification - VarietyDetailVC")
        loadFilteredFoods()
    }
    
    // get foods
    
    func loadFilteredFoods() {
        
        let date = appDelegate.dateFilter.toString(format: "yyyy-MM-dd")
        
        //print("date: \(date)")
        //print("varietySelected: \(varietySelected)")
        
        let foodFetch: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
        
        foodFetch.predicate = NSPredicate(format: "logDate = %@", "\(date)")
        
        let sectionSortDescriptions = NSSortDescriptor(key: "updatedAt", ascending: false)
        let sortDescripters = [sectionSortDescriptions]
        foodFetch.sortDescriptors = sortDescripters
        
        do {
            let fetchRequest = try context.fetch(foodFetch)
            
            self.numberServings = 0
            
            for food in fetchRequest {
                switch varietySelected {
                case "beans":
                    //print("beans")
                    if food.beansT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.beansT
                    }
                    self.foodsFiltered.sort(by: {$0.beansT > $1.beansT})
                case "berries":
                    //print("berries")
                    if food.berriesT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.berriesT
                    }
                    self.foodsFiltered.sort(by: {$0.berriesT > $1.berriesT})
                case "other fruits":
                    //print("other fruits")
                    if food.otherFruitsT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.otherFruitsT
                    }
                    self.foodsFiltered.sort(by: {$0.otherFruitsT > $1.otherFruitsT})
                case "cruciferous vegetables":
                    //print("cruciferous vegetables")
                    if food.cruciferousVegetablesT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.cruciferousVegetablesT
                    }
                    self.foodsFiltered.sort(by: {$0.cruciferousVegetablesT > $1.cruciferousVegetablesT})
                case "greens":
                    //print("greens")
                    if food.greensT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.greensT
                    }
                    self.foodsFiltered.sort(by: {$0.greensT > $1.greensT})
                case "other vegetables":
                    //print("other vegetables")
                    if food.otherVegetablesT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.otherVegetablesT
                    }
                    self.foodsFiltered.sort(by: {$0.otherVegetablesT > $1.otherVegetablesT})
                case "flaxseeds":
                    //print("flaxseeds")
                    if food.flaxseedsT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.flaxseedsT
                    }
                    self.foodsFiltered.sort(by: {$0.flaxseedsT > $1.flaxseedsT})
                case "nuts":
                    //print("nuts")
                    if food.nutsT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.nutsT
                    }
                    self.foodsFiltered.sort(by: {$0.nutsT > $1.nutsT})
                case "turmeric":
                    //print("turmeric")
                    if food.turmericT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.turmericT
                    }
                    self.foodsFiltered.sort(by: {$0.turmericT > $1.turmericT})
                case "whole grains":
                    //print("whole grains")
                    if food.wholeGrainsT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.wholeGrainsT
                    }
                    self.foodsFiltered.sort(by: {$0.wholeGrainsT > $1.wholeGrainsT})
                case "other seeds":
                    //print("other seeds")
                    if food.otherSeedsT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.otherSeedsT
                    }
                    self.foodsFiltered.sort(by: {$0.otherSeedsT > $1.otherSeedsT})
                case "calories":
                    //print("calories")
                    if food.calsT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.calsT
                    }
                    self.foodsFiltered.sort(by: {$0.calsT > $1.calsT})
                case "fat":
                    //print("fat")
                    if food.fatT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.fatT
                    }
                    self.foodsFiltered.sort(by: {$0.fatT > $1.fatT})
                case "carbs":
                    //print("carbs")
                    if food.carbsT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.carbsT
                    }
                    self.foodsFiltered.sort(by: {$0.carbsT > $1.carbsT})
                case "protein":
                    //print("protein")
                    if food.proteinT > 0.0 {
                        self.foodsFiltered.append(food)
                        self.numberServings += food.proteinT
                    }
                    self.foodsFiltered.sort(by: {$0.proteinT > $1.proteinT})
                default:
                    print("d")
                }
            }
            
            //self.numberServings = foodsFiltered
            
            self.tableView.reloadData()
        } catch {
            print("Error fetching filtered foods: \(error)")
        }
        
        //print("foodsFiltered.count: \(foodsFiltered.count)")
        
        updateLabels()
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateDiaryEntryCell", for: indexPath) as! UpdateDiaryEntryCell
        
        let food = foodsFiltered[indexPath.row]
        
        cell.nameLbl.text = food.name
        
        switch varietySelected {
        case "beans":
            //print("beans")
            cell.amountLbl.text = "\(food.beansT.roundToPlaces(places: 1))"
            if food.beansT.isInt() {
                cell.amountLbl.text = "\(Int(food.beansT))"
            }
        case "berries":
            //print("berries")
            cell.amountLbl.text = "\(food.berriesT.roundToPlaces(places: 1))"
            if food.berriesT.isInt() {
                cell.amountLbl.text = "\(Int(food.berriesT))"
            }
        case "other fruits":
            //print("other fruits")
            cell.amountLbl.text = "\(food.otherFruitsT.roundToPlaces(places: 1))"
            if food.otherFruitsT.isInt() {
                cell.amountLbl.text = "\(Int(food.otherFruitsT))"
            }
        case "cruciferous vegetables":
            //print("cruciferous vegetables")
            cell.amountLbl.text = "\(food.cruciferousVegetablesT.roundToPlaces(places: 1))"
            if food.cruciferousVegetablesT.isInt() {
                cell.amountLbl.text = "\(Int(food.cruciferousVegetablesT))"
            }
        case "greens":
            //print("greens")
            cell.amountLbl.text = "\(food.greensT.roundToPlaces(places: 1))"
            if food.greensT.isInt() {
                cell.amountLbl.text = "\(Int(food.greensT))"
            }
        case "other vegetables":
            //print("other vegetables")
            cell.amountLbl.text = "\(food.otherVegetablesT.roundToPlaces(places: 1))"
            if food.otherVegetablesT.isInt() {
                cell.amountLbl.text = "\(Int(food.otherVegetablesT))"
            }
        case "flaxseeds":
            //print("flaxseeds")
            cell.amountLbl.text = "\(food.flaxseedsT.roundToPlaces(places: 1))"
            if food.flaxseedsT.isInt() {
                cell.amountLbl.text = "\(Int(food.flaxseedsT))"
            }
        case "nuts":
            //print("nuts")
            cell.amountLbl.text = "\(food.nutsT.roundToPlaces(places: 1))"
            if food.nutsT.isInt() {
                cell.amountLbl.text = "\(Int(food.nutsT))"
            }
        case "turmeric":
            //print("berries")
            cell.amountLbl.text = "\(food.turmericT.roundToPlaces(places: 1))"
            if food.turmericT.isInt() {
                cell.amountLbl.text = "\(Int(food.turmericT))"
            }
        case "whole grains":
            //print("whole grains")
            cell.amountLbl.text = "\(food.wholeGrainsT.roundToPlaces(places: 1))"
            if food.wholeGrainsT.isInt() {
                cell.amountLbl.text = "\(Int(food.wholeGrainsT))"
            }
        case "other seeds":
            //print("other seeds")
            cell.amountLbl.text = "\(food.otherSeedsT.roundToPlaces(places: 1))"
            if food.otherSeedsT.isInt() {
                cell.amountLbl.text = "\(Int(food.otherSeedsT))"
            }
        case "calories":
            //print("calories")
            cell.amountLbl.text = "\(food.calsT.roundToPlaces(places: 1))"
            if food.calsT.isInt() {
                cell.amountLbl.text = "\(Int(food.calsT))"
            }
        case "fat":
            //print("fat")
            cell.amountLbl.text = "\(food.fatT.roundToPlaces(places: 1))"
            if food.fatT.isInt() {
                cell.amountLbl.text = "\(Int(food.fatT))"
            }
        case "carbs":
            //print("carbs")
            cell.amountLbl.text = "\(food.carbsT.roundToPlaces(places: 1))"
            if food.carbsT.isInt() {
                cell.amountLbl.text = "\(Int(food.carbsT))"
            }
        case "protein":
            //print("protein")
            cell.amountLbl.text = "\(food.proteinT.roundToPlaces(places: 1))"
            if food.proteinT.isInt() {
                cell.amountLbl.text = "\(Int(food.proteinT))"
            }
        default:
            print("d")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let entry = foodsFiltered[indexPath.row]
        presentUpdateDiaryEntryVC(entry)
    }
    
    // empty data set
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return foodsFiltered.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "No \(varietySelected) logged"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetTitle(),
                          NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "\(varietySelected.capitalized) you log in your diary will appear here"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetDescription(),
                          NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let string = "Tap to learn about \(varietySelected)"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetDescription(),
                          NSAttributedString.Key.foregroundColor: UIColor.brandPrimary()]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        print("button tapped")
        goToFoodGroupDetailVC(foodGroupSelected: self.varietySelected.lowercased())
    }
    
    
    // MARK: - actions
    
    func goToFoodGroupDetailVC(foodGroupSelected: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FoodGroupDetailVC")  as! FoodGroupDetailVC
        vc.foodGroupSelected = foodGroupSelected
        vc.previousVC = "VarietyDetailVC"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentUpdateDiaryEntryVC(_ entry: Food) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDiaryEntryVC") as! UpdateDiaryEntryVC
        vc.entry = entry
        vc.previousVC = "VarietyDetailVC"
        print("entry variety: \(entry.variety)")
        switch entry.variety {
        case "recipe":
            vc.updateType = "recipe"
        default:
            vc.updateType = "item"
        }
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
