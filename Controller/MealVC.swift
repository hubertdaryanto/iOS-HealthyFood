//
//  MealVC.swift
//  HealthyFood
//
//  Created by Stevhen on 07/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import UIKit

class MealVC: UIViewController {
    @IBOutlet weak var mealCollectionView: UICollectionView!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var preferredTimeLabel: UILabel!
    @IBOutlet weak var breakfastMeal: UIImageView!
    @IBOutlet weak var lunchMeal: UIImageView!
    @IBOutlet weak var dinnerMeal: UIImageView!
    @IBOutlet weak var breakfastSign: UIView!
    @IBOutlet weak var lunchSign: UIView!
    @IBOutlet weak var dinnerSign: UIView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var myMealCollectionView: UICollectionView!
    
    var name: String?
    
    var meals = Meal.getData()
    var temp = [Meal]()
    var type = ""
    var mealCount = 0
    var selectedMeal: Meal?
    var myMeals = [Meal]()
    var pos: Int?
    
    let mealViewIdentifier = "mealCell"
    let myMealViewIdentifier = "myMealCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = "Breakfast"
        pos = -1
        
        temp = Meal.getData()
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        myMealCollectionView.delegate = self
        myMealCollectionView.dataSource = self
        
        setupUI()
    }
    
    func makeRoundViewCorners() {
       let signs: Any = [breakfastSign, lunchSign, dinnerSign]
       let mealImages: Any = [breakfastMeal, lunchMeal, dinnerMeal]
       applyRoundedCorner(signs as! [AnyObject], value: 10.0)
       applyRoundedCorner(mealImages as! [AnyObject] , value: 20.0)
   }
    
    
    @IBAction func typeSegmentPressed(_ sender: Any) {
        meals = Meal.getData()
        switch typeSegmentedControl.selectedSegmentIndex {
        case 0: type = "Breakfast"; preferredTimeLabel.text = "06.00 AM - 10.00 AM"
        case 1: type = "Lunch"; preferredTimeLabel.text = "11.00 AM - 02.00 PM"
        case 2: type = "Dinner"; preferredTimeLabel.text = "05.00 PM - 08.00 PM"
            default: break;
        }
        
        var a = [Meal]()
        
        for x in 0 ..< meals.count {
            print(meals[x].type)
            if meals[x].type == type {
                a.append(meals[x])
            }
        }
        
        temp = a//bug nya disini
        mealCollectionView.reloadData()
    }
    
    func applyRoundedCorner(_ objects: [AnyObject], value: CGFloat){
        for obj in objects {
            obj.layer.cornerRadius =  value
        }
    }
    
    func checkMyMeal() -> Bool {
        let sec = ["Breakfast", "Lunch", "Dinner"]
        
        for i in 0 ..< 3 {
            return UserDefaults.standard.string(forKey: sec[i]) != nil
        }
        
        return false
    }
    
    func setupUI() {
//        makeRoundViewCorners()
        
        name = UserDefaults.standard.string(forKey: "name")
        let myName = name ?? "Siri"
        
        helloLabel.text = "Hello, " + myName
        
//        let timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { timer in
//            self.signByTime()
//        })
//        
//        timer.fire()
            
//        let images = [breakfastMeal, lunchMeal, dinnerMeal] as! [UIImageView]
//        let sec = ["Breakfast", "Lunch", "Dinner"]
//
//        for i in 0 ..< 3 {
//            if let url = URL(string: UserDefaults.standard.string(forKey: sec[i]) ?? "") {
//                if let data = try? Data(contentsOf: url) {
//                    images[i].image = UIImage(data: data)
//                }
//            }
//        }
    }
}

extension MealVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
   }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mealCollectionView {
            mealCount = 0
            for x in temp {
                if x.type == type {
                    mealCount += 1
                }
            }
            
            return mealCount
        } else {
            return 3
        }
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.mealCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealCell", for: indexPath) as! MealCell
            
            let meal = temp[indexPath.row]
            
            cell.meal = meal

            let url = URL(string: "\(meal.image)")
            let data = try? Data(contentsOf: url!)
            cell.image.image = UIImage(data: data!)
        
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myMealCell", for: indexPath) as! MyMealCell
            let sec = ["Breakfast", "Lunch", "Dinner"]
            myMeals = []
            
//            for i in 0 ..< 3 {
//                UserDefaults.standard.removeObject(forKey: sec[i])
//            }
            
            for i in 0 ..< 3 {
                if let imageLink = UserDefaults.standard.string(forKey: sec[i]) {
                    if let _meal = getMeal(imageURL: imageLink) {
                        myMeals.append(_meal)
                    }
                }
            }
            
            if !myMeals.isEmpty {
                print(indexPath.row)
                let meal = myMeals[indexPath.row]
                cell.meal = meal
                
                let url = URL(string: "\(meal.image)")
                let data = try? Data(contentsOf: url!)
                cell.myMealImageView.image = UIImage(data: data!)
                
                cell.myMealTimeSign.alpha = 0    
            }
            
            return cell
        }
    }
    
//    func signByTime() {
//        let date = Date()
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//
//        if hour >= 6 && hour <= 10 {
//            myMealTimeSign.alpha = 1.0
//        } else if hour >= 11 && hour <= 16 {
//            myMealTimeSign.alpha = 1.0
//        } else if hour >= 17 && hour <= 23 {
//            myMealTimeSign.alpha = 1.0
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetailVC" {
            let recipeDetailVC = segue.destination as! RecipeDetailVC
            recipeDetailVC.meal = selectedMeal
            recipeDetailVC.type = type
            
            recipeDetailVC.pos = pos
        } else if segue.identifier == "toProfileVC" {
            let profileVC = segue.destination as! ProfileVC
            profileVC.myMeals = myMeals
        }
    }
    
    func getMeal(imageURL: String) -> Meal? {
        var meal: Meal? = nil
        for i in meals {
            if i.image == imageURL {
                return i
            }
        }
        
        return meal
    }
}

extension MealVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.mealCollectionView {
            print(indexPath.row)
            
            selectedMeal = temp[indexPath.row]
            
            pos = 0
            performSegue(withIdentifier: "toRecipeDetailVC", sender: self)
        } else {
            print(indexPath.row)
            selectedMeal = myMeals[indexPath.row]
            
            pos = 1
            performSegue(withIdentifier: "toRecipeDetailVC", sender: self)
        }
    }
    
}

extension MealVC: MealDelegate {
    func didUpdateData(meals: [Meal]) {
        DispatchQueue.main.async {
            self.meals = meals
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
