//
//  NavigationDateView.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/27/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class NavigationDateView: UIView {

    // MARK: - objects and vars
    @IBOutlet weak var navDateLbl: UILabel!
    @IBOutlet weak var navPreviousBtn: UIButton!
    @IBOutlet weak var navNextBtn: UIButton!
    
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
        view.backgroundColor = UIColor.brandPrimary()
        
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
        
        //dateLbl.backgroundColor = UIColor.viewBackground()
        navDateLbl.textColor = UIColor.brandWhite()
        navDateLbl.font = UIFont.dateText()
        
        updateDateLbl()
    }
    
    func setupButtons() {
        
        navPreviousBtn.titleLabel?.font = UIFont.dateButtonText()
        navPreviousBtn.backgroundColor = UIColor.dateButtonBackground()
        navPreviousBtn.setTitleColor(UIColor.dateButtonText(), for: .normal)
        //previousBtn.layer.borderWidth = CGFloat(2)
        //previousBtn.layer.borderColor = UIColor.dateButtonBorder().cgColor
        
        navNextBtn.titleLabel?.font = UIFont.dateButtonText()
        navNextBtn.backgroundColor = UIColor.clear
        navNextBtn.setTitleColor(UIColor.brandWhite(), for: .normal)
        //nextBtn.layer.borderWidth = CGFloat(2)
        //nextBtn.layer.borderColor = UIColor.dateButtonBorder().cgColor
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
                navDateLbl.text = "Yesterday"
            case 0:
                navDateLbl.text = "Today"
            case 1:
                navDateLbl.text = "Tomorrow"
            default:
                let dateString = dateFilter.toString(format: "MMM dd, yyyy")
                navDateLbl.text = "\(dateString)"
            }
        }
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
    
}
