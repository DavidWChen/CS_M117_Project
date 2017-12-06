//
//  messageViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 12/1/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

var messages = [JSQMessage]()

class messageViewController: JSQMessagesViewController {
    
    var thisUser: GIDGoogleUser?
    var ref: FIRDatabaseReference?
    var channel_id: String?
    //var friendnum: Int?
    var friend_email: String?
    
    
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
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        observeMessages()
        
        var cleanEmail = (thisUser?.profile.email)?.replacingOccurrences(of: ".", with: ",")
        let plsemail : String = cleanEmail!
        var json: [String: Any]?
        json = readFirebase(urlstring: "users/"+plsemail+".json")
        //print(json)
        self.senderId = json!["id"] as! String
        
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 60, height: 30))
        button.backgroundColor = .black
        button.setTitle("Back", for: [])
        button.titleLabel?.textColor = UIColor.black
        button.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(button)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(observeee), userInfo: nil, repeats: true)
    }
    
    @objc func observeee() {
        print("observing")
        messages = [JSQMessage]()
        var json: [String: Any]?
        json = readFirebase(urlstring: "messages/"+channel_id!+".json")
        var num_messages = json!.count
        print(num_messages)
        
        var count = num_messages - 50
        if count < 1 {
            count = 1
        }
        while count < num_messages {
            let messageData = json!["msg"+String(count)] as! [String: Any]
            let id = messageData["senderId"] as! String
            let name = messageData["senderName"] as! String
            let text = messageData["text"] as! String
            
            self.addMessage(withId: id, name: name, text: text)
            count += 1
        }
        self.finishReceivingMessage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeMessages()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        let svc = generalProfileViewController()
        svc.thisUser = thisUser
        //svc.friendnum = friendnum
        svc.friend_email = friend_email
        svc.modalTransitionStyle = .crossDissolve
        //present(svc, animated: true, completion: nil)
        
        //present(generalProfileViewController(), animated: true, completion: nil)
        self.performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String?, date: Date!) {
        //let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName,
            "text": text!,
            ]
        
        var num_messages = 0
        var json: [String: Any]?
        json = readFirebase(urlstring: "messages/" + channel_id! + ".json")
        if json != nil {
            num_messages = json!.count
        }
        self.ref?.child("messages/" + channel_id! + "/msg" + String(num_messages)).setValue(messageItem)
        //itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage() // 5
    }
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    
    private func observeMessages() {
        messages = [JSQMessage]()
        var json: [String: Any]?
        json = readFirebase(urlstring: "messages/"+channel_id!+".json")
        var num_messages = json!.count
        
        var count = num_messages - 50
        if count < 1 {
            count = 1
        }
        while count < num_messages {
            let messageData = json!["msg"+String(count)] as! [String: Any]
            let id = messageData["senderId"] as! String
            let name = messageData["senderName"] as! String
            let text = messageData["text"] as! String
            
            self.addMessage(withId: id, name: name, text: text)
            count += 1
        }
        //self.finishReceivingMessage()

        /*
        //messageRef = channelRef!.child("messages")
        // 1.
        let newMsgRef = ref?.child("messages/"+channel_id!)//.child(channel_id!)
        let messageQuery = newMsgRef?.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        
        
        var newMessageRefHandle = messageQuery?.observe(.childAdded, with: { (snapshot) in
            // 3
            print(snapshot.value)
            let messageData = snapshot.value as! [String: Any]// Dictionary<String, String>
            if messageData["senderId"] as! String == "0" {
                print("into if")
                self.finishReceivingMessage()
            } else{
                print("into else")
                let id = messageData["senderId"] as! String
                let name = messageData["senderName"] as! String
                let text = messageData["text"] as! String
                
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            }
        })*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? generalProfileViewController {
            destination.thisUser = thisUser
            //destination.friendnum = friendnum
            destination.friend_email = friend_email
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
