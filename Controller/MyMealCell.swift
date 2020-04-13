//
//  MyMealCell.swift
//  HealthyFood
//
//  Created by Stevhen on 13/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import UIKit

class MyMealCell: UICollectionViewCell {
    @IBOutlet weak var myMealImageView: UIImageView!
    @IBOutlet weak var myMealTimeSign: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    var meal: Meal! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        myMealTimeSign.alpha = 0
        
        if let meal = meal {
            myMealImageView.image = UIImage(named: meal.image)
            myMealTimeSign.alpha = 1
        } else {
            myMealImageView.image = nil
            myMealTimeSign.alpha = 0.0
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { timer in
            self.signByTime()
        })
        
        timer.fire()
        
        myMealImageView.layer.cornerRadius = 10
        myMealImageView.layer.masksToBounds = true
        myMealTimeSign.layer.cornerRadius = 20
        myMealTimeSign.layer.masksToBounds = true
    }
    
    func signByTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 6 && hour <= 10 {
            myMealTimeSign.alpha = 1.0
        } else if hour >= 11 && hour <= 14 {
            myMealTimeSign.alpha = 1.0
        } else if hour >= 17 && hour <= 23 {
            myMealTimeSign.alpha = 1.0
        }
    }
}
