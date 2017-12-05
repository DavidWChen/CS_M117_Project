 //
//  searchPageViewController.swift
//  Cast Me
//
//  Created by Siddhartha Bose on 11/19/17.
//  Copyright © 2017 CS_M117. All rights reserved.
//

import UIKit
import Firebase

 class searchPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var databaseRef = FIRDatabase.database().reference()
    
    //var searchActive : Bool = false
    
   // var data = ["Martin Kong","Sid Bose","David Chen","Gary Smith"]
  //  var filtered:[String] = []
    
   // var thisUser: GIDGoogleUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        databaseRef.child("users").queryOrdered(byChild: "name").observe(.childAdded, with: {(snapshot) in
            self.usersArray.append(snapshot.value as? NSDictionary)
            
            self.tableView.insertRows(at: [IndexPath(row:self.usersArray.count-1,section:0)], with: UITableViewRowAnimation.automatic)
            
        })
        { (error) in
            print(error.localizedDescription)
        }

       // tableView.delegate = self
       //// tableView.dataSource = self
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of PlayerTableViewController
        
        if let destination = segue.destination as? homePageViewController {
            destination.thisUser = thisUser
        } else if let destination = segue.destination as? generalProfileViewController {
            destination.thisUser = thisUser
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data.count)
        print(filtered.count)
        if !searchActive {
            print(searchBar.text as! String)
        }
        return 0
        if(searchActive) {
            return filtered.count
        }
        return data.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row];
        }
        
        return cell;
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateSearchResults(for searchController: UISearchController) {
        filterUsers(searchText: self.searchController.searchBar.text!)
    }
    
    func filterUsers (searchText:String) {
        self.filteredUsers = self.usersArray.filter{ user in
            
            let username = user!["Fornavn"] as? String
            
            return(username?.lowercased().contains(searchText.lowercased()))!
            
        }
        
        tableView.reloadData()
        
    }

}
