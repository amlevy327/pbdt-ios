//
//  HomeCell.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/16/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    
    // MARK: - objects and vars
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    // MARK: - functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
