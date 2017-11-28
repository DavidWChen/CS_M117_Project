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
    
    let manager = CLLocationManager()

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.04, 0.04)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
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
        
        let JohnsCoordinate = CLLocation(latitude: 37.7749, longitude:-122.4194)
        let JohnsLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.7749, -122.4194)

        
        let Johnsdistance = JohnsCoordinate.distance(from: Mycoordinate)/1609
        
        let JohnsdistanceString = String(format: "%0.2f", Johnsdistance)
        let Johnssubtitle = first + JohnsdistanceString + "mi"
        
        let annotation1 = MKPointAnnotation()

        annotation1.coordinate = JohnsLocation
        annotation1.title = "Johns Location"
        annotation1.subtitle = Johnssubtitle
        
        
        Map.addAnnotation(annotation1)
        
    
        
        /*  pull friend count
            instantiate array of annotations [friend count]
                for all my friends
                    pull their location coordinates
                            find distance from my coordinates
                            create an annotation.coordinate given their coordinate
                            create an annotation.title given their name
                            calculate distance from me using Mycoordinate
                            create an annotation.subtitle given their distance from me
        */
        
        let useremail = (thisUser?.profile.email)!
        let cleanEmail = useremail.replacingOccurrences(of: ".", with: ",")
        var numFriends = 0
        var done1 = false
        let urlRequest = URLRequest(url: URL(string: "https://fir-cast-me.firebaseio.com/friends_list.json")!)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            let responseData = data
            do {
                if let todoJSON = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]{
                    if let user = try todoJSON[cleanEmail] as? [String: Any] {
                        numFriends = user["friend_count"] as! Int
                    }
                }
            } catch {
                print("error")
                return
            }
        }).resume()
        while(!done1){
            
        }
        
        
        
        
        
        
        
        var pins:[MKPointAnnotation] = []
        var distances:[Int] = []
        var names:[String] = []
        var subtitles:[String] = []
        
        
        var a = 0
        while (a < numFriends)
        {
            //get friend[a] coordinate
            //let names[a] = friends name
            //let distances[a] = friend[a].distance(from: Mycoordinate)/1609
            //let subtitles[a] = first + String(format: "%0.2f", distances[a]) + "mi"
            //let pins[a].coordinate = gotten coordinate
            //let pins[a].title = names[a]
            //let pins[a].subtitle = subtitles[a]
            //Map.addAnnotation(pins[a])
            a = a+1
            
        }
        
    
        
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
        
        if thisUser != nil {
            userName.setTitle(thisUser?.profile.name, for: .normal)
        }
        
        var ref: FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        let username = (thisUser?.profile.name)!
        let useremail = (thisUser?.profile.email)!
        
        let cleanEmail = useremail.replacingOccurrences(of: ".", with: ",")
        
        var done1 = false
        let urlRequest = URLRequest(url: URL(string: "https://fir-cast-me.firebaseio.com/users.json")!)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            do {
                if let todoJSON = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                    if let user = try todoJSON[cleanEmail] as? [String: Any] {
                        done1 = true
                    } else {
                        ref?.child("users/" + cleanEmail + "/name").setValue(username)
                        ref?.child("gps_location/" + cleanEmail + "/location1").setValue(0)
                        ref?.child("friends_list/" + cleanEmail + "/friend_count").setValue(0)
                        ref?.child("user_interests/" + cleanEmail + "/interests").setValue(0)
                        done1 = true
                    }
                }
            } catch {
                print("error")
            }
        }).resume()
        while(!done1){}
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
