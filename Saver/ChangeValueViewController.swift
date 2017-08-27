//
//  ChangeValueViewController.swift
//  Saver
//
//  Created by Игорь Лисицкий on 13.08.17.
//  Copyright © 2017 Igor Lisitzki. All rights reserved.
//

import UIKit

class ChangeValueViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    
    var person : Person?
    var defaultStep = 20
    var valueMoneyNew : String?
    var steps : [String] = ["5", "10","15", "20", "25", "50", "100"]
    
    var currentValue : Int {
        get { return Int(valueMoneyNew!)!}
        set { valueMoneyNew = String(newValue)}
    }
    
    
    @IBAction func minusButton(_ sender: UIButton) {
        if currentValue != 0 {
            guard currentValue >= defaultStep else {
                currentValue = 0
                valueLabel.text = valueMoneyNew! + (person?.currencyType)!
                return
            }
                currentValue -= defaultStep
                valueLabel.text = valueMoneyNew! + (person?.currencyType)!
            }
        }
    
    @IBAction func plusButton(_ sender: UIButton) {
        if currentValue < 10000 {
            currentValue += defaultStep
            valueLabel.text = valueMoneyNew! + (person?.currencyType)!
        }
    }
    
    @IBAction func dragOutsideButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            sender.transform = .identity
        }
    }
    
    @IBAction func TouchUpInsideAnimated(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) { 
            sender.transform = .identity
        }
    }
    
    
    
    
    @IBAction func TouchDownAnimated(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) { 
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return steps[row] + (person?.currencyType)!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return steps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaultStep = Int(steps[row])!
    }
    
    
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        person?.valueMoney = valueMoneyNew!
        performSegue(withIdentifier: "SaveValue", sender: sender)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let person = person {
            valueMoneyNew = person.valueMoney
            nameLabel.text = "\(person.firstName) \(person.lastName)"
            relationLabel.text = "\(person.financialRelation)ed me:"
            valueLabel.text = "\(person.valueMoney)\(person.currencyType)"
        }
        pickerView.selectRow(3, inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
    }


}
