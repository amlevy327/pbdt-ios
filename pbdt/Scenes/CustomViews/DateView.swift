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
        
        // attributes
        view.backgroundColor = UIColor.viewBackground()
        
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
        
        dateLbl.font = UIFont.dateText()
        
        updateDateLbl()
    }
    
    func setupButtons() {
        
        previousBtn.titleLabel?.font = UIFont.dateButtonText()
        //previousBtn.backgroundColor = UIColor.dateButtonBackground()
        previousBtn.setTitleColor(UIColor.dateButtonText(), for: .normal)
        //previousBtn.setTitleColor(UIColor.brandWhite(), for: .normal)
        previousBtn.layer.borderWidth = CGFloat(2)
        previousBtn.layer.borderColor = UIColor.dateButtonBorder().cgColor
        
        nextBtn.titleLabel?.font = UIFont.dateButtonText()
        //nextBtn.backgroundColor = UIColor.dateButtonBackground()
        nextBtn.setTitleColor(UIColor.dateButtonText(), for: .normal)
        //nextBtn.setTitleColor(UIColor.brandWhite(), for: .normal)
        nextBtn.layer.borderWidth = CGFloat(2)
        nextBtn.layer.borderColor = UIColor.dateButtonBorder().cgColor
    }
    
    // updates
    
    func updateDateLbl() {
        
        //print("updateDateLbl: start")
        
        if let dateFilter = appDelegate.dateFilter {
            
            let today = Date()
            let todayNoTimeStamp = today.removeTimeStamp(fromDate: today)
            //print("today: \(today)")
            
            let dateFilterNoTimeStamp = dateFilter.removeTimeStamp(fromDate: dateFilter)
            let difference = Calendar.current.dateComponents([.day], from: todayNoTimeStamp, to: dateFilterNoTimeStamp)
            //print("difference: \(difference.day)")
            
            switch difference.day {
            case -1:
                dateLbl.text = "Yesterday"
            case 0:
                dateLbl.text = "Today"
            case 1:
                dateLbl.text = "Tomorrow"
            default:
                let dateString = dateFilter.toString(format: "MMM dd, yyyy")
                dateLbl.text = "\(dateString)"
            }
        }
    }
    
    // dates
    
    func nextDay() {
        
        appDelegate.dateFilter = Calendar.current.date(byAdding: .day, value: 1, to: appDelegate.dateFilter)
        
        //updateAfterDateChange()
        postNotificationDateChange()
    }
    
    func previousDay() {
        
        appDelegate.dateFilter = Calendar.current.date(byAdding: .day, value: -1, to: appDelegate.dateFilter)
        
        //updateAfterDateChange()
        postNotificationDateChange()
    }
    
    // updates
    
    func updateAfterDateChange() {
        
        updateDateLbl()
        
        appDelegate.loadFoods()
    }
    
    // notifications
    
    func postNotificationDateChange() {
        //print("postNotificationDateChange")
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
