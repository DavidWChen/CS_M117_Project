//
//  generalProfileViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/20/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Firebase

class generalProfileViewController: UIViewController {
    
    var thisUser: GIDGoogleUser?
    var friendnum: Int?
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userInterests: UITextView!
    
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
            }
            done1 = true
        }).resume()
        while(!done1){}
        return json!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let useremail = (thisUser?.profile.email)!
        let cleanEmail = useremail.replacingOccurrences(of: ".", with: ",")
        
        var json: [String: Any]?
        json = readFirebase(urlstring: "friends_list/" + cleanEmail + ".json")
        print("This is friend # " + String(friendnum!))
        var friendemail = json!["friend"+String(friendnum!)] as! String
        
        var json2: [String: Any]?
        json2 = readFirebase(urlstring: "users/" + friendemail + ".json")
        usernameLabel.text = json2!["name"] as! String
        
        var json3: [String: Any]?
        json3 = readFirebase(urlstring: "gps_location/" + friendemail + ".json")
        print("getting coords now")
        print(json3!)
        var latitude = json3!["latitude"] as! Double
        var longitude = json3!["longitude"] as! Double
        print("lat: "+String(latitude)+", long: "+String(longitude))
        userDistance.text = String(describing: latitude) + ", " + String(describing: longitude)
        
        
        var user_interests = ""
        var num_interests = 0
        var json4 : [String: Any]?
        json4 = readFirebase(urlstring: "user_interests/"+friendemail+".json")
        if json4 != nil {
            num_interests = json4!.count as! Int
        }
        var i = 0
        var count = 0
        while count < num_interests {
            var some_string = json4!["interest"+String(i)] as? String
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
