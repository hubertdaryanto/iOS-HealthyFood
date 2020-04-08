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
    
    var meals = [Meal]()
    var type = "Breakfast"
    var mealCount = 0
    
    func makeRoundViewCorners() {
        let signs: Any = [breakfastSign, lunchSign, dinnerSign]
        let mealImages: Any = [breakfastMeal, lunchMeal, dinnerMeal]
        applyRoundedCorner(signs as! [AnyObject], value: 10.0)
        applyRoundedCorner(mealImages as! [AnyObject] , value: 20.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        meals = Meal.fetchMeals()

        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        
        makeRoundViewCorners()
        
        let timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { timer in
            self.signByTime()
        })
        
        timer.fire()
        breakfastMeal.image = UIImage(named: meals[0].image)
        lunchMeal.image = UIImage(named: meals[1].image)
        dinnerMeal.image = UIImage(named: meals[2].image)
    }
    
    @IBAction func typeSegmentPressed(_ sender: Any) {
        meals = Meal.fetchMeals()
        
        switch typeSegmentedControl.selectedSegmentIndex {
        case 0: type = "Breakfast"; preferredTimeLabel.text = "06.00 AM - 10.00 AM"
        case 1: type = "Lunch"; preferredTimeLabel.text = "11.00 AM - 02.00 PM"
        case 2: type = "Dinner"; preferredTimeLabel.text = "05.00 PM - 08.00 PM"
            default: break;
        }
        
        var a = [Meal]()
        
        for x in 0 ..< meals.count {
            if meals[x].type == type {
                a.append(meals[x])
            }
        }
        
        meals = a
        mealCollectionView.reloadData()

    
//        meals = Meal.fetchMeals()
//
//        for x in 0 ..< mealCount {
//            if meals[x].type != type {
//                meals.remove(at: x)
//            }
//        }
//
//        mealCollectionView.reloadData()
    }
    
    func applyRoundedCorner(_ objects: [AnyObject], value: CGFloat){
        for obj in objects {
            obj.layer.cornerRadius =  value
        }
    }
    
    func signByTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 6 && hour <= 10 {
            breakfastSign.alpha = 1.0
        } else if hour >= 11 && hour <= 14 {
            lunchSign.alpha = 1.0
        } else if hour >= 17 && hour <= 23 {
            dinnerSign.alpha = 1.0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension MealVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
   }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mealCount = 0
        for x in meals {
            if x.type == type {
                mealCount += 1
            }
        }
        
        return mealCount
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealCell", for: indexPath) as! MealCell
        
        let meal = meals[indexPath.row]
    
        cell.meal = meal
    
        return cell
    }
}

extension MealVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
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
