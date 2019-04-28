//
//  VarietyDetailVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/19/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData

class VarietyDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - objects and vars
    
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var foodsFiltered: [Food]! = []
    var varietySelected: String = ""
    
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
        setupNotfications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        foodsFiltered = []
    }
    
    // setups
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.mainViewBackground()
    }
    
    func setupLabels() {
        
        detailLbl.backgroundColor = UIColor.viewBackground()
        detailLbl.textColor = UIColor.brandBlack()
        detailLbl.font = UIFont.large()
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "UpdateDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpdateDiaryEntryCell")
        
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationBar() {
        
        self.navigationItem.title = "\(varietySelected.capitalized)"
        //self.navigationItem.titleView = DateView()
    }
    
    func setupNotfications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterDateChange), name: NSNotification.Name("DateChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterUserGoalsModification), name: NSNotification.Name("UserGoalsModification"), object: nil)
    }
    
    // updates
    
    func updateLabels() {
        
        var foodNames: [String] = []
        for food in foodsFiltered {
            if !foodNames.contains(food.name!) {
                foodNames.append(food.name!)
            }
        }
        
        var foodString = "foods"
        var typeString = "types"
        
        if foodsFiltered.count == 1 {
            foodString = "food"
        }
        
        if foodNames.count == 1 {
            typeString = "type"
        }
        
        //detailLbl.text = "\(foodsFiltered.count) \(varietySelected)\nlogged on \(appDelegate.dateFilter.toString(format: "MMM dd, yyyy"))"
        
        //detailLbl.text = "\(foodsFiltered.count) foods containing \(varietySelected) logged on \(appDelegate.dateFilter.toString(format: "MMM dd, yyyy")), \n\(foodNames.count) unique types of \(varietySelected)"
        
        detailLbl.text = "\(foodsFiltered.count) total \(foodString), \(foodNames.count) unique \(typeString)"
    }
    
    @objc func updateAfterDateChange() {
        //print("updateAfterDateChange: start")
        
        self.loadFilteredFoods()
    }
    
    @objc func updateAfterUserGoalsModification() {
        //print("updateAfterUserGoalsModification")
        goToNavigationRoot()
    }
    
    // get foods
    
    func loadFilteredFoods() {
        
        let date = appDelegate.dateFilter.toString(format: "yyyy-MM-dd")
        
        //print("date: \(date)")
        //print("varietySelected: \(varietySelected)")
        
        let foodFetch: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
        foodFetch.predicate = NSPredicate(format: "logDate = %@", "\(date)")
        
        do {
            let fetchRequest = try context.fetch(foodFetch)
            
            for food in fetchRequest {
                switch varietySelected {
                case "beans":
                    //print("beans")
                    if food.beansT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "berries":
                    //print("berries")
                    if food.berriesT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "other fruits":
                    //print("other fruits")
                    if food.otherFruitsT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "cruciferous vegetables":
                    //print("cruciferous vegetables")
                    if food.cruciferousVegetablesT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "greens":
                    //print("greens")
                    if food.greensT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "other vegetables":
                    //print("other vegetables")
                    if food.otherVegetablesT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "flaxseeds":
                    //print("flaxseeds")
                    if food.flaxseedsT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "nuts":
                    //print("nuts")
                    if food.nutsT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "turmeric":
                    //print("turmeric")
                    if food.turmericT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "whole grains":
                    //print("whole grains")
                    if food.wholeGrainsT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "other seeds":
                    //print("other seeds")
                    if food.otherSeedsT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "calories":
                    //print("calories")
                    if food.calsT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "fat":
                    //print("fat")
                    if food.fatT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "carbs":
                    //print("carbs")
                    if food.carbsT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                case "protein":
                    //print("protein")
                    if food.proteinT > 0.0 {
                        self.foodsFiltered.append(food)
                    }
                default:
                    print("d")
                }
            }
            
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateDiaryEntryCell", for: indexPath) as! UpdateDiaryEntryCell
        
        let food = foodsFiltered[indexPath.row]
        
        cell.nameLbl.text = "\(food.name!.capitalized)"
        
        switch varietySelected {
        case "beans":
            //print("beans")
            cell.amountLbl.text = "\(food.beansT)"
            if appDelegate.checkIfInt(input: food.beansT) {
                cell.amountLbl.text = "\(Int(food.beansT))"
            }
        case "berries":
            //print("berries")
            cell.amountLbl.text = "\(food.berriesT)"
            if appDelegate.checkIfInt(input: food.berriesT) {
                cell.amountLbl.text = "\(Int(food.berriesT))"
            }
        case "other fruits":
            //print("other fruits")
            cell.amountLbl.text = "\(food.otherFruitsT)"
            if appDelegate.checkIfInt(input: food.otherFruitsT) {
                cell.amountLbl.text = "\(Int(food.otherFruitsT))"
            }
        case "cruciferous vegetables":
            //print("cruciferous vegetables")
            cell.amountLbl.text = "\(food.cruciferousVegetablesT)"
            if appDelegate.checkIfInt(input: food.cruciferousVegetablesT) {
                cell.amountLbl.text = "\(Int(food.cruciferousVegetablesT))"
            }
        case "greens":
            //print("greens")
            cell.amountLbl.text = "\(food.greensT)"
            if appDelegate.checkIfInt(input: food.greensT) {
                cell.amountLbl.text = "\(Int(food.greensT))"
            }
        case "other vegetables":
            //print("other vegetables")
            cell.amountLbl.text = "\(food.otherVegetablesT)"
            if appDelegate.checkIfInt(input: food.otherVegetablesT) {
                cell.amountLbl.text = "\(Int(food.otherVegetablesT))"
            }
        case "flaxseeds":
            //print("flaxseeds")
            cell.amountLbl.text = "\(food.flaxseedsT)"
            if appDelegate.checkIfInt(input: food.flaxseedsT) {
                cell.amountLbl.text = "\(Int(food.flaxseedsT))"
            }
        case "nuts":
            //print("nuts")
            cell.amountLbl.text = "\(food.nutsT)"
            if appDelegate.checkIfInt(input: food.nutsT) {
                cell.amountLbl.text = "\(Int(food.nutsT))"
            }
        case "turmeric":
            //print("berries")
            cell.amountLbl.text = "\(food.turmericT)"
            if appDelegate.checkIfInt(input: food.turmericT) {
                cell.amountLbl.text = "\(Int(food.turmericT))"
            }
        case "whole grains":
            //print("whole grains")
            cell.amountLbl.text = "\(food.wholeGrainsT)"
            if appDelegate.checkIfInt(input: food.wholeGrainsT) {
                cell.amountLbl.text = "\(Int(food.wholeGrainsT))"
            }
        case "other seeds":
            //print("other seeds")
            cell.amountLbl.text = "\(food.otherSeedsT)"
            if appDelegate.checkIfInt(input: food.otherSeedsT) {
                cell.amountLbl.text = "\(Int(food.otherSeedsT))"
            }
        case "calories":
            //print("calories")
            cell.amountLbl.text = "\(food.calsT)"
            if appDelegate.checkIfInt(input: food.calsT) {
                cell.amountLbl.text = "\(Int(food.calsT))"
            }
        case "fat":
            //print("fat")
            cell.amountLbl.text = "\(food.fatT)"
            if appDelegate.checkIfInt(input: food.fatT) {
                cell.amountLbl.text = "\(Int(food.fatT))"
            }
        case "carbs":
            //print("carbs")
            cell.amountLbl.text = "\(food.carbsT)"
            if appDelegate.checkIfInt(input: food.carbsT) {
                cell.amountLbl.text = "\(Int(food.carbsT))"
            }
        case "protein":
            //print("protein")
            cell.amountLbl.text = "\(food.proteinT)"
            if appDelegate.checkIfInt(input: food.proteinT) {
                cell.amountLbl.text = "\(Int(food.proteinT))"
            }
        default:
            print("d")
        }
        
        return cell
    }
    
    // MARK: - actions
    
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
