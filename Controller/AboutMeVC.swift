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
    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var gainWeightBtn: UIButton!
    @IBOutlet weak var maintainWeightBtn: UIButton!
    @IBOutlet weak var loseWeightBtn: UIButton!
    
    var selectedGender : String? = ""
    let genders = ["Male","Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        let objects: Any = [gainWeightBtn,maintainWeightBtn, loseWeightBtn, aboutView]
        applyRoundedCorner(objects as! [AnyObject])
        
        let textFields: Any = [nameTextField, heightTextField, weightTextField]
        applyUnderline(textFields as! [UITextField])
        
        genderPickerView.reloadAllComponents()
    }
    
    @IBAction func planDidPressed(_ sender: Any) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
       selectedGender = genders[row]
   }
   
   func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
       return NSAttributedString(string: genders[row], attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
   }
    
}
