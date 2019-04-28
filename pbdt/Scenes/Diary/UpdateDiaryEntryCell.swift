//
//  UpdateDiaryEntryCell.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/6/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class UpdateDiaryEntryCell: UITableViewCell {
    
    // MARK: - object and vars

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    // MARK: - functions
    
    // lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        nameLbl.font = UIFont.cellLarge()
        amountLbl.font = UIFont.cellLarge()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
