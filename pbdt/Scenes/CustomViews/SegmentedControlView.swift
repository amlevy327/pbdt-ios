//
//  SegmentedControlView.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/16/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import Segmentio

class SegmentedControlView: UIView {
    
    // MARK: - objects and vars
    @IBOutlet weak var segmentedControl: Segmentio!
    
    var view: UIView!
    
    var parentVc: String!
    var homeVc: HomeVC!
    var updateDiaryEntryVc: UpdateDiaryEntryVC!
    
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
        
        setupSegmentedControl()
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
        let nib = UINib(nibName: "SegmentedControlView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setupSegmentedControl() {
        
        let indicatorOptions = SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: 4,
            color: UIColor.blue)
        
        let horizontalOptions = SegmentioHorizontalSeparatorOptions(type: .bottom, height: 0, color: UIColor.black)
        
        let verticalOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: UIColor.black)
        
        let segmentOptions = SegmentioOptions(
            backgroundColor: UIColor.white,
            segmentPosition: .fixed(maxVisibleItems: 2),
            scrollEnabled: false,
            indicatorOptions: indicatorOptions,
            horizontalSeparatorOptions: horizontalOptions,
            verticalSeparatorOptions: verticalOptions,
            imageContentMode: .center,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: segmentioStates(),
            animationDuration: 0.1)
        
        let servingsItem = SegmentioItem(title: "Servings", image: nil)
        let nutritionItem = SegmentioItem(title: "Nutrition", image: nil)
        let content : [SegmentioItem] = [servingsItem, nutritionItem]
        
        segmentedControl.setup(
            content: content,
            style: .onlyLabel,
            options: segmentOptions)
        
        segmentedControl.valueDidChange = { segmentio, segmentIndex in
            
            switch self.parentVc {
            case "HomeVC":
                print("HomeVC")
                self.homeVc.updateSummary()
            case "UpdateDiaryEntryVC":
                print("UpdateDiaryEntryVC")
                self.updateDiaryEntryVc.tableView.reloadData()
            default:
                print("d")
            }
        }
        
        segmentedControl.selectedSegmentioIndex = 0
    }
    
    // segmented control
    
    func segmentioStates() -> SegmentioStates {
        return SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 16),
                titleTextColor: UIColor.black
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 16),
                titleTextColor: UIColor.red
            ),
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 16),
                titleTextColor: UIColor.black
            )
        )
    }
    
}
