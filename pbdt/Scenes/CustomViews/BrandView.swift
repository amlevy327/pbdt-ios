//
//  BrandView.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/27/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class BrandView: UIView {

    // MARK: - objects and vars
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    var view: UIView!
    
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
    }
    
    // setups
    
    func xibSetup() {
        
        // load nib
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // attributes
        view.backgroundColor = UIColor.brandPrimary()
        topView.backgroundColor = UIColor.clear
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle.main
        let nib = UINib(nibName: "BrandView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setupLabels() {
        
        nameLbl.font = UIFont.brandViewLarge()
        nameLbl.textColor = UIColor.brandWhite()
        nameLbl.text = "pbdt"
        
        detailLbl.font = UIFont.brandViewSmall()
        detailLbl.textColor = UIColor.brandWhite()
        detailLbl.text = "plant based diet tracker"
    }
    
    // MARK: - actions

}
