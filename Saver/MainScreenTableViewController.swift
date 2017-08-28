//
//  MainScreenTableViewController.swift
//  Saver
//
//  Created by Игорь Лисицкий on 06.08.17.
//  Copyright © 2017 Igor Lisitzki. All rights reserved.
//

import UIKit
import MessageUI

class MainScreenTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
   // @IBOutlet weak var addPerson: UIBarButtonItem!
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        prepareTable()
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    func prepareTable() {
        if selectedIndex != -1  {
            selectedIndex = -1
            tableView.reloadRows(at:[selectedIndexPath!], with: .automatic)
//            tableView.reloadData()
        }
    }
    
    var selectedIndex = -1
    var selectedIndexPath : IndexPath?
    var persons : [Person]! {
        didSet {
            Person.saveToFile(persons)
        }
    }
    
    
    @IBAction func unwindToSaver(_ segue: UIStoryboardSegue) {
        if let indentifier = segue.identifier {
            switch indentifier {
            case "personSave" :
                guard let sourceTVC = segue.source as? EditTableViewController else {return}
                if let person = sourceTVC.person {
                   let newIndexPath = IndexPath(row: persons.count, section: 0)
                    persons.append(person)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                    prepareTable()
                }
            case "SaveValue" :
                guard let sourceVC = segue.source as? ChangeValueViewController else {return}
                if let person = sourceVC.person {
                    if let selectedIndexPath = selectedIndexPath {
                        persons[selectedIndexPath.row] = person
                        tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    }
                }
            default: prepareTable()
            }
            tableView.isEditing = false
        }
        
        
//        guard  segue.identifier == "personSave", let sourceTVC = segue.source as? EditTableViewController else {return}
//        if let person = sourceTVC.person {
//            let newIndexPath = IndexPath(row: persons.count, section: 0)
//            persons.append(person)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
//        }
//        "SaveValue"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persons = Person.loadFromFile() ?? []
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       // navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @IBAction func callButton(_ sender: UIButton) {
        let url : NSURL = URL(string: "TEL://\(persons[selectedIndex].phoneNumber)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendSMS(_ sender: UIButton) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
                controller.body = persons[selectedIndex].message
                controller.recipients = [persons[selectedIndex].phoneNumber]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func ShareButton(_ sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [persons[selectedIndex].message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Person", message: "I want delete this person?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {_ in
            self.persons.remove(at: self.selectedIndex)
            self.tableView.deleteRows(at: [self.selectedIndexPath!], with: .fade)
            self.selectedIndex = -1
            self.tableView.reloadData()
                }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func editButtonCell(_ sender: UIButton) {
        prepareTable()
//        selectedIndex = -1
//        tableView.reloadRows(at: [selectedIndexPath!], with: .automatic)
    }
    
    
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return persons.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return selectedIndex == indexPath.row ?  150 : 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! MainScreenTableViewCell
        let person = persons[indexPath.row]
        cell.updateMainCell(with: person)
        // Configure the cell...

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        if (selectedIndex == indexPath.row) {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
//   //  Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            persons.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedPerson = persons.remove(at: fromIndexPath.row)
        persons.insert(movedPerson, at: to.row)
        tableView.reloadData()
    }
 

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "changeValue" {
                let person = persons[(selectedIndexPath?.row)!]
                let changeValueVC = segue.destination as! ChangeValueViewController
                changeValueVC.person = person
        }
    }

}
