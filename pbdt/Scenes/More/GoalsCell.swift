//
//  GoalsCell.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/26/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class GoalsCell: UITableViewCell {
    
    // MARK: - objects and vars
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var goalTxt: UITextField!
    
    // objects
    
    // vars
    
    // MARK: - functions
    
    // lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLbl.font = UIFont.cellLarge()
        nameLbl.textColor = UIColor.brandBlack()
        
        goalTxt.font = UIFont.cellLarge()
        goalTxt.textColor = UIColor.brandSecondary()
        goalTxt.keyboardType = .decimalPad
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
