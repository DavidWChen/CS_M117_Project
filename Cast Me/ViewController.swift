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

    @IBOutlet var castMe: UIView!
    @IBOutlet var signIn: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var thisUser: GIDGoogleUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if any error stop execution and print error
        var error : NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        
        //adding the delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //getting the signin button and adding it to view
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.center.x = view.center.x
        googleSignInButton.center.y = view.center.y + 50
        //googleSignInButton.frame.origin = CGPoint(x: view.center.x, y: view.center.y)
        view.addSubview(googleSignInButton)
        
        GIDSignIn.sharedInstance().signOut()
        
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.thisUser = user
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

