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
    @IBOutlet weak var streakLbl: UILabel!
    
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
        
        nameLbl.textColor = UIColor.brandBlack()
        nameLbl.font = UIFont.large()
        
        streakLbl.textColor = UIColor.red
        streakLbl.font = UIFont.streak()
    }
    
    override func prepareForReuse() {
        //print("prepareForReuse: \(nameLbl.text)")
        
        //circularProgressRing = nil
        //circularProgressRing = UICircularProgressRing()
        
        //circularProgressRing.resetProgress()
        
        //circularProgressRing.value = CGFloat(0)
        //circularProgressRing.resetProgress()
        //circularProgressRing.maxValue = 10000
        //circularProgressRing.value = 0
    }
}
