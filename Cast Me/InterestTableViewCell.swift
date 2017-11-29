//
//  InterestTableViewCell.swift
//  Cast Me
//
//  Created by Martin Kong on 11/28/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit

class InterestTableViewCell: UITableViewCell {
    
    //Properties
    @IBOutlet weak var interest: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
