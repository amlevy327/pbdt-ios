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
import UICircularProgressRing

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
    //var sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    var sectionInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    
    var varietySelected: String = ""
    var numberServings: Double = 0.0
    
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
        
        //let nib = UINib(nibName: "HomeCollectionCell", bundle: nil)
        //collectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionCell")
        
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "HomeCell")
        
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
            sumBerries += entry.berriesT
            sumOtherFruits += entry.otherFruitsT
            sumCruciferousVegetables += entry.cruciferousVegetablesT
            sumGreens += entry.greensT
            sumOtherVegetables += entry.otherVegetablesT
            sumFlaxseeds += entry.flaxseedsT
            sumNuts += entry.nutsT
            sumTurmeric += entry.turmericT
            sumWholeGrains += entry.wholeGrainsT
            sumOtherSeeds += entry.otherSeedsT
            sumCals += entry.calsT
            sumFat += entry.fatT
            sumCarbs += entry.carbsT
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        var amount: Double = 0.0
        var goal: Double = 0.0
        
        switch self.segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            
            let name = namesServings[indexPath.row]
            cell.nameLbl.text = name
            
            amount = amountsServings[indexPath.row].roundToPlaces(places: 2)
            goal = goalsServings[indexPath.row].roundToPlaces(places: 2)
            
        case 1:
            
            let name = namesMacros[indexPath.row]
            cell.nameLbl.text = name
            
            amount = amountsMacros[indexPath.row].roundToPlaces(places: 2)
            goal = goalsMacros[indexPath.row].roundToPlaces(places: 2)
        default:
            print("d")
        }
        
        let attributedText = NSMutableAttributedString()
        var attributedAmount = NSAttributedString()
        var attributedGoal = NSAttributedString()
        
        if amount.isInt() && goal.isInt() {
            attributedAmount = NSAttributedString(string: "\(Int(amount))", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.brandPrimary()])
            attributedGoal = NSAttributedString(string: "\nof \(Int(goal))", attributes: [NSAttributedString.Key.font: UIFont.small(), NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()])
        } else if amount.isInt() && !goal.isInt() {
            attributedAmount = NSAttributedString(string: "\(Int(amount))", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.brandPrimary()])
            attributedGoal = NSAttributedString(string: "\nof \(goal)", attributes: [NSAttributedString.Key.font: UIFont.small(), NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()])
        } else if !amount.isInt() && goal.isInt() {
            attributedAmount = NSAttributedString(string: "\(amount)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.brandPrimary()])
            attributedGoal = NSAttributedString(string: "\nof \(Int(goal))", attributes: [NSAttributedString.Key.font: UIFont.small(), NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()])
        } else {
            attributedAmount = NSAttributedString(string: "\(amount)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.brandPrimary()])
            attributedGoal = NSAttributedString(string: "\nof \(goal)", attributes: [NSAttributedString.Key.font: UIFont.small(), NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()])
        }
        
        attributedText.append(attributedAmount)
        attributedText.append(attributedGoal)
        cell.amountLbl.attributedText = attributedText
        
        cell.circularProgressRing.maxValue = CGFloat(goal)
        cell.circularProgressRing.startProgress(to: CGFloat(amount), duration: 0.5)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        
        switch self.segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            varietySelected = namesServings[indexPath.row].lowercased()
            numberServings = amountsServings[indexPath.row]
        case 1:
            varietySelected = namesMacros[indexPath.row].lowercased()
            numberServings = amountsMacros[indexPath.row]
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
        //let heightPerItem = widthPerItem
        let heightPerItem = widthPerItem + CGFloat(42)
        
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
            let fetch: NSFetchRequest<Ingredient> = NSFetchRequest(entityName: "Ingredient")
            //let fetch: NSFetchRequest<Recipe> = NSFetchRequest(entityName: "Recipe")
            //let fetch: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
            //let fetch: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let fetchCheck = try context.fetch(fetch)
            print("fetchCheck.count = \(fetchCheck.count)")
            print("fetchCheck = \(fetchCheck)")
            let ingredientsCount = fetchCheck.count
            print("ingredients.count: \(ingredientsCount)")
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
            destination.numberServings = self.numberServings
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
    
}
