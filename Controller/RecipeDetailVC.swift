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
   
    let sectionTitles = ["Ingredients", "How to Cook"]
    
    let foodsDetails = [FoodDetails(foodName: "Nasi Goreng", calories: 999, type: "Lunch", ingredients: ["bawang", "nasi", "kecap"], steps: ["a", "b"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionTitles[section] == "Ingredients" {
            
        }
        
        return 4 //angka sementara untuk jumlah rows
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableCell", for: indexPath)
        cell.textLabel?.text = "abc" //placeholder
        return cell
    }
    
}
