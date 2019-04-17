//
//  HomeVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/2/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import Segmentio

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - objects and vars
    
    @IBOutlet weak var dateView: DateView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    
    var namesServings: [String]!
    var amountsServings: [Double]!
    var goalsServings: [Double]!
    var namesMacros: [String]!
    var amountsMacros: [Double]!
    var goalsMacros: [Double]!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setInitialValues()
        setupTableView()
        setupNotfications()
    }
    
    // setups
    
    func setInitialValues() {
        
        namesServings = StaticLists.servingsNameArray
        namesMacros = StaticLists.macrosNameArray
        
        updateSummary()
    }
    
    func setupViews() {
        
        view.backgroundColor = .green
        
        dateView.parentVc = "HomeVC"
        dateView.homeVc = self
        
        segmentedControlView.parentVc = "HomeVC"
        segmentedControlView.homeVc = self
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeCell")
        tableView.tableFooterView = UIView()
        dateView.loadFoods()
    }
    
    // updates
    
    func updateSummary() {
        
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
        
        for entry in appDelegate.diaryEntries {
            sumBeans += entry.beansT
        }
        
        for entry in appDelegate.diaryEntries {
            sumBerries += entry.berriesT
        }
        
        for entry in appDelegate.diaryEntries {
            sumOtherFruits += entry.otherFruitsT
        }
        
        for entry in appDelegate.diaryEntries {
            sumCruciferousVegetables += entry.cruciferousVegetablesT
        }
        
        for entry in appDelegate.diaryEntries {
            sumGreens += entry.greensT
        }
        
        for entry in appDelegate.diaryEntries {
            sumOtherVegetables += entry.otherVegetablesT
        }
        
        for entry in appDelegate.diaryEntries {
            sumFlaxseeds += entry.flaxseedsT
        }
        
        for entry in appDelegate.diaryEntries {
            sumNuts += entry.nutsT
        }
        
        for entry in appDelegate.diaryEntries {
            sumTurmeric += entry.turmericT
        }
        
        for entry in appDelegate.diaryEntries {
            sumWholeGrains += entry.wholeGrainsT
        }
        
        for entry in appDelegate.diaryEntries {
            sumOtherSeeds += entry.otherSeedsT
        }
        
        for entry in appDelegate.diaryEntries {
            sumCals += entry.calsT
        }
        
        for entry in appDelegate.diaryEntries {
            sumFat += entry.fatT
        }
        
        for entry in appDelegate.diaryEntries {
            sumCarbs += entry.carbsT
        }
        
        for entry in appDelegate.diaryEntries {
            sumProtein += entry.proteinT
        }
        
        amountsServings = [
            sumBeans,
            sumBerries,
            sumOtherFruits,
            sumCruciferousVegetables,
            sumGreens,
            sumOtherVegetables,
            sumFlaxseeds,
            sumNuts,
            sumTurmeric,
            sumWholeGrains,
            sumOtherSeeds
        ]
        
        amountsMacros = [
            sumCals,
            sumFat,
            sumCarbs,
            sumProtein
        ]
        
        let goalBeans = UserDefaults.standard.double(forKey: "beans")
        let goalBerries = UserDefaults.standard.double(forKey: "berries")
        let goalOtherFruits = UserDefaults.standard.double(forKey: "otherFruits")
        let goalCruciferousVegetables = UserDefaults.standard.double(forKey: "cruciferousVegetables")
        let goalGreens = UserDefaults.standard.double(forKey: "greens")
        let goalOtherVegetables = UserDefaults.standard.double(forKey: "otherVegetables")
        let goalFlaxseeds = UserDefaults.standard.double(forKey: "flaxseeds")
        let goalNuts = UserDefaults.standard.double(forKey: "nuts")
        let goalTurmeric = UserDefaults.standard.double(forKey: "turmeric")
        let goalWholeGrains = UserDefaults.standard.double(forKey: "wholeGrains")
        let goalOtherSeeds = UserDefaults.standard.double(forKey: "otherSeeds")
        
        let goalCals = UserDefaults.standard.double(forKey: "cals")
        let goalFat = UserDefaults.standard.double(forKey: "fat")
        let goalCarbs = UserDefaults.standard.double(forKey: "carbs")
        let goalProtein = UserDefaults.standard.double(forKey: "protein")
        
        goalsServings = [
            goalBeans,
            goalBerries,
            goalOtherFruits,
            goalCruciferousVegetables,
            goalGreens,
            goalOtherVegetables,
            goalFlaxseeds,
            goalNuts,
            goalTurmeric,
            goalWholeGrains,
            goalOtherSeeds
        ]
        
        goalsMacros = [
            goalCals,
            goalFat,
            goalCarbs,
            goalProtein
        ]
        
        tableView.reloadData()
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let amountServings = amountsServings[indexPath.row]
        let goalServings = goalsServings[indexPath.row]
        
        switch self.segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            let name = namesServings[indexPath.row]
            cell.nameLbl.text = name
            cell.amountLbl.text = "\(amountServings) of \(goalServings)"
        case 1:
            let name = namesMacros[indexPath.row]
            cell.nameLbl.text = name
            cell.amountLbl.text = "\(amountsMacros[indexPath.row])"
        default:
            print("d")
        }
        
        if amountServings >= goalServings {
            cell.nameLbl.textColor = .green
            cell.amountLbl.textColor = .green
        } else {
            cell.nameLbl.textColor = .red
            cell.amountLbl.textColor = .red
        }
        
        return cell
    }
    
    func setupNotfications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterDateChange), name: NSNotification.Name("DateChanged"), object: nil)
    }
    
    // updates
    
    @objc func updateAfterDateChange() {
        
        print("updateAfterDateChange")
        dateView.updateAfterDateChange()
    }
    
    // MARK: - actions
    
    @IBAction func check2Btn_clicked(_ sender: Any) {
        
        print("clicked - check")
        
        do {
            let fetch: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
            //let fetch: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let fetchCheck = try context.fetch(fetch)
            print("fetchCheck.count = \(fetchCheck.count)")
        } catch {
            print("error")
        }
    }
    
    @IBAction func checkBtn_clicked(_ sender: Any) {
        
        print("clicked - delete")
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        //let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print ("Error deleting")
        }

    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
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
