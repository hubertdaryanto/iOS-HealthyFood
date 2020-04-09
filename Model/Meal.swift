//
//  Meal.swift
//  HealthyFood
//
//  Created by Stevhen on 07/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import Foundation

protocol MealDelegate {
    func didUpdateData(meals: [Meal])
    func didFailWithError(error: Error)
}

class Meal {
    var name: String
    var calories: Int
    var type: String
    var image: String
    var recipes: [String]
    var howTo: [String]
    
    var delegate: MealDelegate?
    
    let baseURL = "https://"
    let apiKey = ""
    
    private init(name: String, calories: Int, type: String, image: String, recipes: [String], howTo: [String]) {
        self.name = name
        self.calories = calories
        self.type = type
        self.image = image
        self.recipes = recipes
        self.howTo = howTo
    }
    
    /*
    // MARK: - Note
     
    //consider use param for filtered type and add var for urlString
     
    */

    func getMeals() {
        
        let urlString = "\(baseURL)/?apikey=\(apiKey)"

        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let meal = self.parseJSON(safeData) {
                        
                        self.delegate?.didUpdateData(meals: [meal])
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Meal? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MealData.self, from: data)
            
            let name = decodedData.name
            let image = decodedData.image
            let recipes = decodedData.recipes
            let calories = decodedData.calories
            let howTo = decodedData.howTo
            let type = decodedData.type
            
            return Meal(name: name, calories: calories, type: type, image: image, recipes: recipes, howTo: howTo)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    static func fetchMeals() -> [Meal] {
        let _recipes = ["a", "b"]
        let _howTo = ["c", "d"]
        
        return [
            Meal(name: "Egg Toast", calories: 123, type: "Breakfast", image: "p1", recipes: _recipes, howTo: _howTo),
            Meal(name: "Avocado Toast", calories: 124, type: "Breakfast", image: "p2", recipes: _recipes, howTo: _howTo),
            Meal(name: "Omellete", calories: 125, type: "Breakfast", image: "p3", recipes: _recipes, howTo: _howTo),
            Meal(name: "Chicken Soup", calories: 126, type: "Lunch", image: "p4", recipes: _recipes, howTo: _howTo),
            Meal(name: "Bonk Choy", calories: 127, type: "Lunch", image: "p5", recipes: _recipes, howTo: _howTo),
            Meal(name: "Steak", calories: 128, type: "Dinner", image: "p6", recipes: _recipes, howTo: _howTo),
            Meal(name: "Rib", calories: 129, type: "Dinner", image: "p2", recipes: _recipes, howTo: _howTo),
        ]
    }
}
