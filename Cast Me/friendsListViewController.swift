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
    
    var users = [String]()
    
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
        users = [String]()
        
        var json0: [String: Any]?
        json0 = readFirebase(urlstring: "gps_location.json")
        var json1 = json0![cleanEmail!] as? [String: Any]
        let userLat = json1!["latitude"] as! Double
        let userLong = json1!["longitude"] as! Double
        
        var json2 = readFirebase(urlstring: "users.json")
        var numFriends = json2.count - 1
        
        /*var numFriends00 = 0
        var emails = Array(repeating: "", count: numFriends00)
        var distances = Array(repeating: 0.0, count: numFriends00)
        var coordinates = Array(repeating: CLLocation(), count: numFriends00)
        var json00: [String: Any]?
        json00 = readFirebase(urlstring: "friends_list.json")
        json00 = json00![cleanEmail!] as? [String: Any]
        numFriends00 = json00!["friend_count"] as! Int
        let plsemail : String = cleanEmail!*/
        let Mycoordinate = CLLocation(latitude: userLat, longitude: userLong)
        
        for person in json2 {
            if person.key != cleanEmail {
                var jsontemp = json0![person.key] as? [String: Any]
                let lat1 = jsontemp!["latitude"] as! Double
                let long1 = jsontemp!["longitude"] as! Double
                
                if CLLocation(latitude: lat1, longitude:long1).distance(from: Mycoordinate)/1609 <= 2.0 {
                    users.append(person.key)
                    print(person.key)
                }
            }
        }
        print("Nearby users: " + String(users.count))
        return users.count
        
        /*var j = 0
        while (j < numFriends00) //get emails
        {
            var json: [String: Any]?
            json = readFirebase(urlstring: "friends_list.json")
            json = json![cleanEmail!] as? [String: Any]
            let k = "friend" + String(j)
            print(k)
            emails[j] = json![k] as! String //will fail if json![k] isnt a string
            print(emails[j])
            j = j+1
            
        }*/
        
        /*var i = 0
        while (i < numFriends00) //get pin coordinates
        {
            var json: [String: Any]?
            json = readFirebase(urlstring: "gps_location.json")
            json = json![emails[i]] as? [String: Any]
            
            let lat = json!["latitude"] as! Double
            print(lat)
            let long = json!["longitude"] as! Double
            print(long)
            coordinates[i] = CLLocation(latitude: lat, longitude:long)
            
            distances[i] = coordinates[i].distance(from: Mycoordinate)/1609
            
            
            i = i+1
        }*/
        
        
        /*var json: [String: Any]?
        json = readFirebase(urlstring: "friends_list/"+plsemail+".json")
        self.numfriends = json!.count - 1 //["friend_count"] as! Int
        
        print("this is numfriends: " + String(numfriends))
        return numfriends
        
        var k = 0
        var countNearFriends = 0*/
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
