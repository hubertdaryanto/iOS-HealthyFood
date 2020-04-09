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
    @IBOutlet weak var nameLabel: UILabel!
    var updateWeightTextField: UITextField!

    let calories: Int = 3000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kcalBGView.layer.cornerRadius = kcalBGView.frame.size.width / 2
        
        let objects: Any = [bmiView, heightView, weightView, updateWeightBtn, planBtn]
        applyRoundedCorner(objects as! [AnyObject])
        
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")
        let height = defaults.string(forKey: "height")
        let weight = defaults.string(forKey: "weight")
        let gender = defaults.string(forKey: "gender")
        let bmi = defaults.string(forKey: "bmi")
        
        nameLabel.text = "Hello, " + name!
        planBtn.setTitle(defaults.string(forKey: "plan"), for: .normal)
        heightLabel.text = height
        weightLabel.text = weight
        
        bmiLabel.text = String(format: "%.1f", (bmi! as NSString).doubleValue)
        calorieLeftLabel.text = gender == "Male" ? "\(calories)" : "\(calories - 1000)"
    }
    
    func applyRoundedCorner(_ objects: [AnyObject]){
        for obj in objects {
            obj.layer.cornerRadius = 20
        }
    }
    
    func showInputAlert() {
        let dialogMessage = UIAlertController(title: "Update Weight", message: nil, preferredStyle: .alert)
        let messagelabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height:15))
        messagelabel.textAlignment = .center
        messagelabel.textColor = .red
        messagelabel.font = messagelabel.font.withSize(12)
        dialogMessage.view.addSubview(messagelabel)
        messagelabel.isHidden = true

        let create = UIAlertAction(title: "Update", style: .default, handler: { (action) -> Void in
            if let weightInput = self.updateWeightTextField!.text {
                messagelabel.text = ""
                messagelabel.isHidden = false
                if weightInput == "" {
                    messagelabel.text = "Please enter weight"
                }
                else if (weightInput as NSString).doubleValue < 0 {
                    messagelabel.text = "must greater than zero"
                }
                else if (weightInput as NSString).doubleValue <= 20 {
                    messagelabel.text = "must greater than 20 kg"
                }
                
                if messagelabel.text != "" {
                    self.present(dialogMessage, animated: true, completion: nil)
                } else {
                    UserDefaults.standard.set(weightInput, forKey: "weight")
                    UserDefaults.standard.synchronize()
                    self.weightLabel.text = weightInput
                }

            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
            print("Cancel button tapped")
        }

        dialogMessage.addAction(cancel)
        dialogMessage.addAction(create)
        
        dialogMessage.addTextField { (textField) -> Void in
            self.updateWeightTextField = textField
            self.updateWeightTextField?.placeholder = "Please enter weight"
        }

        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func updateWeightBtn(_ sender: Any) {
        showInputAlert()
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
