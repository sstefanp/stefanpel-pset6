//
//  SearchTableViewController.swift
//  Wine Cellar
//
//  Created by Stefan Pel on 21-03-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // Dictionary for searchResults
    var searchResults: [[String : Any]] = []
    
    // Initialize searchbar
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.returnKeyType = .search
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search for cocktails"
        self.navigationItem.titleView = searchBar
        
        self.tableView.register(SearchViewCell.self, forCellReuseIdentifier: "Search View Cell")
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonItemPressed))
        self.navigationItem.leftBarButtonItem = cancelItem
        
        let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonItemPressed))
        self.navigationItem.rightBarButtonItem = searchItem
        
    }
    
    // MARK: - Search started function
    func searchButtonItemPressed(_sender: UIBarButtonItem) {
        let text = searchBar.text?.replacingOccurrences(of: " ", with: "+")
        cocktailSearch(text: text as String!)
        resignFirstResponder()
    }
    
    // MARK: - Cancel search function
    func cancelButtonItemPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Cocktail search function
    func cocktailSearch(text: String) {

        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s="+text
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
                        guard let list = info["drinks"] as? [[String : Any]] else { return }
                        self.searchResults = list
                    }
                } catch {
                    self.searchResults = []
                }
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search View Cell", for: indexPath)
        cell.textLabel?.text = self.searchResults[indexPath.row]["strDrink"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cocktailClicked = searchResults[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SCVC") as! SingleCocktailViewController
        
        viewController.currentCocktail = cocktailClicked
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
