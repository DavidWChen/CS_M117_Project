//
//  generalProfileViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/20/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


class generalProfileViewController: UIViewController {
    
    var thisUser: GIDGoogleUser?
    var ref: FIRDatabaseReference?
    var friendnum: Int?
    var friend_email: String?
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userInterests: UITextView!
    
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
            }
            done1 = true
        }).resume()
        while(!done1){}
        return json!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        let useremail = (thisUser?.profile.email)!
        let cleanEmail = useremail.replacingOccurrences(of: ".", with: ",")
        
        var json: [String: Any]?
        json = readFirebase(urlstring: "friends_list/" + cleanEmail + ".json")
        print("This is friend # " + String(friendnum!))
        let friendemail = json!["friend"+String(friendnum!)] as! String
        friend_email = friendemail
        
        var json2: [String: Any]?
        json2 = readFirebase(urlstring: "users/" + friendemail + ".json")
        print(friendemail)
        print(json2)
        usernameLabel.text = (json2!["name"] as! String)
        
        var json3: [String: Any]?
        json3 = readFirebase(urlstring: "gps_location/" + friendemail + ".json")
        print("getting coords now")
        print(json3!)
        let latitude = json3!["latitude"] as! Double
        let longitude = json3!["longitude"] as! Double
        print("lat: "+String(latitude)+", long: "+String(longitude))
        var json0: [String: Any]?
        json0 = readFirebase(urlstring: "gps_location/" + cleanEmail + ".json")
        let userLat = json0!["latitude"] as! Double
        let userLong = json3!["longitude"] as! Double
        
        let Mycoordinate = CLLocation(latitude: userLat, longitude: userLong)
        let friendCoord = CLLocation(latitude: latitude, longitude: longitude)
        let distance = friendCoord.distance(from: Mycoordinate)/1609
        let distanceString = String(format: "%0.2f", distance)
        let subtitle = distanceString + "mi"
        userDistance.text = subtitle
        
        
        
        var user_interests = ""
        var num_interests = 0
        var json4 : [String: Any]?
        json4 = readFirebase(urlstring: "user_interests/"+friendemail+".json")
        if json4 != nil {
            num_interests = json4!.count - 1
        }
        var i = 0
        var count = 0
        while count < num_interests {
            let some_string = json4!["interest"+String(i)] as? String
            if some_string != nil {
                count += 1
                user_interests += some_string as! String
                if count != num_interests {
                    user_interests += ", "
                }
            }
            i += 1
        }
        userInterests.text = user_interests
        userInterests.isEditable = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of PlayerTableViewController
        
        if let destination = segue.destination as? searchPageViewController {
            destination.thisUser = thisUser
        } else if let destination = segue.destination as? friendsListViewController {
            destination.thisUser = thisUser
        } else if let destination = segue.destination as? messageViewController {
            let useremail = (thisUser?.profile.email)!
            let cleanEmail = useremail.replacingOccurrences(of: ".", with: ",")
            var json: [String: Any]?
            json = readFirebase(urlstring: "users.json")
            var u1 = json![cleanEmail] as! [String: Any]
            var u1_id = u1["id"] as! String
            var u2 = json![friend_email!] as! [String: Any]
            var u2_id = u2["id"] as! String
            var c_id = ""
            if (Int(u1_id) as! Int) < (Int(u2_id) as! Int) {
                c_id = u1_id + u2_id
            } else {
                c_id = u2_id + u1_id
            }
            
            let messageItem = [ // 2
                "senderId": "0",
                "senderName": "0",
                "text": "0",
                ]
            
            ref?.child("messages/" + c_id + "/msg0").setValue(messageItem)
            destination.thisUser = thisUser
            destination.channel_id = c_id
            destination.senderDisplayName = u1["name"] as! String
            print("sent channel " + c_id)
            destination.friendnum = friendnum
            destination.friend_email = friend_email
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
