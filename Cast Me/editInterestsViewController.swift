//
//  editInterestsViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/20/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Firebase

class editInterestsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var thisUser: GIDGoogleUser?
    @IBOutlet weak var interestsList: UITableView!
    @IBOutlet weak var interestTextField: UITextField!
    let ref = FIRDatabase.database().reference()
    
    var myInterests = Set<String>()
    
    func readFirebase(urlstring: String) -> [String: Any] {
        var json: [String: Any]?
        var done1 = false
        let urlRequest = URLRequest(url: URL(string: "https://fir-cast-me.firebaseio.com/" + urlstring)!)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            let responseData = data
            do {
                if let todoJSON = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]{
                    json = todoJSON
                }
            } catch {
                print("error")
                return
            }
            done1 = true
        }).resume()
        while(!done1){}
        return json!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interestsList.delegate = self
        interestsList.dataSource = self
        interestTextField.delegate = self
        
        var i = 0
        let useremail = (thisUser?.profile.email)!
        let cleanEmail = useremail.replacingOccurrences(of: ".", with: ",")
        var json: [String: Any]?
        json = readFirebase(urlstring: "user_interests/"+cleanEmail+".json")
        var num_interests = 0
        if json != nil {
            num_interests = json!.count - 1
        }
        
        var count = 0
        while count < num_interests {
            let some_string = json!["interest"+String(i)] as? String
            if some_string != nil {
                count += 1
                myInterests.insert(some_string as! String)
            }
            i += 1
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var json: [String: Any]?
        json = readFirebase(urlstring: "interests.json")
        let num_interests = json!.count
        ref.child("interests/interest" + String(num_interests)).setValue(interestTextField.text as! String)
        interestsList.beginUpdates()
        interestsList.insertRows(at: [
            NSIndexPath(row: num_interests-1, section: 0) as IndexPath
            ], with: .automatic)
        interestsList.reloadData()
        interestsList.endUpdates()
        
        print(textField.text as! String)
        print("num rows in section: " + String(interestsList.numberOfRows(inSection: 0)))
        interestTextField.text = ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : InterestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InterestTableViewCell", for: indexPath as IndexPath) as! InterestTableViewCell
        var json: [String: Any]?
        json = readFirebase(urlstring: "interests.json")
        let some_interest = json!["interest"+String(indexPath.row)] as! String
        cell.interest.text = some_interest
        cell.index = indexPath.row
        if myInterests.contains(some_interest) {
            cell.yesNo.setTitle("Yes", for: UIControlState.normal)
        } else {
            cell.yesNo.setTitle("No", for: UIControlState.normal)
        }
        print("row: " + String(indexPath.row))
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var json: [String: Any]?
        json = readFirebase(urlstring: "interests.json")
        //let num_interests = json!["interests"] as! Int
        let num_interests = json!.count
        print("rows in section: "+String(num_interests))
        return num_interests
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of PlayerTableViewController
        
        
        if let destination = segue.destination as? myProfileViewController {
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
