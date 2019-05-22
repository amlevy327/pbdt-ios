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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var navDateView = DateView()
    
    var selectedSegmentedControlIndex: Int = 0
    
    var namesServings: [String]!
    var amountsServings: [Double]!
    var goalsServings: [Double]!
    var namesMacros: [String]!
    var amountsMacros: [Double]!
    var goalsMacros: [Double]!
    
    var itemsPerRow = CGFloat(0)
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
    }
    
    func setupCollectionView() {
        
        collectionView.backgroundColor = UIColor.viewBackground()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibView = UINib(nibName: "SegmentedControlHeaderView", bundle: nil)
        collectionView.register(nibView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SegmentedControlHeaderView")
        
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "HomeCell")
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        collectionView.contentInset = insets
        
        appDelegate.loadFoods()
    }
    
    func setupNotfications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterDateChange), name: NSNotification.Name("DateChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFoodModification), name: NSNotification.Name("FoodModification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterUserGoalsModification), name: NSNotification.Name("UserGoalsModification"), object: nil)
    }
    
    // updates
    
    func updateSummary() {
        
        //amountsServings = []
        //print("amountsServings: \(amountsServings)")
        //collectionView.reloadData()
        
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
        
        //print("amountsServings: \(amountsServings)")
        
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
        switch selectedSegmentedControlIndex {
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
        
        cell.circularProgressRing.resetProgress()
        
        var amount: Double = 0.0
        var goal: Double = 0.0
        var streak: Int = 0
        
        switch selectedSegmentedControlIndex {
        case 0:
            
            let name = namesServings[indexPath.row]
            cell.nameLbl.text = name
            
            amount = amountsServings[indexPath.row].roundToPlaces(places: 1)
            goal = goalsServings[indexPath.row].roundToPlaces(places: 1)
            //print("\(name): amount=\(amount), goal=\(goal)")
            
            var streakAmount = amount
            var streakDate = appDelegate.dateFilter
            
            if goal > 0 {
                while streakAmount >= goal {
                    streakAmount = 0
                    let streakDateString = streakDate?.toString(format: "yyyy-MM-dd")
                    let foodFetch: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
                    foodFetch.predicate = NSPredicate(format: "logDate = %@", "\(streakDateString!)")
                    do {
                        let fetchRequest = try context.fetch(foodFetch)
                        print("fetchRequest.count: \(fetchRequest.count)")
                        for food in fetchRequest {
                            
                            switch name.lowercased() {
                            case "beans":
                                //print("beans")
                                streakAmount += food.beansT
                            case "berries":
                                //print("berries")
                                streakAmount += food.berriesT
                            case "other fruits":
                                //print("other fruits")
                                streakAmount += food.otherFruitsT
                            case "cruciferous vegetables":
                                //print("cruciferous vegetables")
                                streakAmount += food.cruciferousVegetablesT
                            case "greens":
                                //print("greens")
                                streakAmount += food.greensT
                            case "other vegetables":
                                //print("other vegetables")
                                streakAmount += food.otherVegetablesT
                            case "flaxseeds":
                                //print("flaxseeds")
                                streakAmount += food.flaxseedsT
                            case "nuts":
                                //print("nuts")
                                streakAmount += food.nutsT
                            case "turmeric":
                                //print("turmeric")
                                streakAmount += food.turmericT
                            case "whole grains":
                                //print("whole grains")
                                streakAmount += food.wholeGrainsT
                            case "other seeds":
                                //print("other seeds")
                                streakAmount += food.otherSeedsT
                            default:
                                print("d")
                            }
                        }
                        if streakAmount >= goal {
                            streak += 1
                        }
                        streakDate = Calendar.current.date(byAdding: .day, value: -1, to: streakDate!)
                    } catch {
                        print("Error fetching foods for streak: \(error)")
                    }
                    //print("date is \(streakDate): streakAmount is \(streakAmount), goal is \(goal), streak is \(streak)")
                }
            }
        case 1:
            
            let name = namesMacros[indexPath.row]
            cell.nameLbl.text = name
            
            amount = amountsMacros[indexPath.row].roundToPlaces(places: 1)
            goal = goalsMacros[indexPath.row].roundToPlaces(places: 1)
            //print("\(name): amount=\(amount), goal=\(goal)")
            
            var streakAmount = amount
            var streakDate = appDelegate.dateFilter
            
            if goal > 0 {
                while streakAmount >= goal {
                    streakAmount = 0
                    let streakDateString = streakDate?.toString(format: "yyyy-MM-dd")
                    let foodFetch: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
                    foodFetch.predicate = NSPredicate(format: "logDate = %@", "\(streakDateString!)")
                    do {
                        let fetchRequest = try context.fetch(foodFetch)
                        print("fetchRequest.count: \(fetchRequest.count)")
                        for food in fetchRequest {
                            
                            switch name.lowercased() {
                            case "calories":
                                //print("calories")
                                streakAmount += food.calsT
                            case "fat":
                                //print("fat")
                                streakAmount += food.fatT
                            case "carbs":
                                //print("carbs")
                                streakAmount += food.carbsT
                            case "protein":
                                //print("protein")
                                streakAmount += food.proteinT
                            default:
                                print("d")
                            }
                        }
                        if streakAmount >= goal {
                            streak += 1
                        }
                        streakDate = Calendar.current.date(byAdding: .day, value: -1, to: streakDate!)
                    } catch {
                        print("Error fetching foods for streak: \(error)")
                    }
                    //print("date is \(streakDate): streakAmount is \(streakAmount), goal is \(goal), streak is \(streak)")
                }
            }
        default:
            print("d")
        }
        
        let attributedText = NSMutableAttributedString()
        var attributedAmount = NSAttributedString()
        var attributedGoal = NSAttributedString()
        var attributedStreak = NSAttributedString()
        
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
        
        if streak == 1 {
            attributedStreak = NSAttributedString(string: "\n\(Int(streak)) day", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.red])
        } else {
            attributedStreak = NSAttributedString(string: "\n\(Int(streak)) days", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.red])
        }
        
        attributedText.append(attributedAmount)
        attributedText.append(attributedGoal)
        if streak > 1  {
            attributedText.append(attributedStreak)
        }
        cell.amountLbl.attributedText = attributedText
        
        cell.streakLbl.isHidden = true
        /*
        if streak > 0  {
            cell.streakLbl.isHidden = false
            cell.streakLbl.text = "\(streak) days"
        } else {
            cell.streakLbl.isHidden = true
        }
        */
        
        //cell.circularProgressRing.maxValue = CGFloat(goal)
        //cell.circularProgressRing.value = CGFloat(amount)
        //cell.circularProgressRing.startProgress(to: CGFloat(amount), duration: 0.5)
        
        if amount == 0 && goal == 0 {
            print("amount == 0 && goal == 0")
            cell.circularProgressRing.maxValue = CGFloat(1)
            cell.circularProgressRing.value = CGFloat(2)
        } else if goal == 0 && (amount > goal) {
            print("goal == 0 && (amount > goal)")
            cell.circularProgressRing.maxValue = CGFloat(amount)
            cell.circularProgressRing.value = CGFloat(amount)
        } else {
            cell.circularProgressRing.maxValue = CGFloat(goal)
            cell.circularProgressRing.value = CGFloat(amount)
        }
        
        print("cellForItemAt: \(indexPath.row)")
        print("minValue: \(cell.circularProgressRing.minValue)")
        print("maxValue: \(cell.circularProgressRing.maxValue)")
        print("currentValue: \(cell.circularProgressRing.currentValue)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch selectedSegmentedControlIndex {
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
        
        self.itemsPerRow = 3.0
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + 4
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem + CGFloat(42)
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 66)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier:"SegmentedControlHeaderView", for: indexPath) as! SegmentedControlHeaderView
            
            headerView.segmentedControlView.parentVc = "HomeVC"
            headerView.segmentedControlView.homeVc = self
            
            return headerView
        } else {
            return UICollectionReusableView()
        }
        
        //return headerView
    }
    
    // updates
    
    @objc func updateAfterDateChange() {
        
        //print("updateAfterDateChange")
        
        navDateView.updateAfterDateChange()
        updateSummary()
    }
    
    
    // MARK: - actions
    
    
    // MARK: - navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // segue
        if segue.identifier == "toVarietyDetailVC", let destination = segue.destination as? VarietyDetailVC {
            
            destination.varietySelected = self.varietySelected
            //destination.numberServings = self.numberServings
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
    
}
