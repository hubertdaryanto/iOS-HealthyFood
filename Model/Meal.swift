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
                    for items in meal{
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
        let _recipes = ["1 teaspoon macadamia oil", "250g pork fillet", "thinly sliced  200g peeled green prawns  2 garlic cloves", "crushed  1 teaspoon sambal oelek  2 teaspoons finely grated fresh ginger  200g green beans", "thinly sliced  1 bunch broccolini", "cut into 3cm lengths  1 large carrot", "peeled", "cut into matchsticks  355g (2 cups) cooked brown rice  2 tablespoons tomato puree", "2 teaspoon gluten-free salt-reduced soy sauce", "4 eggs", "1 tablespoon canola oil (or vegetable oil)", "1 small onion (white or yellow", "diced)", "1 egg", "1 clove garlic (minced) /n 3 green onions (diced)", "1/2 teaspoon cumin", "3/4 cup mushrooms (fresh", "diced small)", "1 (15-ounce) can pinto beans", "1 teaspoon parsley", "salt", "black pepper", "2 tablespoons oil"]
        let _howTo = ["In a large bowl, thoroughly mix all ingredients" , "Evenly form into 6 patties, each about 3 1/2 inches wide" , "Bring a grill pan (or large skillet) sprayed with nonstick spray to medium-high heat" , "Cook patties for 4 minutes per side, or until cooked to your preference, working in batches as needed."]
        let image = ["https://d2gtpjxvvd720b.cloudfront.net/system/recipe/image/1032/retina_hg-100-Calorie-Beef-Patties.jpg",           "https://img.taste.com.au/lJBhrDy5/w720-h480-cfill-q80/taste/2019/08/healthy-nasigoreng-p76-152834-2.jpg", "https://www.thespruceeats.com/thmb/nrYyvCEx_MInkaIj6Pu2WJ3hSxQ=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/vegan-mushroom-bean-burger-recipe-3378623-13_preview1-5b241897fa6bcc0036d2c9bf.jpeg", "https://img.taste.com.au/tuTwIC2l/w720-h480-cfill-q80/taste/2016/11/chicken-gado-gado-salad-105286-1.jpeg", "https://img-global.cpcdn.com/recipes/b057a5fbc1e8d961/1280x1280sq70/photo.jpg", "https://img.taste.com.au/CwL3WSZV/w720-h480-cfill-q80/taste/2016/11/mama-ks-kue-soes-88765-1.jpeg", "https://img.taste.com.au/2NcemqLG/w720-h480-cfill-q80/taste/2016/11/prawn-tom-yum-103777-1.jpeg", "https://www.thespruceeats.com/thmb/ULlFXvxW4UDsFJcLLZcACzKYc3Q=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/pork-chops-gravy-73110363-56a8c4655f9b58b7d0f4ef89.jpg" , "https://www.thespruceeats.com/thmb/fNAmRtg1qUyzP5oAUpOtyDfSRRE=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/classic-beef-stroganoff-3051443-11_preview-5afc96558e1b6e0036d49d3a.jpeg" , "https://www.thespruceeats.com/thmb/QV5oZWHOIvYW3TYfgsPV6Hl7PtU=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/basic-french-toast-3056820-10_preview-5b15a30404d1cf0037aaa15e.jpeg" , "https://img.taste.com.au/h0e_QQVy/w720-h480-cfill-q80/taste/2016/11/prawn-and-rice-noodles-87689-1.jpeg" , "https://www.thespruceeats.com/thmb/AjQEAatd8ropthQxlxN0p5zTd7s=/960x0/filters:no_upscale():max_bytes(150000):strip_icc()/breakfast-casserole-sausage-potato-18-56a8ba445f9b58b7d0f4a212.jpg"]
        
        getUsersList()
        var mealfromweb = temp
        mealfromweb.append(Meal(name: "Egg Toast", calories: 123, type: "Breakfast", image: image[0], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Avocado Toast", calories: 124, type: "Breakfast", image: image[1], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Omellete", calories: 125, type: "Breakfast", image: image[2], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Chicken Soup", calories: 126, type: "Lunch", image: image[3], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Bok Choy", calories: 127, type: "Lunch", image: image[4], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Steak", calories: 128, type: "Dinner", image: image[5], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Rib", calories: 129, type: "Dinner", image: image[6], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Rib", calories: 129, type: "Dinner", image: image[7], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Rib", calories: 129, type: "Dinner", image: image[8], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Rib", calories: 129, type: "Dinner", image: image[9], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Rib", calories: 129, type: "Dinner", image: image[10], recipes: _recipes, howTo: _howTo))
        mealfromweb.append(Meal(name: "Rib", calories: 129, type: "Dinner", image: image[11], recipes: _recipes, howTo: _howTo))
        
        UserDefaults.standard.set(image[0], forKey: "Breakfast")
        UserDefaults.standard.set(image[3], forKey: "Lunch")
        UserDefaults.standard.set(image[6], forKey: "Dinner")
        temp = mealfromweb
        return mealfromweb
    }
    
    static func getData() -> [Meal]
    {
        if temp.isEmpty{
            temp = fetchMeals()
        }
        let gotcha: [Meal] = temp
        return gotcha
    }
}
