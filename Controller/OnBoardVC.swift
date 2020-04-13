//
//  OnBoardVC.swift
//  HealthyFood
//
//  Created by Stevhen on 04/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import UIKit

class OnBoardVC: UIViewController {

    @IBOutlet weak var proceedBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Meal.fetchMeals()
        
//        let sec = ["Breakfast", "Lunch", "Dinner"]
//        for i in 0 ..< 3 {
//            UserDefaults.standard.removeObject(forKey: sec[i])
//        }
        self.proceedBtn.layer.cornerRadius = 20
    }
}
