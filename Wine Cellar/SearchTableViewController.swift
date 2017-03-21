//
//  SearchTableViewController.swift
//  Wine Cellar
//
//  Created by Stefan Pel on 21-03-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    let apiKey = "64e1087235e8283f90266b21b6ac947d"
    
    // Dictionary for searchResults
    var searchResults: [Dictionary<String, AnyObject>] = []
    
    // Initialize searchbar
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search for wine"
        self.navigationItem.titleView = searchBar
        
        self.tableView.register(SearchViewCell.self, forCellReuseIdentifier: "Search View Cell")
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonItemPressed))
        self.navigationItem.leftBarButtonItem = cancelItem
        
        let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonItemPressed))
        self.navigationItem.rightBarButtonItem = searchItem
        
    }
    
    // Search started
    func searchButtonItemPressed(_sender: UIBarButtonItem) {
        let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "+")
        wineSearch(text: searchText as String!)
        
        print (searchText as String!)
    }
    
    // Cancel search
    func cancelButtonItemPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        print ("clicked")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wineSearch(text: String) {
        let urlString = "https://services.wine.com/api/beta2/service.svc/JSON/catalog?search="+text+"&size=10&apikey=64e1087235e8283f90266b21b6ac947d"
        let request = URLRequest(url: URL(string: urlString)!)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                self.searchResults = []
                return
            }
            
            // Get access to the main thread and the interface elements:
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let info = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if info["Error"] != nil {
                        self.searchResults = []
                        print ("Error")
                    }
                    else {
                        // Fill dictionary with results
                        
                        print (self.searchResults)
                        self.searchResults = info["Status"]! as! [Dictionary<String, AnyObject>]
                    }
                } catch {
                    self.searchResults = []
                }
                self.tableView.reloadData()
            }
        }).resume()
        print (searchResults)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
