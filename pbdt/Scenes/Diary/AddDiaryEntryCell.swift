//
//  AddDiaryEntryCell.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/8/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class AddDiaryEntryCell: UITableViewCell {
    
    // MARK: objects and vars
    @IBOutlet weak var nameLbl: UILabel!
    
    // MARK: - functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLbl.font = UIFont.cellLarge()
        nameLbl.textColor = UIColor.brandBlack()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
