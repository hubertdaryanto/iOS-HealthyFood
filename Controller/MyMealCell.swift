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
        } else {
            myMealImageView.image = nil
            myMealTimeSign.alpha = 0.0
        }
        
        myMealImageView.layer.cornerRadius = 10
        myMealImageView.layer.masksToBounds = true
        myMealTimeSign.layer.cornerRadius = 10
        myMealTimeSign.layer.masksToBounds = true
    }
}
