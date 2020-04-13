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

let rest = RestManager()
struct NewMeal: Codable {
    var id: String?
    var foodName: String?
    var calories: Int?
    var imageURL: String?
    var type: String?
    var ingredients: String?
    var steps: String?
}

struct ArraytoReturn {
    var foodName: String?
    var calories: Int?
    var imageURL: String?
    var type: String?
    var ingredients: [String?]
    var steps: [String?]
}

var temp : [Meal] = []

func getUsersList(){
    guard let url = URL(string: "http://127.0.0.1:5000/meal/") else { return }
        
   //        rest.urlQueryParameters.add(value: "10", forKey: "page")
       
            rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
                   if let data = results.data {
                       
                       let decoder = JSONDecoder()
                       decoder.keyDecodingStrategy = .convertFromSnakeCase
                       guard let meal = try? decoder.decode([NewMeal].self, from: data) else { return }
                       //kita coba pisahin ingredients dan steps secara manual dipisahkan dengan \n
                        temp.removeAll()
                    for items in meal[16...27]{
                           let ingredientitems = items.ingredients!.components(separatedBy: " \\n ")
                           let stepsitems = items.steps!.components(separatedBy: " \\n ")
                        temp.append(Meal(name: items.foodName!, calories: items.calories!, type: items.type!, image: items.imageURL!, recipes: ingredientitems, howTo: stepsitems))
                       }
                   }
                   print("\n\nResponse HTTP Headers:\n")
                   if let response = results.response {
                       for (key, value) in response.headers.allValues() {
                           print(key, value)
                       }
                   }
                
           }
        }

class Meal {
    var name: String
    var calories: Int
    var type: String
    var image: String
    var ingredients: [String]
    var steps: [String]
    
    var delegate: MealDelegate?
    
    let baseURL = "http://127.0.0.1:5000/meal/"
    let apiKey = ""
    
    init(name: String, calories: Int, type: String, image: String, recipes: [String], howTo: [String]) {
        self.name = name
        self.calories = calories
        self.type = type
        self.image = image
        self.ingredients = recipes
        self.steps = howTo
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
        let image = "https://www.masakapahariini.com/wp-content/uploads/2019/01/nasi-goreng-jawa-620x440.jpg"
        getUsersList()
        var mealfromweb = temp
        mealfromweb.append(Meal(name: "Egg Toast", calories: 123, type: "Breakfast", image: image, recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Avocado Toast", calories: 124, type: "Breakfast", image: image, recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Omellete", calories: 125, type: "Breakfast", image: image, recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Chicken Soup", calories: 126, type: "Lunch", image: image, recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Bonk Choy", calories: 127, type: "Lunch", image: image, recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Steak", calories: 128, type: "Dinner", image: image, recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Rib", calories: 129, type: "Dinner", image: image, recipes: _recipes, howTo: _howTo))
        return mealfromweb
    }
    
    static func getData() -> [Meal]
    {
        if temp .isEmpty{
            temp = fetchMeals()
        }
        let gotcha: [Meal] = temp
        return gotcha
    }
}
