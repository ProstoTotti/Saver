//
//  PersonLog.swift
//  Saver
//
//  Created by Игорь Лисицкий on 04.09.17.
//  Copyright © 2017 Igor Lisitzki. All rights reserved.
//

import UIKit
import CoreData

class PersonLog: NSManagedObject {
    
    
    class func createPersonLog(person : Person, in context : NSManagedObjectContext, newValue : String) {
        let dateChanged = Calendar.current.startOfDay(for: Date()) as NSDate
        let valueMoneyChanged = String(Int(newValue)! - Int(person.valueMoney)!)
        
        let personLog = PersonLog(context: context)
        personLog.currencyType = person.currencyType
        personLog.fisrtName = person.firstName
        personLog.lastName = person.lastName
        personLog.dateChanged = dateChanged
        personLog.valueMoneyChanged = valueMoneyChanged
        personLog.relation = person.financialRelation
        try? context.save()
    }
    
    class func fetchPersonLogList(in context : NSManagedObjectContext) -> [PersonLog] {
        var log : [PersonLog] = []
        let request : NSFetchRequest<PersonLog> = PersonLog.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateChanged", ascending: false),NSSortDescriptor(key: "lastName", ascending: true)]
            do {
            log = try context.fetch(request)
            } catch {
                print("error fetch log")
        }
       return log
    }
    
    class func deleteAllRecords() {
        let context = AppDelegate.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonLog")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}
