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
    
    let sectionTitles = ["Calories", "Ingredients", "How to Cook"]
    
    let foodsDetails = FoodDetails(foodName: "Nasi Goreng", calories: 999, type: "Lunch", ingredients: ["bawang", "nasi", "kecap"], steps: ["a", "b"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodNameLabel.text = foodsDetails.foodName
        recipeTable.delegate = self
        recipeTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipeDetailVC: UITableViewDelegate {
    //untuk tap" dari cell atau kerja dari cell
}

extension RecipeDetailVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionTitles[section] == "Calories" {
            return 1
        }
        else if sectionTitles[section] == "Ingredients" {
            return foodsDetails.ingredients.count
        }
        else if sectionTitles[section] == "How to Cook" {
            return foodsDetails.steps.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableCell", for: indexPath)
        
        switch sectionTitles[indexPath.section] {
        case "Calories":
            cell.textLabel!.text = "\(foodsDetails.calories) kcal"
        case "Ingredients":
            cell.textLabel!.text = "\(indexPath.row + 1). \(foodsDetails.ingredients[indexPath.row])"
        case "How to Cook":
            cell.textLabel!.text = "\(indexPath.row + 1). \(foodsDetails.steps[indexPath.row])"
        default:
            cell.textLabel!.text = "\(foodsDetails.calories) + kcal"
        }
        
        return cell
    }
    
}
