//
//  MainScreenTableViewCell.swift
//  Saver
//
//  Created by Игорь Лисицкий on 06.08.17.
//  Copyright © 2017 Igor Lisitzki. All rights reserved.
//

import UIKit

class MainScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var secondHeightConstraint: NSLayoutConstraint!
    
    @IBAction func callButton(_ sender: UIButton) {
    }
    
    
    
    func updateMainCell (with person : Person) {
        nameLabel.text = person.firstName + " " + person.lastName
        
        dateLabel.text = "Created by: \(Person.dateCreatedFormatter.string(from: person.dateCreated))"
        valueLabel.textColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        secondView.backgroundColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        valueLabel.text = person.valueMoney + person.currencyType
        guard person.financialRelation == "borrow" else {
            valueLabel.textColor = UIColor(red:0.17, green:0.78, blue:0.66, alpha:1.0)
            secondView.backgroundColor = UIColor(red:0.17, green:0.78, blue:0.66, alpha:1.0)
            return
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    var showsDetails = false  {
//        didSet {
//            secondHeightConstraint.priority = showsDetails ? 250 : 999
//        }
//    }

}
