//
//  EditTableViewController.swift
//  Saver
//
//  Created by Игорь Лисицкий on 06.08.17.
//  Copyright © 2017 Igor Lisitzki. All rights reserved.
import UIKit
import Contacts
import ContactsUI
import AudioToolbox

class EditTableViewController: UITableViewController, CNContactPickerDelegate {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var numberMoney: UILabel!
    
    @IBOutlet weak var loanCell: UITableViewCell!
    @IBOutlet weak var borrowCell: UITableViewCell!
    
    @IBOutlet weak var usdCell: UITableViewCell!
    
    @IBOutlet weak var euroCell: UITableViewCell!
        
    @IBOutlet weak var bynCell: UITableViewCell!
        
    
    var firstName : String?
    var lastName : String?
    var saveSoundID : SystemSoundID = 0
    var errorSoundID : SystemSoundID = 0
    //phoneFix
    var numberCodePhone : String? {
        didSet {
           phoneCodeToNumber()
        }
    }
    var currencyArray : [UITableViewCell]? {
        guard let usdCell = usdCell, let euroCell = euroCell, let bynCell = bynCell else {return nil}
        return [usdCell, euroCell, bynCell]
    }
    
    var currencyType : Person.Currency? {
        if let currencyArray = currencyArray {
        for (index,item) in currencyArray.enumerated() {
            if item.accessoryType == .checkmark {
                switch index {
                case 0: return Person.Currency.dollar
                case 1: return Person.Currency.euro
                case 2: return Person.Currency.ruble
                default : break 
            }
        }
        }
        }
        return nil
    }
    
    var relationType : Person.Relation? {
        if borrowCell.accessoryType == .checkmark {return Person.Relation.borrow}
        else if loanCell.accessoryType == .checkmark {return Person.Relation.loan}
        else {return nil}
    }
    var person : Person? {
        let dateCreated = Calendar.current.startOfDay(for: Date())
        guard let firstName = firstName,
        let lastName = lastName,
        let numberMoneyStr = numberMoney.text,
        let phoneNumber = phoneNumberLabel.text,
        let currencyType = currencyType,
        let relationType = relationType else {return nil}
        
        return Person(firstName: firstName, lastName: lastName, currencyType: currencyType, financialRelation: relationType, valueMoney: numberMoneyStr, phoneNumber: phoneNumber, dateCreated : dateCreated)
    }
    
    func playSaveSound() {
        if saveSoundID == 0 {
            let soundURL = Bundle.main.url(forResource: "save", withExtension: "wav")! as CFURL
            AudioServicesCreateSystemSoundID(soundURL, &saveSoundID)
        }
        AudioServicesPlaySystemSound(saveSoundID)
    }
    
    func playErrorSound() {
        if errorSoundID == 0 {
            let soundURL = Bundle.main.url(forResource: "error", withExtension: "wav")! as CFURL
            AudioServicesCreateSystemSoundID(soundURL, &errorSoundID)
        }
        AudioServicesPlaySystemSound(errorSoundID)
        
    }
    
    @IBAction func FetchContacts(_ sender: Any) {
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == CNAuthorizationStatus.notDetermined {
            let contactsStore = CNContactStore.init()
            contactsStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
                if success {
                    self.openContacts()
                } else {
                    print ("Not authorised")
                }
            })
            
        } else if authStatus == CNAuthorizationStatus.authorized {
            self.openContacts()
        }
    }
    
    func openContacts(){
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true) { 
            
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // When user selects any contact
        let fullName = "\(contact.givenName) \(contact.familyName)"
        self.firstName = contact.givenName
        self.lastName = contact.familyName
        self.fullNameLabel.text = fullName
        let phoneNumberString = ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue"))
        numberCodePhone = phoneNumberString as? String
    }
    
    func phoneCodeToNumber() {
        let numbers = "+0123456789"
        var phone = ""
        if let numberCodePhone = numberCodePhone {
            for char in numberCodePhone.characters {
                if numbers.contains(String(char)) {
                    phone += String(char)
                }
            }
        }
        phoneNumberLabel.text = phone
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if person == nil || Int((person?.valueMoney)!) == nil {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.playErrorSound()
            })
            let alert = UIAlertController(title: "Fields are not filled", message: "Please, fill empty fields or correct value money", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.playSaveSound()
            })
            performSegue(withIdentifier: "personSave", sender: self)
        }
       
    }
    
    func writeAmountMoney() {
        let alert = UIAlertController(title: "Value Money", message: "Enter the value", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { moneyTextField in
            moneyTextField.placeholder = "Enter value"
            moneyTextField.keyboardType = .numberPad
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            if let alert = alert {
                if let textField = alert.textFields?.first {
                    if textField.text == "" || textField.text?.characters.first == "0" {
                        self.numberMoney.text = "Not Set"
                    } else {
                        self.numberMoney.text = textField.text
                    }
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func amountMoney(_ sender: UIButton) {
        writeAmountMoney()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case [2,0]:
            loanCell.accessoryType = .checkmark
            borrowCell.accessoryType = .none
        case [2,1]:
            loanCell.accessoryType = .none
            borrowCell.accessoryType = .checkmark
        case [3,0]:
            usdCell.accessoryType = .checkmark
            euroCell.accessoryType = .none
            bynCell.accessoryType = .none
        case[3,1]:
            usdCell.accessoryType = .none
            euroCell.accessoryType = .checkmark
            bynCell.accessoryType = .none
        case [3,2]:
            usdCell.accessoryType = .none
            euroCell.accessoryType = .none
            bynCell.accessoryType = .checkmark
        default:
            break
        }
    }
}
