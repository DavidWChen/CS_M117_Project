//
//  testSearchViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 12/5/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Firebase

class testSearchViewController: UIViewController {
    
    //text field for username

   
    @IBOutlet weak var textFieldUsername: UITextField!
    
   
    @IBAction func searchDatabase(_ sender: UIButton)
    {
        let username: String = textFieldUsername.text
      print(username)
    }
   
    /*@IBAction func searchDatabase(_ sender: UIButton)
    {
        let username = textFieldUsername
     
    }*/
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIRApp.configure()
        

        // Do any additional setup after loading the view.
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
