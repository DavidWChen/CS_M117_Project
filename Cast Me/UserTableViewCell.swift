//
//  UserTableViewCell.swift
//  Cast Me
//
//  Created by Martin Kong on 11/25/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // Properties:
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
