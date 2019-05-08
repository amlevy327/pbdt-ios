//
//  HomeCell.swift
//  pbdt
//
//  Created by Andrew M Levy on 5/2/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import UICircularProgressRing

class HomeCell: UICollectionViewCell {

    // MARK: - objects and vars
    @IBOutlet weak var circularProgressRing: UICircularProgressRing!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    // MARK: - functions
    
    // lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circularProgressRing.shouldShowValueText = false
        
        circularProgressRing.minValue = 0.0
        
        circularProgressRing.outerRingColor = UIColor.brandGreyDark()
        circularProgressRing.outerRingWidth = CGFloat(2)
        
        circularProgressRing.innerRingColor = UIColor.brandPrimary()
        circularProgressRing.innerRingWidth = CGFloat(6)
        
        //nameLbl.textColor = UIColor.brandPrimary()
        nameLbl.textColor = UIColor.brandBlack()
        //nameLbl.textColor = UIColor.brandGreyDark()
        nameLbl.font = UIFont.large()
        
        //self.layer.borderWidth = CGFloat(1)
        //self.layer.borderColor = UIColor.brandPrimary().cgColor
    }
    
    override func prepareForReuse() {
        //circularProgressRing = nil
        //circularProgressRing.maxValue = CGFloat(0)
        circularProgressRing.resetProgress()
    }
}
