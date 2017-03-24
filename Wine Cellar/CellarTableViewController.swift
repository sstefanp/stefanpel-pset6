//
//  CellarTableViewController.swift
//  Wine Cellar
//
//  Created by Stefan Pel on 21-03-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CellarTableViewController: UITableViewController {
    
    // Array for cocktails
    var myCocktails : [[String: Any]] = []

    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed(_:)))
        
        super.viewDidLoad()
        self.loadAllMyCocktail()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Go to search view.
    @IBAction func searchButtonPressed(_ sender: Any) {
        let viewController = SearchTableViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Function to retrieve all personal cocktails.
    func loadAllMyCocktail(){
        
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        let ref  = FIRDatabase.database().reference()
        let items = ref.child("users/\(currentUser.uid)/cocktails")
        
        var observer: FIRDatabaseHandle? = nil
        observer = items.observe(.value, with: { (snapshot) in
            if let observer = observer {
                items.removeObserver(withHandle: observer)
            }
            
            self.myCocktails.removeAll()
            
            // append over items in database and append.
            for item in snapshot.children {
                let item = item as! FIRDataSnapshot
                self.myCocktails.append(item.value as! [String : Any])
            }
        })
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCocktails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = myCocktails[indexPath.row]["strDrink"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cocktailClicked = myCocktails[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SCVC") as! SingleCocktailViewController
        viewController.currentCocktail = cocktailClicked

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
