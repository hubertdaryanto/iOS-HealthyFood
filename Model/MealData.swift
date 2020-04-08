//
//  MealData.swift
//  HealthyFood
//
//  Created by Stevhen on 07/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import Foundation

struct MealData: Decodable {
    let name: String
    let image: String
    let type: String
    let calories: Int
    let recipes: [String]
    let howTo: [String]
}
