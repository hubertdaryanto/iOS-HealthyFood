//
//  MealCell.swift
//  HealthyFood
//
//  Created by Stevhen on 07/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import UIKit

class MealCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    var meal: Meal! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let meal = meal {
            name.text = meal.name
            calories.text = "\(meal.calories) cal"
            image.image = UIImage(named: meal.image)
        } else {
            name.text = nil
            calories.text = nil
            image.image = nil
        }
        
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
    }
    
    
}
