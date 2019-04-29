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

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - objects and vars
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var navDateView = DateView()
    
    var namesServings: [String]!
    var amountsServings: [Double]!
    var goalsServings: [Double]!
    var namesMacros: [String]!
    var amountsMacros: [Double]!
    var goalsMacros: [Double]!
    
    var itemsPerRow = CGFloat(0)
    var sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    
    var varietySelected: String = ""
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setInitialValues()
        setupCollectionView()
        setupNotfications()
        setupNavigationBar()
    }
    
    // setups
    
    func setInitialValues() {
        
        namesServings = StaticLists.servingsNameArray
        namesMacros = StaticLists.macrosNameArray
        
        updateSummary()
    }
    
    func setupNavigationBar() {
        
        navDateView.view.backgroundColor = .clear
        navDateView.dateLbl.textColor = UIColor.brandWhite()
        navDateView.dateLbl.font = UIFont.navigationTitle()
        
        //navDateView.dateLbl.text = "Today"
        navDateView.updateAfterDateChange()
        
        navDateView.parentVc = "HomeVC"
        navDateView.homeVc = self
        
        navigationItem.titleView = navDateView
    }
    
    func setupViews() {
        
        view.backgroundColor = UIColor.mainViewBackground()
        
        segmentedControlView.parentVc = "HomeVC"
        segmentedControlView.homeVc = self
    }
    
    func setupCollectionView() {
        
        collectionView.backgroundColor = UIColor.viewBackground()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "HomeCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionCell")
        appDelegate.loadFoods()
    }
    
    func setupNotfications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterDateChange), name: NSNotification.Name("DateChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFoodModification), name: NSNotification.Name("FoodModification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterUserGoalsModification), name: NSNotification.Name("UserGoalsModification"), object: nil)
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
        
        goalsServings = [
            appDelegate.currentUser.beansG,
            appDelegate.currentUser.berriesG,
            appDelegate.currentUser.otherFruitsG,
            appDelegate.currentUser.cruciferousVegetablesG,
            appDelegate.currentUser.greensG,
            appDelegate.currentUser.otherVegetablesG,
            appDelegate.currentUser.flaxseedsG,
            appDelegate.currentUser.nutsG,
            appDelegate.currentUser.turmericG,
            appDelegate.currentUser.wholeGrainsG,
            appDelegate.currentUser.otherSeedsG
        ]
        
        goalsMacros = [
            appDelegate.currentUser.calsG,
            appDelegate.currentUser.fatG,
            appDelegate.currentUser.carbsG,
            appDelegate.currentUser.proteinG
        ]
        
        collectionView.reloadData()
    }
    
    // updates
    
    @objc func updateAfterFoodModification() {
        
        print("updateAfterFoodModification")
        appDelegate.loadFoods()
        updateSummary()
    }
    
    @objc func updateAfterUserGoalsModification() {
        
        print("updateAfterUserGoalsModification")
        updateSummary()
    }
    
    // collection view
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        
        switch self.segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            
            let amountServings = amountsServings[indexPath.row]
            let goalServings = goalsServings[indexPath.row]
            
            let name = namesServings[indexPath.row]
            cell.nameLbl.text = name
            
            cell.amountLbl.text = "\(amountServings)"
            if appDelegate.checkIfInt(input: amountServings) {
                cell.amountLbl.text = "\(Int(amountServings))"
            }
            
            cell.goalLbl.text = "\(goalServings)"
            if appDelegate.checkIfInt(input: goalServings) {
                cell.goalLbl.text = "of \(Int(goalServings))"
            }
            
            // attributes
            
            if amountServings >= goalServings {
                cell.backgroundColor = UIColor.success()
            } else {
                cell.backgroundColor = UIColor.failure()
            }
            
//            cell.nameLbl.font = UIFont.homeCellServingsName()
//            cell.amountLbl.font = UIFont.homeCellServingsAmount()
//            cell.goalLbl.font = UIFont.homeCellServingsGoal()
            //cell.goalLbl.isHidden = false
            //cell.isUserInteractionEnabled = true
            
            
            
        case 1:
            
            let amountMacros = amountsMacros[indexPath.row]
            let goalMacros = goalsMacros[indexPath.row]
            
            let name = namesMacros[indexPath.row]
            cell.nameLbl.text = name
            
            cell.amountLbl.text = "\(amountMacros)"
            if appDelegate.checkIfInt(input: amountMacros) {
                cell.amountLbl.text = "\(Int(amountMacros))"
            }
            
            cell.goalLbl.text = "\(goalMacros)"
            if appDelegate.checkIfInt(input: goalMacros) {
                cell.goalLbl.text = "of \(Int(goalMacros))"
            }
            
            // attributes
            
            if amountMacros >= goalMacros {
                cell.backgroundColor = UIColor.success()
            } else {
                cell.backgroundColor = UIColor.failure()
            }
            
            
//            cell.nameLbl.font = UIFont.homeCellMacrosName()
//            cell.amountLbl.font = UIFont.homeCellMacrosAmount()
//            cell.goalLbl.font = UIFont.homeCellMacrosGoal()
            //cell.goalLbl.isHidden = true
            //cell.isUserInteractionEnabled = false
            
        default:
            print("d")
        }
        
        // cell attributes
        cell.nameLbl.font = UIFont.homeCellName()
        cell.amountLbl.font = UIFont.homeCellAmount()
        cell.goalLbl.font = UIFont.homeCellGoal()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        
        switch self.segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            varietySelected = namesServings[indexPath.row].lowercased()
        case 1:
            varietySelected = namesMacros[indexPath.row].lowercased()
        default:
            print("d")
        }
        
        self.performSegue(withIdentifier: "toVarietyDetailVC", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            self.itemsPerRow = 3.0
        case 1:
            self.itemsPerRow = 3.0
        default:
            print("d")
            self.itemsPerRow = 0.0
        }
        
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + 4
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem
        
        //let widthPerItem = CGFloat(127)
        //let heightPerItem = widthPerItem
        
//        print("itemsPerRow: \(itemsPerRow)")
//        print("paddingSpace: \(paddingSpace)")
//        print("availableWidth: \(availableWidth)")
//        print("widthPerItem: \(widthPerItem)")
//        print("heightPerItem: \(heightPerItem)")
        
        
        /*
        let widthPerItem = collectionView.bounds.width / itemsPerRow
        let heightPerItem = widthPerItem
        
        print("collectionView.bounds.width: \(collectionView.bounds.width)")
        print("widthPerItem: \(widthPerItem)")
        
        */
        
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    // updates
    
    @objc func updateAfterDateChange() {
        
        //print("updateAfterDateChange")
        //dateView.updateAfterDateChange()
        
        navDateView.updateAfterDateChange()
        updateSummary()
    }
    
    
    // MARK: - actions
    
    @IBAction func check2Btn_clicked(_ sender: Any) {
        
        print("clicked - check")
        
        
        do {
            let fetch: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
            //let fetch: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let fetchCheck = try context.fetch(fetch)
            print("fetchCheck.count = \(fetchCheck.count)")
        } catch {
            print("error")
        }
        
    }
    
    @IBAction func checkBtn_clicked(_ sender: Any) {
        
        print("clicked - delete")
        
        //appDelegate.showInfoView(action: "added", response: "failure")
        
        /*
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        //let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print ("Error deleting")
        }
        */
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    // MARK: - navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // segue
        if segue.identifier == "toVarietyDetailVC", let destination = segue.destination as? VarietyDetailVC {
            
            destination.varietySelected = self.varietySelected
        }
    }
    
}
