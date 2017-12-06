//
//  friendsListViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/20/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class friendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var thisUser: GIDGoogleUser?
    var ref: FIRDatabaseReference?
    var cleanEmail: String?
    var numfriends = -1
    @IBOutlet weak var friendsList: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    var first = true
    
    var users = [String]()
    var users_copy = [String]()
    var myInterests = [String]()
    
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
        
        cleanEmail = (thisUser?.profile.email)?.replacingOccurrences(of: ".", with: ",")

        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()
        
        print(cleanEmail!)
        let type2 = type(of: cleanEmail!)
        print("'\(cleanEmail!)' of type '\(type2)'")
        
        friendsList.delegate = self
        friendsList.dataSource = self
        
        var json = readFirebase(urlstring: "user_interests/" + cleanEmail! + ".json")
        for interest in json {
            myInterests.append(interest.key)
        }
        
        filterButton.setTitle("Filter By Interests", for: .normal)
        friendsList.beginUpdates()
        friendsList.reloadData()
        friendsList.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath as IndexPath) as! UserTableViewCell
        
        cell.emailLabel.text = users[indexPath.row].replacingOccurrences(of: ",", with: ".")
        
        var json22: [String: Any]?
        json22 = readFirebase(urlstring: "users/"+users[indexPath.row]+".json")
        let namee = json22!["name"] as! String
        cell.nameLabel.text = namee
        
        print("reload")
        print(filterButton.titleLabel?.text)
        cell.contentView.backgroundColor = UIColor.white
        if filterButton.titleLabel?.text != "Unfilter By Interests" && first == false {
            var newinterests = users_copy.filter(){[users[indexPath.row]].contains($0)}
            if newinterests.count > 0 {
                cell.contentView.backgroundColor = UIColor.yellow
            }
        }
        if indexPath.row == users.count - 1 {
            first = false
        }
        return cell

        /*var new_friend_email = "hi"
        
        let plsemail : String = cleanEmail!
        var friend_email = ""
        
        var json: [String: Any]?
        json = readFirebase(urlstring: "friends_list/"+plsemail+".json")
        friend_email = json!["friend"+String(indexPath.row)] as! String
        new_friend_email = friend_email
        new_friend_email = new_friend_email.replacingOccurrences(of: ",", with: ".")
        
        var json2: [String: Any]?
        json2 = readFirebase(urlstring: "users/"+friend_email+".json")
        let name = json2!["name"] as! String
        
        
        print("friendo: " + new_friend_email)
        print(indexPath.row)
        cell.emailLabel.text = new_friend_email
        cell.nameLabel.text = name
        
        return cell*/
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let plsemail : String = cleanEmail!
        
        var json: [String: Any]?
        json = readFirebase(urlstring: "friends_list/"+plsemail+".json")
        self.numfriends = json!.count - 1 //["friend_count"] as! Int
        
        print(numfriends)
        return numfriends
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if filterButton.titleLabel?.text == "Filter By Interests" {
            users = [String]()
            users_copy = [String]()
            
            var json0: [String: Any]?
            json0 = readFirebase(urlstring: "gps_location.json")
            var json1 = json0![cleanEmail!] as? [String: Any]
            let userLat = json1!["latitude"] as! Double
            let userLong = json1!["longitude"] as! Double
            
            var json2 = readFirebase(urlstring: "users.json")
            var numFriends = json2.count - 1
            
        
            let Mycoordinate = CLLocation(latitude: userLat, longitude: userLong)
            
            for person in json2 {
                if person.key != cleanEmail {
                    var jsontemp = json0![person.key] as? [String: Any]
                    let lat1 = jsontemp!["latitude"] as! Double
                    let long1 = jsontemp!["longitude"] as! Double
                    
                    if CLLocation(latitude: lat1, longitude:long1).distance(from: Mycoordinate)/1609 <= 2.0 {
                        users.append(person.key)
                        //print(person.key)
                    }
                }
            }
            print("Nearby users: " + String(users.count))
        //} else {
            
            //if filter by interests
            //var users_copy = users
            //print(users_copy)
            users_copy = [String]()
            for user in users {
                var json = readFirebase(urlstring: "user_interests/" + user + ".json")
                var user_interests = [String]()
                for interest in json {
                    user_interests.append(interest.key)
                }
                //print(user_interests)
                //print(myInterests)
                var newinterests = myInterests.filter(){user_interests.contains($0)}
                //print(newinterests)
                if newinterests.count > 1 {
                    users_copy.append(user)
                }
            }
            print("Nearby users: " + String(users_copy.count))
        //}
        print(users)
        print(users_copy)
        return users.count
        
       
    }
    
    @IBAction func filterClicked(_ sender: UIButton) {
        if filterButton.titleLabel?.text == "Filter By Interests" {
            filterButton.setTitle("Unfilter By Interests", for: .normal)
            //filterButton.titleLabel?.text = "Unfilter By Interests"
        } else {
            filterButton.setTitle("Filter By Interests", for: .normal)
            //filterButton.titleLabel?.text = "Filter By Interests"
        }
        friendsList.beginUpdates()
        friendsList.reloadData()
        friendsList.endUpdates()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of PlayerTableViewController
        print("HELLO LEAVING NOW")
        if let destination = segue.destination as? generalProfileViewController {
            print("Going to general profile")
            destination.thisUser = thisUser
            guard let selectedCell = sender as? UserTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = friendsList.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let friendnum = indexPath.row
            print("sending friend # " + String(friendnum))
            //destination.friendnum = friendnum
            destination.friend_email = users[indexPath.row]
        } else if let destination = segue.destination as? searchPageViewController {
            destination.thisUser = thisUser
        } else if let destination = segue.destination as? homePageViewController {
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
