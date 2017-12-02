//
//  InterestTableViewCell.swift
//  Cast Me
//
//  Created by Martin Kong on 11/28/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Firebase

class InterestTableViewCell: UITableViewCell {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var thisUser = appDelegate.thisUser
    
    //Properties
    @IBOutlet weak var interest: UILabel!
    @IBOutlet weak var yesNo: UIButton!
    
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func yesNoButton(_ sender: UIButton) {
        let ref = FIRDatabase.database().reference()
        let useremail = (thisUser?.profile.email)!
        let cleanEmail = useremail.replacingOccurrences(of: ".", with: ",")
        if yesNo.titleLabel?.text == "Yes" {
            yesNo.setTitle("No", for: UIControlState.normal)
            ref.child("user_interests/" + cleanEmail + "/interest" + String(index)).setValue(nil)
        } else {
            yesNo.setTitle("Yes", for: UIControlState.normal)
            ref.child("user_interests/" + cleanEmail + "/interest" + String(index)).setValue(interest.text)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
