//
//  HomeCollectionCell.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/18/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class HomeCollectionCell: UICollectionViewCell {
    
    // MARK: - objects and vars
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var goalLbl: UILabel!
    
    // MARK: - functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = CGFloat(10)
    }

}
