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
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    //label to display name of logged in user
    @IBOutlet weak var labelUserEmail: UILabel!
    
    
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
        
        if labelUserEmail == nil {
            GIDSignIn.sharedInstance().signOut()
        }
        
        if Name == nil {
            GIDSignIn.sharedInstance().signOut()
        }
        
    }
    
    //when the signin complets
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //if any error stop and print the error
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        //if success display the email on label
        //labelUserEmail.text = user.profile.email
        Name.text = user.profile.email
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

