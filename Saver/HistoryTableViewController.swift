//
//  HistoryTableViewController.swift
//  Saver
//
//  Created by Игорь Лисицкий on 04.09.17.
//  Copyright © 2017 Igor Lisitzki. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    let context = AppDelegate.viewContext
    var persons : [PersonLog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persons = PersonLog.fetchPersonLogList(in: context)
    }


    @IBAction func clearAllButtonPressed(_ sender: UIBarButtonItem) {
       let alert = UIAlertController(title: "Delete all History", message: "Do you really want to delete your History?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            PersonLog.deleteAllRecords()
            self.persons = []
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        let person = persons[indexPath.row]
        cell.updateMainCell(with: person)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }


}
