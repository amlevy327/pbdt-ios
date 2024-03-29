//
//  DiaryCell.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/5/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit

class DiaryCell: UITableViewCell {
    
    // MARK: - objects and vars
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    // MARK: - functions

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLbl.font = UIFont.cellLarge()
        nameLbl.textColor = UIColor.cellPrimaryText()
        
        detailLbl.font = UIFont.cellSmall()
        detailLbl.textColor = UIColor.cellSecondaryText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
