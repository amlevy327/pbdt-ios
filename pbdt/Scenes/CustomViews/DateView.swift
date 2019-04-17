//
//  DateView.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/15/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData

class DateView: UIView {
    
    // MARK: - objects and vars
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var view: UIView!
    
    var parentVc: String!
    var homeVc: HomeVC!
    var diaryVc: DiaryVC!
    
    // MARK: - functions
    
    // lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
        
        setupLabels()
        setupButtons()
    }
    
    // setups
    
    func xibSetup() {
        
        // load nib
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle.main
        let nib = UINib(nibName: "DateView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setupLabels() {
        
        if let dateFilter = appDelegate.dateFilter {
            let dateString = dateFilter.toString(format: "MMM dd, yyyy")
            dateLbl.text = "\(dateString)"
        }
    }
    
    func setupButtons() {
        
    }
    
    // dates
    
    func nextDay() {
        
        appDelegate.dateFilter = Calendar.current.date(byAdding: .day, value: 1, to: appDelegate.dateFilter)
        
        updateAfterDateChange()
        
        postNotificationDateChange()
    }
    
    func previousDay() {
        
        appDelegate.dateFilter = Calendar.current.date(byAdding: .day, value: -1, to: appDelegate.dateFilter)
        
        updateAfterDateChange()
        
        postNotificationDateChange()
    }
    
    // foods
    
    func loadFoods() {
        
        let date = appDelegate.dateFilter.toString(format: "yyyy-MM-dd")
        //print("date: \(date)")
        
        let foodFetch: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
        foodFetch.predicate = NSPredicate(format: "logDate = %@", "\(date)")
        
        do {
            let fetchRequest = try context.fetch(foodFetch)
            appDelegate.diaryEntries = fetchRequest
            
            switch parentVc {
            case "HomeVC":
                print("HomeVC")
                homeVc.updateSummary()
                //homeVc.tableView.reloadData()
            case "DiaryVC":
                print("DiaryVC")
                diaryVc.tableView.reloadData()
            default:
                print("d")
            }
        } catch {
            print("Error fetching foods: \(error)")
        }
    }
    
    // updates
    
    func updateAfterDateChange() {
        
        if let dateFilter = appDelegate.dateFilter {
            let dateString = dateFilter.toString(format: "MMM dd, yyyy")
            dateLbl.text = "\(dateString)"
        }
        
        loadFoods()
    }
    
    // notifications
    
    func postNotificationDateChange() {
        print("postNotificationDateChange")
        NotificationCenter.default.post(name: NSNotification.Name("DateChanged"), object: nil)
    }
    
    // MARK: - actions
    
    @IBAction func previousBtn_clicked(_ sender: Any) {
        
        previousDay()
    }
    
    @IBAction func nextBtn_clicked(_ sender: Any) {
        
        nextDay()
    }
    
}
