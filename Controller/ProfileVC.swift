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
    @IBOutlet weak var planLabel: UILabel!
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

    var calories: Int = 0
    var flag: Int = 0
    let defaults = UserDefaults.standard
    
    var myMeals: [Meal]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kcalBGView.layer.cornerRadius = kcalBGView.frame.size.width / 2
        calories = 3000
        
        let objects: Any = [bmiView, heightView, weightView, updateWeightBtn, planBtn]
        applyRoundedCorner(objects as! [AnyObject])
        
        let name = defaults.string(forKey: "name")
        let height = defaults.string(forKey: "height")
        let target = defaults.string(forKey: "target")
        let plan = defaults.string(forKey: "plan")
        let weight = defaults.string(forKey: "weight")
        let gender = defaults.string(forKey: "gender")
        let bmi = defaults.string(forKey: "bmi")
        
        nameLabel.text = "Hello, " + name!
        planLabel.text = plan! + " Plan"
        
        if plan ==  "Maintain Weight" {
            planBtn.isHidden = true
        } else {
            planBtn.isHidden = false
        }
        
        planBtn.setTitle(String(format: "%.0f kg / Month", abs((target! as NSString).doubleValue - (weight! as NSString).doubleValue)), for: .normal)
        
        heightLabel.text = height
        weightLabel.text = weight
        
        bmiLabel.text = String(format: "%.1f", (bmi! as NSString).doubleValue)
        calorieLeftLabel.text = gender == "Male" ? "\(calcCalleft())" : "\(calcCalleft() - 1000)"
    }
    
    func getMeal(imageURL: String) -> Meal? {
        var meal: Meal? = nil
        for i in myMeals {
            if i.image == imageURL {
                return i
            }
        }
        
        return meal
    }
    
    func calcCalleft() -> Int {
        var theCal = 0
        for i in 0 ..< 3 {
            theCal += myMeals[i].calories
        }
        
        return (calories - theCal)
    }
    
    fileprivate func formBtnTitle(_ kg: Double) -> String {
        flag = flag == 0 ? 1 : 0
        return flag == 1 ? String(format: "%.2f kg / Day", (kg / 30.0)) : String(format: "%.0f kg / Month", kg)
    }
    
    @IBAction func planBtnDidPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        let target = defaults.string(forKey: "target")
        let weight = defaults.string(forKey: "weight")
        let kg = abs((target! as NSString).doubleValue - (weight! as NSString).doubleValue)
        
        planBtn.setTitle(formBtnTitle(kg), for: .normal)
    }
    
    func applyRoundedCorner(_ objects: [AnyObject]){
        for obj in objects {
            obj.layer.cornerRadius = 20
        }
    }
    
    func getMessage(weight: Double,targetParam: Double, pos: Int, originWeight: Double) -> String {
        var message = ""
        
        if pos == 0 { //gain
           if weight > targetParam {
                message = "Ideally 4 kg at max"
            }
           else if weight < originWeight {
            message = "must more than original weight"
            }
        } else if pos == 2 { //lose
            if weight < targetParam {
                message = "Ideally 4 kg at max"
            }
            else if weight > originWeight {
                message = "must less than original weight"
            }
        }
    
        return message
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
                
                messagelabel.text = weightInput == "" ? "Please enter weight" : (weightInput as NSString).doubleValue < 0 ? "must greater than zero" : (weightInput as NSString).doubleValue <= 20 ? "must greater than 20 kg" : ""
                
                let defaults = UserDefaults.standard
                let plan = defaults.string(forKey: "plan")
                print(plan)
                var pos = -1
                
                if plan == "Gain Weight" {
                    pos = 0
                } else if plan == "Maintain Weight" {
                    pos = 1
                } else if plan == "Lose Weight" {
                    pos = 2
                }
                print(pos)
                
                let currTargetDouble = (defaults.string(forKey: "target")! as NSString).doubleValue
                let currWeightDouble = (defaults.string(forKey: "weight")! as NSString).doubleValue
                messagelabel.text = self.getMessage(weight: (weightInput as NSString).doubleValue, targetParam: currTargetDouble, pos: pos, originWeight: currWeightDouble)
                print(messagelabel.text)
                
                if messagelabel.text != "" {
                    self.present(dialogMessage, animated: true, completion: nil)
                } else {
                    UserDefaults.standard.set(weightInput, forKey: "weight")
                    
                    let weightDouble = (UserDefaults.standard.string(forKey: "weight")! as NSString).doubleValue
                    let heightDouble = (UserDefaults.standard.string(forKey: "height")! as NSString).doubleValue
                    let bmi = self.calcBMI(weight: weightDouble, height: heightDouble / 100.0)
                    UserDefaults.standard.set(bmi, forKey: "bmi")
                    UserDefaults.standard.synchronize()
                    
                    let target = UserDefaults.standard.string(forKey: "target")
                    let weight = UserDefaults.standard.string(forKey: "weight")
                    let kg = abs((target! as NSString).doubleValue - (weight! as NSString).doubleValue)
                    
                    self.planBtn.setTitle(String(format: "%.0f kg / Month", kg), for: .normal)
                    let _bmi = (UserDefaults.standard.string(forKey: "bmi")! as NSString).doubleValue
                    
                    self.bmiLabel.text = String(format: "%.1f", _bmi)
                    self.weightLabel.text = weightInput

                }

            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)

        dialogMessage.addAction(cancel)
        dialogMessage.addAction(create)
        
        dialogMessage.addTextField { (textField) -> Void in
            self.updateWeightTextField = textField
            self.updateWeightTextField?.placeholder = "Please enter weight"
        }

        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func calcBMI(weight: Double, height: Double) -> Double {
        let bmiValue = weight / pow(height, 2)
        return bmiValue
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
