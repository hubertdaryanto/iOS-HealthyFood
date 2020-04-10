//
//  PlanWeightVC.swift
//  HealthyFood
//
//  Created by Stevhen on 08/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import UIKit

class PlanWeightVC: UIViewController {
    
    @IBOutlet weak var currWeightLabel: UILabel!
    
    @IBOutlet weak var planKgLabel: UILabel!
    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var weightTargetTextField: UITextField!
    @IBOutlet weak var weightTargetOkBtn: UIButton!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var inMonthLabel: UILabel!
    @IBOutlet weak var weightTargetLabel: UILabel!
    
    var weight: String!
    var height: String!
    var plan: String!
    var pos: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currWeightLabel.text = weight
        planNameLabel.text = plan
        if plan == "Gain Weight" {
            planKgLabel.text = "Gain 0.00 kg/day"
        } else {
            planKgLabel.text = "Lose 0.00 kg/day"
        }
        
        setupUIs()
    }
    
    @IBAction func weightTargetOkDidPressed(_ sender: UIButton) {
        let target = weightTargetTextField.text!
        let plans = ["Gain", "Maintain", "Lose"]
        
        if validateInput(x: weightTargetTextField.text) {
            weightTargetTextField.resignFirstResponder()
        }
        
        if pos == 1 {
            //words
//            kg = 0.0
            weightTargetLabel.isHidden = true
            weightTargetTextField.isHidden = true
            weightTargetOkBtn.isHidden = true
            planKgLabel.isHidden = true
            inMonthLabel.isHidden = true
        }
        
        let kgDecimal = String(format: "%.2f", getPlan(weight: Double(weight)!, targetParam: Double(target)!, pos: pos))
        
        planKgLabel.text = "\(plans[pos]) \(kgDecimal) kg/day"
    }
    
    func showInputAlert(x: Int, y: Int){
        let alerts = ["must not be empty", "must be number", "must greater than zero"]
        let op = ["greater", "lower"]
        let pl = ["gain", "lose"]
        let message = ["Target field \(alerts[y])", "Target must be \(op[y]) than weight", "Ideally \(pl[y]) 4kg at max"]
        
        let alert = UIAlertController(title: "Warning", message: message[x], preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func getStartedBtnDidPressed(_ sender: Any) {
        UserDefaults.standard.set(weightTargetTextField.text, forKey: "target")
        UserDefaults.standard.synchronize()
        _ = validateInput(x: weightTargetTextField.text)
    }
    
    func getPlan(weight: Double, targetParam: Double, pos: Int) -> Double {
        var kg = -1.0
        
        if pos == 0 { //gain
            kg = (targetParam - weight) / 30.0
            
            if weight >= targetParam {
                showInputAlert(x: 1, y: 0)
                weightTargetTextField.text = String(format: "%.0f", weight)
            } else if targetParam > weight+4 {
                showInputAlert(x: 2, y: 0)
                weightTargetTextField.text = String(format: "%.0f", weight + 4.0)
                kg = ((weight+4) - weight) / 30
            }
        } else if pos == 2 { //lose
            kg = (weight - targetParam) / 30.0
            
            if weight <= targetParam {
                showInputAlert(x: 1, y: 1)
                weightTargetTextField.text = String(format: "%.0f", weight)
            } else if targetParam < weight-4 {
                showInputAlert(x: 2, y: 1)
                weightTargetTextField.text = String(format: "%.0f", weight - 4.0)
                kg = (weight - (weight-4)) / 30
            }
        }
        
        if kg < 0 {
            kg = 0.0
        }
        
        return kg
    }
    
    func validateInput(x : String?) -> Bool {
        var flag: Bool = false
        
        if x == nil || x == "" {
            showInputAlert(x: 0, y: 0)
        }
        else if !x!.isDouble {
            showInputAlert(x: 0, y: 1)
        }
        else if Double(x!)! < 0 {
            showInputAlert(x: 0, y: 2)
        }
        else {
            flag = true
        }
        
        return flag
    }
    
    func setupUIs(){
        weightTargetLabel.isHidden = false
        weightTargetTextField.isHidden = false
        weightTargetOkBtn.isHidden = false
        planKgLabel.isHidden = false
        inMonthLabel.isHidden = false
        
        weightTargetTextField.keyboardType = .asciiCapableNumberPad
        weightTargetTextField.underlined()
        getStartedBtn.layer.cornerRadius = 10
        weightTargetOkBtn.layer.cornerRadius = 10
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMealVC" {
            let mealVC = segue.destination as! MealVC
            mealVC.name = UserDefaults.standard.string(forKey: "name")
        }
    }

}
