//
//  HistoryTableViewCell.swift
//  Saver
//
//  Created by Игорь Лисицкий on 04.09.17.
//  Copyright © 2017 Igor Lisitzki. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var moneyCurrencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func updateMainCell (with person : PersonLog) {
        fullNameLabel.text = person.fisrtName! + " " + person.lastName! + ":"
        dateLabel.text = "Changed by: \(Person.dateFormatter.string(from: (person.dateChanged! as Date)))"
        
        moneyCurrencyLabel.textColor = UIColor(red:0.17, green:0.78, blue:0.66, alpha:1.0)
        if person.relation! == "borrow" {
            moneyCurrencyLabel.textColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        }
        
        if Int(person.valueMoneyChanged!)! > 0 {
            moneyCurrencyLabel.text = "+\(person.valueMoneyChanged!)\(person.currencyType!)"
        } else {
            moneyCurrencyLabel.text = "\(person.valueMoneyChanged!)\(person.currencyType!)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
