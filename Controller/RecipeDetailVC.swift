//
//  RecipeDetailVC.swift
//  HealthyFood
//
//  Created by Stevhen on 04/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import UIKit

class RecipeDetailVC: UIViewController {
    
    @IBOutlet var recipeTable: UITableView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var addToMyMealButton: UIButton!
    
    let sectionTitles = ["Calories", "Ingredients", "How to Cook"]
    var meal: Meal!
    var type: String!
    var pos: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToMyMealButton.isHidden = false
        foodNameLabel.text = meal.name
        
        recipeTable.delegate = self
        recipeTable.dataSource = self
        
        let url = URL(string: "\(meal.image)")
        let data = try? Data(contentsOf: url!)
        foodImage.image = UIImage(data: data!)
        if pos == 1 {
            addToMyMealButton.isHidden = true
        }
        else
        {
            addToMyMealButton.isHidden = false
        }
        pos = 0
        
        addToMyMealButton.layer.cornerRadius = 16
    }
    
    @IBAction func addToMealBtnDidPressed(_ sender: Any) {
        
        UserDefaults.standard.set(meal.image, forKey: type!)
        performSegue(withIdentifier: "toMealVC", sender: self)
    }
}

extension RecipeDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionTitles[section] == "Calories" {
            return 1
        }
        else if sectionTitles[section] == "Ingredients" {
            return meal.ingredients.count
        }
        else if sectionTitles[section] == "How to Cook" {
            return meal.steps.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 0.92, green: 0.42, blue: 0.34, alpha: 1.0)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0;
        
        switch sectionTitles[indexPath.section] {
        case "Calories":
            cell.textLabel!.text = "\(meal.calories) cal"
        case "Ingredients":
            cell.textLabel!.text = "\(meal.ingredients[indexPath.row])"
        case "How to Cook":
            cell.textLabel!.text = "\(meal.steps[indexPath.row])"
        default:
            cell.textLabel!.text = "\(meal.calories) + cal"
        }
        
        return cell
    }
}
