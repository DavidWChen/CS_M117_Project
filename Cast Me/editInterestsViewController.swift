//
//  editInterestsViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/20/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit

class editInterestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var thisUser: GIDGoogleUser?
    @IBOutlet weak var interestsList: UITableView!
    
    func readFirebase(urlstring: String) -> [String: Any] {
        var json: [String: Any]?
        var done1 = false
        let urlRequest = URLRequest(url: URL(string: "https://fir-cast-me.firebaseio.com/" + urlstring)!)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : InterestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InterestTableViewCell", for: indexPath as IndexPath) as! InterestTableViewCell
        var json: [String: Any]?
        json = readFirebase(urlstring: "interests.json")
        var some_interest = json!["interest"+String(indexPath.row)] as! String
        cell.interest.text = some_interest
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var json: [String: Any]?
        json = readFirebase(urlstring: "interests.json")
        let num_interests = json!["interests"] as! Int
        print("edit_interests "+String(num_interests))
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
