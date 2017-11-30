//
//  homePageViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/19/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class homePageViewController: UIViewController,CLLocationManagerDelegate {

    //var userEmail : String?
    var thisUser: GIDGoogleUser?
    let ref = FIRDatabase.database().reference()
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var Map: MKMapView!
    var user_latitude: Double?
    var user_longitude: Double?
    
    let manager = CLLocationManager()
    
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        user_latitude = location.coordinate.latitude
        user_longitude = location.coordinate.longitude
        let useremail = (thisUser?.profile.email)!
        let cleanEmail = useremail.replacingOccurrences(of: ".", with: ",")
        ref.child("gps_location/" + cleanEmail + "/latitude").setValue(user_latitude)
        ref.child("gps_location/" + cleanEmail + "/longitude").setValue(user_longitude)
        
        //write coordinates to firebase
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        Map.setRegion(region, animated: true)
        
        self.Map.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        let first = "Distance = "
        
        let Mycoordinate = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let distance = Mycoordinate.distance(from: Mycoordinate)/1609
        
        let distanceString = String(distance)
        let subtitle = first + distanceString + "mi"
        
        annotation.coordinate = myLocation
        annotation.title = "My Location"
        annotation.subtitle = subtitle
        
        Map.addAnnotation(annotation)
        
        /*let JohnsCoordinate = CLLocation(latitude: 37.7749, longitude:-122.4194)
        let JohnsLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.7749, -122.4194)

        
        let Johnsdistance = JohnsCoordinate.distance(from: Mycoordinate)/1609
        
        let JohnsdistanceString = String(format: "%0.2f", Johnsdistance)
        let Johnssubtitle = first + JohnsdistanceString + "mi"
        
        let annotation1 = MKPointAnnotation()

        annotation1.coordinate = JohnsLocation
        annotation1.title = "Johns Location"
        annotation1.subtitle = Johnssubtitle
        
        
        Map.addAnnotation(annotation1)*/
        

        var numFriends = 0
        var json: [String: Any]?
        json = readFirebase(urlstring: "friends_list.json")
        json = json![cleanEmail] as? [String: Any]
        numFriends = json!["friend_count"] as! Int
        
        var pins: [MKPointAnnotation] = []
        var emails = Array(repeating: "", count: numFriends)
        var titles = Array(repeating: "", count: numFriends)
        var subtitles = Array(repeating: "", count: numFriends)
        var coordinates = Array(repeating: CLLocation(), count: numFriends)
        var otherCoordinates = Array(repeating: CLLocationCoordinate2DMake(0.0,0.0), count: numFriends)
        
        var j = 0
        while (j < numFriends) //get emails
        {
            var json: [String: Any]?
            json = readFirebase(urlstring: "friends_list.json")
            json = json![cleanEmail] as? [String: Any]
            let k = "friend" + String(j)
            print(k)
            emails[j] = json![k] as! String //will fail if json![k] isnt a string
            print(emails[j])
            j = j+1
            
        }
        
        
        
        var t = 0
        while (t < numFriends) //set pin titles
        {
            var json: [String: Any]?
            json = readFirebase(urlstring: "users.json")
            json = json![emails[t]] as? [String: Any]
            titles[t] = json!["name"] as! String
            //print(pins[t].title)
            t = t+1
            
        }
        var i = 0
        while (i < numFriends) //get pin coordinates
        {
            var json: [String: Any]?
            json = readFirebase(urlstring: "gps_location.json")
            json = json![emails[i]] as? [String: Any]
            
            let lat = json!["latitude"] as! Double
            print(lat)
            let long = json!["longitude"] as! Double
            print(long)
            coordinates[i] = CLLocation(latitude: lat, longitude:long)
            otherCoordinates[i] = CLLocationCoordinate2DMake(lat, long)
            
            i = i+1
        }
        
        
        
        var a = 0
        while (a < numFriends) //calculate distances and set subtitle
        {
            
            
            let distance = coordinates[a].distance(from: Mycoordinate)/1609
            print(distance)
            let val = first + String(format: "%0.2f", distance) + "mi"
            subtitles[a] = val
            print (val)
            a = a+1
            
        }
        
        var z = 0
        while (z < numFriends) //add all annotations
        {
            let pointAnnotation = MKPointAnnotation()
            
            pointAnnotation.coordinate = otherCoordinates[z]
            pointAnnotation.title = titles[z]
            pointAnnotation.subtitle = subtitles[z]
            pins.append(pointAnnotation)
            z = z+1

        }
        Map.addAnnotations(pins)
       
        print("Im here")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("Loaded home view")
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        if thisUser == nil {
            self.performSegue(withIdentifier: "ToLogin", sender: self)
        }
        userName.setTitle(thisUser?.profile.name, for: .normal)
        let username = (thisUser?.profile.name)!
        let useremail = (thisUser?.profile.email)!
        
        let cleanEmail = useremail.replacingOccurrences(of: ".", with: ",")
        
        var json: [String: Any]?
        json = readFirebase(urlstring: "users.json")
        if (try json![cleanEmail] as? [String: Any]) == nil {
            self.ref.child("users/" + cleanEmail + "/name").setValue(username)
            self.ref.child("gps_location/" + cleanEmail + "/location1").setValue(0)
            self.ref.child("friends_list/" + cleanEmail + "/friend_count").setValue(0)
            self.ref.child("user_interests/" + cleanEmail + "/interests").setValue(0)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if thisUser == nil {
            self.performSegue(withIdentifier: "ToLogin", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of PlayerTableViewController
        
        if let destination = segue.destination as? searchPageViewController {
            destination.thisUser = thisUser
        } else if let destination = segue.destination as? myProfileViewController {
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
