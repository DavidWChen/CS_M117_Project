//
//  friendsListViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/20/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Firebase

class friendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "groupcell", for: indexPath as IndexPath) as UITableViewCell
        // create a table view class for a friend cell
        
        //cell.textLabel?.text = self.groupList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }*/
    
    
    var thisUser: GIDGoogleUser?
    @IBOutlet weak var friendsList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var ref: FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("users").child((thisUser?.profile.name)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let useremail = value?["email"] as? String ?? ""
            print(useremail)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.friendsList.register(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        
        friendsList.delegate = self
        friendsList.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of PlayerTableViewController
        
        if let destination = segue.destination as? generalProfileViewController {
            destination.thisUser = thisUser
        } else if let destination = segue.destination as? searchPageViewController {
            destination.thisUser = thisUser
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "groupcell", for: indexPath as IndexPath) as UITableViewCell
        
        cell.textLabel?.text = self.groupList[indexPath.row]
        return cell
    }*/
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
