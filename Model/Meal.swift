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
        let image = ["https://img.buzzfeed.com/video-api-prod/assets/bd2e246b2883465abaad8fb68739f6db/BFV4562_CheesyEggToast-Thumb1080.jpg",
                     "https://gimmedelicious.com/wp-content/uploads/2016/07/avocado-toast-7-of-13-500x500.jpg",
                     "https://i.ytimg.com/vi/hvUPpz6rTno/hqdefault.jpg",
                     "https://static01.nyt.com/images/2016/11/29/dining/recipelab-chick-noodle-still/recipelab-chick-noodle-still-mediumThreeByTwo440.jpg",
                     "https://www.chinasichuanfood.com/wp-content/uploads/2014/02/bok-choy-stir-fryth-1-500x375.jpg",
                     "https://media-cdn.tripadvisor.com/media/photo-s/17/61/6a/4b/in-our-house-marbled.jpg",
                     "https://i.pinimg.com/474x/05/07/2d/05072d371ce2071beaf910f6b92088fc.jpg"]
        getUsersList()
        var mealfromweb = temp
        mealfromweb.append(Meal(name: "Egg Toast", calories: 123, type: "Breakfast", image: image[0], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Avocado Toast", calories: 124, type: "Breakfast", image: image[1], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Omellete", calories: 125, type: "Breakfast", image: image[2], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Chicken Soup", calories: 126, type: "Lunch", image: image[3], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Bok Choy", calories: 127, type: "Lunch", image: image[4], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Steak", calories: 128, type: "Dinner", image: image[5], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Rib", calories: 129, type: "Dinner", image: image[6], recipes: _recipes, howTo: _howTo))
        
        UserDefaults.standard.set(image[0], forKey: "Breakfast")
        UserDefaults.standard.set(image[3], forKey: "Lunch")
        UserDefaults.standard.set(image[6], forKey: "Dinner")
        
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
