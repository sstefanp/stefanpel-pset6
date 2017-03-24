//
//  SingleCocktailViewController.swift
//  Wine Cellar
//
//  Created by Stefan Pel on 23-03-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SingleCocktailViewController: UIViewController {
    
    // MARK: - Oulets
    
    // Name
    @IBOutlet weak var cocktailName: UILabel!
    //Measures
    @IBOutlet weak var measure1: UILabel!
    @IBOutlet weak var measure2: UILabel!
    @IBOutlet weak var measure3: UILabel!
    @IBOutlet weak var measure4: UILabel!
    @IBOutlet weak var measure5: UILabel!
    @IBOutlet weak var measure6: UILabel!
    // Ingredients
    @IBOutlet weak var ingredient1: UILabel!
    @IBOutlet weak var ingredient2: UILabel!
    @IBOutlet weak var ingredient3: UILabel!
    @IBOutlet weak var ingredient4: UILabel!
    @IBOutlet weak var ingredient5: UILabel!
    @IBOutlet weak var ingredient6: UILabel!
    @IBOutlet weak var instructions: UITextView!
    
    // Image
    @IBOutlet weak var image: UIImageView!
    
    var currentCocktail: [String : Any]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        getCocktailImage()
        // Fill all labels with ingredients, measures, name and instructions.
        cocktailName.text = self.currentCocktail?["strDrink"] as? String
        instructions.text = self.currentCocktail?["strInstructions"] as? String
        measure1.text = self.currentCocktail?["strMeasure1"] as? String
        measure2.text = self.currentCocktail?["strMeasure2"] as? String
        measure3.text = self.currentCocktail?["strMeasure3"] as? String
        measure4.text = self.currentCocktail?["strMeasure4"] as? String
        measure5.text = self.currentCocktail?["strMeasure5"] as? String
        measure6.text = self.currentCocktail?["strMeasure6"] as? String
        
        ingredient1.text = self.currentCocktail?["strIngredient1"] as? String
        ingredient2.text = self.currentCocktail?["strIngredient2"] as? String
        ingredient3.text = self.currentCocktail?["strIngredient3"] as? String
        ingredient4.text = self.currentCocktail?["strIngredient4"] as? String
        ingredient5.text = self.currentCocktail?["strIngredient5"] as? String
        ingredient6.text = self.currentCocktail?["strIngredient6"] as? String
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(safetoBar))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Function to retrieve cocktail image.
    func getCocktailImage() {
        guard let imageUrl = currentCocktail?["strDrinkThumb"] as? String else { return }
        
        let url = NSURL(string: imageUrl.replacingOccurrences(of: "http:", with: "https:"))
        if let image = NSData(contentsOf: url as! URL) {
            guard let cocktailImage = UIImage(data: image as Data) else { return }
            self.image.image = cocktailImage
        }
    }
    
    // MARK: - Function to save cocktail to own cocktailbar.
    func safetoBar(){
        guard let currentCocktail = currentCocktail else { return }
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        
        // Add to database.
        let ref  = FIRDatabase.database().reference()
        let item = ref.child("users/\(currentUser.uid)/cocktails").childByAutoId()
        item.setValue(currentCocktail)
        self.dismiss(animated: true, completion: nil)
    }
}
