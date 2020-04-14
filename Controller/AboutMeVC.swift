//
//  AboutMeVC.swift
//  HealthyFood
//
//  Created by Stevhen on 04/04/20.
//  Copyright © 2020 Stevhen. All rights reserved.
//

import UIKit

class AboutMeVC: UIViewController {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var gainWeightBtn: UIButton!
    @IBOutlet weak var maintainWeightBtn: UIButton!
    @IBOutlet weak var loseWeightBtn: UIButton!
    
    let genders = ["Male","Female"]
    var pos: Int!
    
    var genderPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let objects: Any = [gainWeightBtn,maintainWeightBtn, loseWeightBtn, aboutView]
        applyRoundedCorner(objects as! [AnyObject])
        
        let textFields: Any = [nameTextField, heightTextField, weightTextField, genderTextField]
        applyUnderline(textFields as! [UITextField])
        
        self.genderTextField.delegate = self
        heightTextField.keyboardType = .asciiCapableNumberPad
        weightTextField.keyboardType = .asciiCapableNumberPad
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        tap.cancelsTouchesInView = false
        self.hideKeyboardWhenTappedAround()

        view.addGestureRecognizer(tap)
        
        nameTextField.text = UserDefaults.standard.string(forKey: "name") ?? ""
        genderTextField.text = UserDefaults.standard.string(forKey: "gender") ?? ""
        heightTextField.text = UserDefaults.standard.string(forKey: "height") ?? ""
        weightTextField.text = UserDefaults.standard.string(forKey: "weight") ?? ""
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        genderPickerView.reloadAllComponents()
    }
    
    @IBAction func planDidPressed(_ sender: UIButton) {
        var plan = ""
        
        if sender == gainWeightBtn {
            plan = "Gain Weight"
        } else if sender == maintainWeightBtn {
            plan = "Maintain Weight"
        } else if sender == loseWeightBtn {
            plan = "Lose Weight"
        }
        
        let textFields: [UITextField] = [nameTextField, genderTextField, heightTextField, weightTextField] as! [UITextField]
        
        for i in 0 ..< 4 {
            if validateInput(x: textFields[i].text, y: i) {
                textFields[i].resignFirstResponder()
            }
        }
        
        let name = nameTextField.text
        let height = heightTextField.text
        let weight = weightTextField.text
        let gender = genderTextField.text
        
        let weightDouble = (weight! as NSString).doubleValue
       let heightDouble = (height! as NSString).doubleValue
        
        let defaults = UserDefaults.standard
        defaults.set(plan, forKey: "plan")
        defaults.set(name?.capitalizeFirstChar(), forKey: "name")
        defaults.set(gender, forKey: "gender")
        defaults.set(height, forKey: "height")
        defaults.set(weight, forKey: "weight")
        
        let bmi = calcBMI(weight: weightDouble, height: heightDouble / 100.0)
        defaults.set(bmi, forKey: "bmi")
        defaults.synchronize()
        
        pos = sender.tag
        
        performSegue(withIdentifier: "toPlanWeightVC", sender: self)
    }
    
    func calcBMI(weight: Double, height: Double) -> Double {
        let bmiValue = weight / pow(height, 2)
        return bmiValue
    }
    
    func showInputAlert(x: Int, pos: Int){
        let alerts = ["must not be empty", "must be number", "must greater than zero"]
        let fields = ["Name", "Gender", "Height", "Weight"]
        
        let alert = UIAlertController(title: "Warning", message: "\(fields[pos]) field \(alerts[x])", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateInput(x : String?, y: Int) -> Bool {
        var flag: Bool = false
        
        if x == nil || x == "" {
            showInputAlert(x: 0, pos: y)
        }
        else if y >= 2 {
            if !x!.isDouble {
                showInputAlert(x: 1, pos: y)
            }
            else if Double(x!)! < 0 {
                showInputAlert(x: 2, pos: y)
            }
        }
        else {
            flag = true
        }
        
        return flag
    }
    
    func applyRoundedCorner(_ objects: [AnyObject]){
        for obj in objects {
            obj.layer.cornerRadius = 20
        }
    }
    
    func applyUnderline(_ objects: [UITextField]){
        for obj in objects {
            obj.underlined()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let planWeightVC = segue.destination as? PlanWeightVC else { return }
        
        planWeightVC.weight = UserDefaults.standard.string(forKey: "weight")
        planWeightVC.height = UserDefaults.standard.string(forKey: "height")
        planWeightVC.plan = UserDefaults.standard.string(forKey: "plan")
        planWeightVC.pos = pos
    }
}

extension String {
    var isDouble: Bool {
        return Double(self) != nil
    }
}

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension AboutMeVC: UITextFieldDelegate {
    func pickUp(_ textField : UITextField){
        self.genderPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        self.genderPickerView.backgroundColor = UIColor.white
        textField.inputView = self.genderPickerView

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AboutMeVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AboutMeVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(genderTextField)
        if genderTextField.text == "Female" {
            genderPickerView.selectRow(1, inComponent: 0, animated: false)
        } else {
            genderPickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    @objc func doneClick() {
        genderTextField.resignFirstResponder()
    }
   
   @objc func cancelClick() {
        genderTextField.resignFirstResponder()
    }
}

extension AboutMeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
       
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
   }
   
   func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
       return NSAttributedString(string: genders[row], attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
   }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func capitalizeFirstChar() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizeFirstChar()
    }
}
