//
//  FoodGroupDetailVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 5/15/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData

class FoodGroupDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var dividerView: UIView!
    
    var foodGroupSelected: String!
    var items: [Item]!
    var previousVC: String!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
        setupViews()
        setupLabels()
        setupTableView()
        setupNavigationBar()
        setupNotifications()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        if let headerView = tableView.tableHeaderView {
//
//            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//            var headerFrame = headerView.frame
//
//            //Comparison necessary to avoid infinite loop
//            if height != headerFrame.size.height {
//                headerFrame.size.height = height
//                headerView.frame = headerFrame
//                tableView.tableHeaderView = headerView
//            }
//        }
//    }
    
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
        headerLbl.text = "One\nTwo"
        
        switch foodGroupSelected.lowercased() {
        case "beans":
            //print("beans")
            headerLbl.text = "0.25 cup hummus or bean dip\n0.5 cup cooked beans, split peas, lentils, tofu or tempeh\n1 cup fresh peas or sprouted lentils"
        case "berries":
            //print("berries")
            headerLbl.text = "0.5 cup fresh or frozen\n0.25 cup dried"
        case "other fruits":
            //print("other fruits")
            headerLbl.text = "1 medium-sized fruit\n1 cup cut-up fruit\n1/4 cup dried fruit"
        case "cruciferous vegetables":
            //print("cruciferous vegetables")
            headerLbl.text = "1/2 cup chopped\n0.25 cup brussels or broccoli sprouts\n1 tbsp horseradish"
        case "greens":
            //print("greens")
            headerLbl.text = "1 cup raw\n0.5 cup cooked"
        case "other vegetables":
            //print("other vegetables")
            headerLbl.text = "1 cup raw leafy vegetables\n0.5 cup raw or cooked nonleafy vegetables\n0.5 cup vegetable juice\n0.25 cup dried mushrooms"
        case "flaxseeds":
            //print("flaxseeds")
            headerLbl.text = "1 tbsp ground"
        case "nuts":
            //print("nuts")
            headerLbl.text = "0.25 cup nuts\n2 tbsp nut butter"
        case "turmeric":
            //print("berries")
            headerLbl.text = "0.25 tsp turmeric"
        case "whole grains":
            //print("whole grains")
            headerLbl.text = "0.5 cup hot cereal or cooked grains, pasta or corn kernels\n1 cup cold cereal\n1 tortilla or slice of bread\n0.5 bagel or english muffin"
        case "other seeds":
            //print("other seeds")
            headerLbl.text = "0.25 cup seeds\n2 tbsp seed butter"
        default:
            print("d")

        }
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "AddDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddDiaryEntryCell")
        
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationBar() {
        
        navigationItem.title = "\(foodGroupSelected.capitalized)"
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFoodModification), name: NSNotification.Name("FoodModification"), object: nil)
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
        
        //cell.isUserInteractionEnabled = false
        
        let item = items[indexPath.row]
        cell.nameLbl.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        presentItemUpdateDiaryEntryVC(item)
    }
    
    // MARK: - actions
    
    func fetchItems() {
        
        let itemFetch: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
        itemFetch.predicate = NSPredicate(format: "variety = %@", "\(self.foodGroupSelected.lowercased())")
        
        do {
            let fetchRequest = try context.fetch(itemFetch)
            self.items = fetchRequest
            self.items.sort(by: { $0.name!.compare($1.name! as String) == ComparisonResult.orderedAscending })
            tableView.reloadData()
        } catch {
            print("Error fetching items: \(error)")
        }
    }
    
    func presentItemUpdateDiaryEntryVC(_ item: Item) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDiaryEntryVC") as! UpdateDiaryEntryVC
        vc.item = item
        vc.addType = "item"
        vc.previousVC = "FoodGroupDetailVC"
        self.present(vc, animated: true)
    }
    
    @objc func updateAfterFoodModification() {
        print("updateAfterFoodModification - FoodGroupDetailVC")
        //print("previousVC: \(previousVC)")
        
        switch previousVC {
        case "FoodGroupsVC":
            self.tabBarController?.selectedIndex = 1
        case "VarietyDetailVC":
            self.popBack(toControllerType: VarietyDetailVC.self)
        default:
            print("d")
        }
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
    
    // MARK: - navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
