//
//  ViewController.swift
//  Cast Me
//
//  Created by Martin Kong on 11/13/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var confirm: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmText: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    //label to display name of logged in user
    var labelUserEmail = ""
    
    var thisUser: GIDGoogleUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //error object
        var error : NSError?
        
        //setting the error
        GGLContext.sharedInstance().configureWithError(&error)
        
        //if any error stop execution and print error
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        
        //adding the delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //getting the signin button and adding it to view
        let googleSignInButton = GIDSignInButton()
        //googleSignInButton.center = view.center
        googleSignInButton.frame.origin = CGPoint(x: view.center.x, y: view.center.y - 200)
        view.addSubview(googleSignInButton)
        
        if labelUserEmail == "" {
            GIDSignIn.sharedInstance().signOut()
        }
        
        if Name == nil {
            GIDSignIn.sharedInstance().signOut()
        }
        
        nextButton.isEnabled = false
        
    }
    
    //when the signin complets
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //if any error stop and print the error
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        thisUser = user
        nextButton.isEnabled = true
        print("Sign in successful")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if thisUser != nil {
            self.performSegue(withIdentifier: "ToHome", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of PlayerTableViewController
        
        if let destination = segue.destination as? homePageViewController {
            destination.thisUser = thisUser
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func nextButtonHome(_ sender: Any) {
    print("Next button used")
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
}

