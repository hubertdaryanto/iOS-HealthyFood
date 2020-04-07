//
//  ProfileVC.swift
//  HealthyFood
//
//  Created by Stevhen on 04/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var bmiView: UIView!
    @IBOutlet weak var planBtn: UIButton!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var updateWeightBtn: UIButton!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var calorieLeftLabel: UILabel!
    @IBOutlet weak var kcalBGView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kcalBGView.layer.cornerRadius = kcalBGView.frame.size.width / 2
        
        let objects: Any = [bmiView, heightView, weightView, updateWeightBtn, planBtn]
        applyRoundedCorner(objects as! [AnyObject])
    }
    
    func applyRoundedCorner(_ objects: [AnyObject]){
        for obj in objects {
            obj.layer.cornerRadius = 20
        }
    }
    
    @IBAction func updateWeightBtn(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
