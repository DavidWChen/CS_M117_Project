//
//  myProfileViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/19/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit

class myProfileViewController: UIViewController {
    
    var thisUser: GIDGoogleUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of PlayerTableViewController
        
        if let destination = segue.destination as? homePageViewController {
            destination.thisUser = thisUser
        } else if let destination = segue.destination as? editInterestsViewController {
            destination.thisUser = thisUser
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
