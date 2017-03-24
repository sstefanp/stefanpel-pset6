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

    // Array for dictionary of current cocktail.
    var currentRandomCocktail: [String : Any]? = nil
    
    // MARK: - Outlets
    @IBOutlet weak var randomCocktailName: UILabel!
    @IBOutlet weak var randomCocktailImage: UIImageView!
    @IBOutlet weak var randomCocktailType: UILabel!
    
    
    override func viewDidLoad() {
        
        // If not logged in,
        if FIRAuth.auth()?.currentUser == nil
        {
            self.performSegue(withIdentifier: "login", sender: nil)
        }
        
        // Initialize navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
        
        // Get random cocktail.
        randomCocktail()
        
        super.viewDidLoad()
        
        // Image tapgesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        randomCocktailImage.addGestureRecognizer(tapGestureRecognizer)
        randomCocktailImage.isUserInteractionEnabled = true
    }
    
    // If random cocktail is tapped, go to single view.
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let cocktailClicked = currentRandomCocktail
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SCVC") as! SingleCocktailViewController
        
        viewController.currentCocktail = cocktailClicked
        
        // Present SingleCocktailViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Get image for random cocktail.
    func getCocktailImage() {
        guard let imageUrl = currentRandomCocktail?["strDrinkThumb"] as? String else { return }
        let url = NSURL(string: imageUrl.replacingOccurrences(of: "http:", with: "https:"))
        if let image = NSData(contentsOf: url as! URL) {
            guard let cocktailImage = UIImage(data: image as Data) else { return }
            self.randomCocktailImage.image = cocktailImage
        }
    }
    
    // Logging user out.
    @objc func logout() {
        try? FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "login", sender: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let viewController = SearchTableViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // Get random cocktail.
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
                        self.randomCocktailType.text = self.currentRandomCocktail?["strCategory"] as? String
                    }
                } catch {
                    print("Error")
                }
            }
        }).resume()
    }
}
