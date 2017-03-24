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
    
    @IBOutlet weak var cocktailName: UILabel!
    //Measures
    @IBOutlet weak var measure1: UILabel!
    @IBOutlet weak var measure2: UILabel!
    @IBOutlet weak var measure3: UILabel!
    @IBOutlet weak var measure4: UILabel!
    @IBOutlet weak var measure5: UILabel!
    @IBOutlet weak var measure6: UILabel!
    //Ingredients
    @IBOutlet weak var ingredient1: UILabel!
    @IBOutlet weak var ingredient2: UILabel!
    @IBOutlet weak var ingredient3: UILabel!
    @IBOutlet weak var ingredient4: UILabel!
    @IBOutlet weak var ingredient5: UILabel!
    @IBOutlet weak var ingredient6: UILabel!
    @IBOutlet weak var instructions: UITextView!
    
    var currentCocktail: [String : Any]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func safetoBar(){
        // Safe this to bar
        guard let currentCocktail = currentCocktail else { return }
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        
        let ref  = FIRDatabase.database().reference()
        let item = ref.child("users/\(currentUser.uid)/cocktails").childByAutoId()
        item.setValue(currentCocktail)
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
