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
    var addDiaryEntryVc: AddDiaryEntryVC!
    var goalsVc: GoalsVC!
    var confirmRecipeVc: ConfirmRecipeVC!
    
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
        
        // attributes
        view.backgroundColor = UIColor.viewBackground()
        
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
        
        print("parentVc = \(parentVc)")
        
        let indicatorOptions = SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: 2,
            color: UIColor.brandPrimary())
        
        let horizontalOptions = SegmentioHorizontalSeparatorOptions(type: .bottom, height: 1, color: UIColor.brandGreyLight())
        
        let verticalOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: UIColor.brandGreyLight())
        
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
        
        let servingsItem = SegmentioItem(title: "Food Groups", image: nil)
        let nutritionItem = SegmentioItem(title: "Nutrition", image: nil)
        let itemsItem = SegmentioItem(title: "Items", image: nil)
        let recipesItem = SegmentioItem(title: "Recipes", image: nil)
        
        var content : [SegmentioItem] = []
        
        switch self.parentVc {
        case "AddDiaryEntryVC":
            print("content: AddDiaryEntryVC")
            content = [itemsItem, recipesItem]
        default:
            print("content: d")
            content = [servingsItem, nutritionItem]
        }
        
        segmentedControl.setup(
            content: content,
            style: .onlyLabel,
            options: segmentOptions)
        
        segmentedControl.valueDidChange = { segmentio, segmentIndex in
            
            print("parentVc = \(self.parentVc)")
            
            switch self.parentVc {
            case "HomeVC":
                print("HomeVC")
                self.homeVc.selectedSegmentedControlIndex = self.segmentedControl.selectedSegmentioIndex
                print("index: \(self.segmentedControl.selectedSegmentioIndex)")
                //self.homeVc.updateSummary()
                //self.homeVc.amountsServings = []
                self.homeVc.collectionView.reloadData()
            case "UpdateDiaryEntryVC":
                print("UpdateDiaryEntryVC")
                self.updateDiaryEntryVc.tableView.reloadData()
            case "AddDiaryEntryVC":
                print("AddDiaryEntryVC")
                
                switch self.segmentedControl.selectedSegmentioIndex {
                case 0:
                    if self.addDiaryEntryVc.searchBarText == "" {
                        self.addDiaryEntryVc.itemsFiltered = self.addDiaryEntryVc.items
                    } else {
                        self.addDiaryEntryVc.itemsFiltered = self.addDiaryEntryVc.items.filter { $0.name!.lowercased().contains(self.addDiaryEntryVc.searchBarText.lowercased()) }
                    }
                    print("addDiaryEntryVc.itemsFiltered.count: \(self.addDiaryEntryVc.itemsFiltered.count)")
                case 1:
                    if self.addDiaryEntryVc.searchBarText == "" {
                        self.addDiaryEntryVc.recipesFiltered = self.addDiaryEntryVc.recipes
                    } else {
                        self.addDiaryEntryVc.recipesFiltered = self.addDiaryEntryVc.recipes.filter { $0.name!.lowercased().contains(self.addDiaryEntryVc.searchBarText.lowercased()) }
                    }
                    print("addDiaryEntryVc.recipesFiltered.count: \(self.addDiaryEntryVc.recipesFiltered.count)")
                default:
                    print("d")
                }
                
                self.addDiaryEntryVc.tableView.reloadData()
            case "GoalsVC":
                print("GoalsVC")
                self.goalsVc.tableView.reloadData()
            case "ConfirmRecipeVC":
                print("ConfirmRecipeVC")
                self.confirmRecipeVc.tableView.reloadData()
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
                titleFont: UIFont.segmentedControlDefault(),
                titleTextColor: UIColor.segmentedControlDefault()
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.segmentedControlSelected(),
                titleTextColor: UIColor.segmentedControlSelected()
            ),
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.segmentedControlDefault(),
                titleTextColor: UIColor.segmentedControlDefault()
            )
        )
    }
    
}
