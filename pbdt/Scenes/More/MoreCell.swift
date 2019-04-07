//
//  MoreCell.swift
//  pbdt
//
//  Created by Andrew M Levy on 3/31/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {
    
    // MARK: - objects and vars
    
    // objects
    @IBOutlet weak var nameLbl: UILabel!
    
    // vars
    
    // MARK: - functions
    
    // lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
