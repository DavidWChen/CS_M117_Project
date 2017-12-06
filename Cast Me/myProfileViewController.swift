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
    @IBOutlet weak var userInterests: UITextView!
    
    var cleanEmail: String?
    var numfriends = -1
    
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

        if thisUser != nil {
            myUsername.text = thisUser?.profile.name
        }
        cleanEmail = (thisUser?.profile.email)?.replacingOccurrences(of: ".", with: ",")
        friendsList.delegate = self
        friendsList.dataSource = self
        
        let plsemail : String = cleanEmail!
        var my_interests = ""
        var num_interests = 0
        var json : [String: Any]?
        json = readFirebase(urlstring: "user_interests/"+plsemail+".json")
        
        if json != nil {
            num_interests = json!.count - 1
        }
        
        var i = 0
        var count = 0
        while count < num_interests {
            let some_string = json!["interest"+String(i)] as? String
            if some_string != nil {
                count += 1
                my_interests += some_string as! String
                if count != num_interests {
                    my_interests += ", "
                }
            }
            i += 1
        }
        
        userInterests.text = my_interests
        userInterests.isEditable = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath as IndexPath) as! UserTableViewCell
        
        var new_friend_email = "hi"
        
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
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let plsemail : String = cleanEmail!
        
        var json: [String: Any]?
        json = readFirebase(urlstring: "friends_list/"+plsemail+".json")
        self.numfriends = json!.count - 1 //["friend_count"] as! Int
        
        print(numfriends)
        return numfriends
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
