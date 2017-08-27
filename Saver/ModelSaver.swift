//
//  ModelSaver.swift
//  Saver
//
//  Created by Игорь Лисицкий on 06.08.17.
//  Copyright © 2017 Igor Lisitzki. All rights reserved.
//

import Foundation

class Person : NSObject, NSCoding {
    // properties class
    var firstName : String
    var lastName : String
    var currencyType : Currency.RawValue
    var financialRelation : Relation.RawValue
    var valueMoney : String
    var phoneNumber : String
    var dateCreated : Date
    
    static let dateCreatedFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var message : String {
        return "Hello, you \(financialRelation)ed me \(valueMoney)\(currencyType)"
    }
    
    static func SamplePerson() -> [Person] {
        return [Person(firstName: "John", lastName: "Snow", currencyType: .dollar, financialRelation: .loan, valueMoney: "50", phoneNumber: "+375291297685", dateCreated : Calendar.current.startOfDay(for: Date())),
                Person(firstName: "Daenerys", lastName: "Targaryen", currencyType: .ruble, financialRelation: .loan, valueMoney: "15",phoneNumber: "+375291297685", dateCreated : Calendar.current.startOfDay(for: Date())),
                Person(firstName: "Cersei", lastName: "Lannister", currencyType: .euro, financialRelation: .borrow, valueMoney: "100",phoneNumber: "+375291297685",dateCreated : Calendar.current.startOfDay(for: Date()))
        ]
    }
    
    enum Currency : String {
        case dollar = "$"
        case euro = "€"
        case ruble = "₽"
    }
    
    enum Relation : String {
        case loan = "loan"
        case borrow = "borrow"
    }
    
    // static property and funcs for save data
    static var archiveURL : URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("iSaver")
    }
    
    static func saveToFile (_ person : [Person]) {
        NSKeyedArchiver.archiveRootObject(person, toFile: Person.archiveURL.path)
    }
    static func loadFromFile () -> [Person]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Person.archiveURL.path) as? [Person]
    }
    
    //membervise init
    init(firstName : String, lastName : String, currencyType : Currency, financialRelation : Relation, valueMoney : String, phoneNumber : String, dateCreated : Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.currencyType = currencyType.rawValue
        self.financialRelation = financialRelation.rawValue
        self.valueMoney = valueMoney
        self.phoneNumber = phoneNumber
        self.dateCreated = dateCreated
    }
    //create struct for the init? and encode
    struct PropertyKey {
        static var firstName = "firstName"
        static var lastName = "lastName"
        static var currencyType = "currencyType"
        static var financialRelation = "financialRelation"
        static var valueMoney = "valueMoney"
        static var phoneNumber = "phoneNumber"
        static var dateCreated = "dateCreated"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let firstName = aDecoder.decodeObject(forKey : PropertyKey.firstName) as? String,
        let lastName = aDecoder.decodeObject(forKey: PropertyKey.lastName) as? String,
        let currencyType = aDecoder.decodeObject(forKey : PropertyKey.currencyType) as? Currency.RawValue,
        let financialRelation = aDecoder.decodeObject(forKey : PropertyKey.financialRelation) as? Relation.RawValue,
        let valueMoney = aDecoder.decodeObject(forKey: PropertyKey.valueMoney) as? String,
        let phoneNumber = aDecoder.decodeObject(forKey: PropertyKey.phoneNumber) as? String,
        let dateCreated = aDecoder.decodeObject(forKey: PropertyKey.dateCreated) as? Date else {return nil}
        
        self.init(firstName : firstName, lastName : lastName, currencyType : Person.Currency(rawValue: currencyType)!, financialRelation : Person.Relation(rawValue: financialRelation)!, valueMoney : valueMoney, phoneNumber : phoneNumber, dateCreated : dateCreated)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: PropertyKey.firstName)
        aCoder.encode(lastName, forKey: PropertyKey.lastName)
        aCoder.encode(currencyType, forKey: PropertyKey.currencyType)
        aCoder.encode(financialRelation, forKey: PropertyKey.financialRelation)
        aCoder.encode(valueMoney, forKey: PropertyKey.valueMoney)
        aCoder.encode(phoneNumber, forKey: PropertyKey.phoneNumber)
        aCoder.encode(dateCreated, forKey: PropertyKey.dateCreated)
    }
    
}
