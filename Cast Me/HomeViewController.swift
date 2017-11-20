//
//  HomeViewController.swift
//  
//
//  Created by Martin Kong on 11/20/17.
//

import UIKit

class HomeViewController: UIViewController {
    
    var userEmail : String?
    @IBOutlet weak var Username: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Loaded home view")
        
        Username.setTitle(userEmail,for: .normal)
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
