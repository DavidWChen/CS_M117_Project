//
//  messageViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 12/1/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import SendBirdSDK  // Swift
import Firebase


class messageViewController: UIViewController {
    var thisUser: GIDGoogleUser?
    var ref: FIRDatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.connect()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func connect(){
        SBDMain.connect(withUserId: (thisUser?.profile.email)!, completionHandler: { (user, error) in
            if error != nil {
                return
            }
        })
        let query = SBDOpenChannel.createOpenChannelListQuery()!
        query.loadNextPage(completionHandler: { (channels, error) in
            if error != nil {
                NSLog("Error: %@", error!)
                return
            }
            
            // ...
        })
        SBDOpenChannel.getWithUrl("Chat") { (channel, error) in
            if error != nil {
                NSLog("Error: %@", error!)
                return
            }
            
            channel?.enter(completionHandler: { (error) in
                if error != nil {
                    NSLog("Error: %@", error!)
                    return
                }
                
                // ...https://docs.sendbird.com/ios#open_channel
            })
        }
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
