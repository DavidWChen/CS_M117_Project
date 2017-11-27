//
//  myProfileViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/19/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit

class myProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var thisUser: GIDGoogleUser?
    @IBOutlet weak var myUsername: UILabel!
    @IBOutlet weak var friendsList: UITableView!
    
    var cleanEmail: String?
    var numfriends = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if thisUser != nil {
            myUsername.text = thisUser?.profile.name
        }
        cleanEmail = (thisUser?.profile.email)?.replacingOccurrences(of: ".", with: ",")
        friendsList.delegate = self
        friendsList.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath as IndexPath) as! UserTableViewCell
        
        var new_friend_email = "hi"
        
        let plsemail : String = cleanEmail!
        var friend_email = ""
        
        var done1 = false
        let url = URL(string: "https://fir-cast-me.firebaseio.com/friends_list/"+plsemail+".json")
        let urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                if let todoJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]{
                    //print(todoJSON)
                    friend_email = todoJSON["friend"+String(indexPath.row)] as! String
                    new_friend_email = friend_email
                    new_friend_email = new_friend_email.replacingOccurrences(of: ",", with: ".")
                    done1 = true
                } else {
                    print("error")
                }
            } catch {
                print("error")
                return
            }
        })
        task.resume()
        while(!done1){
            
        }
        
        var done2 = false
        var name = ""
        let url2 = URL(string: "https://fir-cast-me.firebaseio.com/users/"+friend_email+".json")
        let urlRequest2 = URLRequest(url: url2!)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: urlRequest2, completionHandler: {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                if let todoJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]{
                    //print(todoJSON)
                    name = todoJSON["name"] as! String
                    done2 = true
                } else {
                    print("error")
                }
            } catch {
                print("error")
                return
            }
        })
        task2.resume()
        while(!done2){
            
        }
        
        print("friendo: " + new_friend_email)
        print(indexPath.row)
        cell.emailLabel.text = new_friend_email
        cell.nameLabel.text = name
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let plsemail : String = cleanEmail!
        
        var done = false
        let url = URL(string: "https://fir-cast-me.firebaseio.com/friends_list/"+plsemail+".json")
        let urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                if let todoJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]{
                    //print(todoJSON)
                    self.numfriends = todoJSON["friend_count"] as! Int
                    done = true
                } else {
                    print("error")
                }
            } catch {
                print("error")
                return
            }
        })
        task.resume()
        while(!done){
            
        }
        print(numfriends)
        return numfriends
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