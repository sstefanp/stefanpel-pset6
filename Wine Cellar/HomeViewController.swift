//
//  HomeViewController.swift
//  Wine Cellar
//
//  Created by Stefan Pel on 21-03-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {

    
    var currentRandomCocktail: [String : Any]? = nil
    
    // MARK: - Outlets
    @IBOutlet weak var randomCocktailName: UILabel!
    @IBOutlet weak var randomCocktailImage: UIImageView!
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed(_:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
        
        
        randomCocktail()
        
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser == nil
        {
            self.performSegue(withIdentifier: "login", sender: nil)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCocktailImage() {
        guard let imageUrl = currentRandomCocktail?["strDrinkThumb"] as? String else { return }
        let url = NSURL(string: imageUrl.replacingOccurrences(of: "http:", with: "https:"))
        if let image = NSData(contentsOf: url as! URL) {
            guard let cocktailImage = UIImage(data: image as Data) else { return }
            self.randomCocktailImage.image = cocktailImage
        }
    }
    
    @objc func logout() {
        
        // LOG USER OUT
        try? FIRAuth.auth()?.signOut()
        
        self.performSegue(withIdentifier: "login", sender: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let viewController = SearchTableViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func randomCocktail() {
        
        let url = "https://www.thecocktaildb.com/api/json/v1/1/random.php?"
        
        print (url)
        
        let request = URLRequest(url: URL(string: url)!)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                return
            }
            
            // Get access to the main thread and the interface elements:
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let info = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if info["Error"] != nil {
                        print ("Error")
                    }
                    else {
                        print (info)
                        guard let list = info["drinks"] as? [[String : Any]] else { return }
                        
                        self.currentRandomCocktail = list.first
                        
                        self.getCocktailImage()
                        self.randomCocktailName.text = self.currentRandomCocktail?["strDrink"] as? String
                    }
                } catch {
                    print("Boem")
                    //self.searchResults = []
                }
                //self.tableView.reloadData()
            }
        }).resume()
    }
    
    
    
    // Presenting SearchViewController
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
