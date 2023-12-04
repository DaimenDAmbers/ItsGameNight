//
//  SelectPeopleViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 11/19/23.
//

import UIKit

class SelectPeopleViewController: UITableViewController {
    
    // MARK: Variables
    static let storyboardIdentifier = "SelectPeopleViewController"
    /// Used to pass down delegation to next viewController.
    weak var delegate: MessageDelegate?
    var people = [Person]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("People.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonPressed))
        let sendButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(self.sendButtonPressed))
        
        self.navigationItem.rightBarButtonItems?.append(sendButton)
        self.navigationItem.rightBarButtonItems?.append(addButton)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns the number of rows
        return people.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        // Configure the cell...
        let person = people[indexPath.row]
        cell.textLabel?.text = person.name
        
        cell.accessoryType = person.isIncluded == true ? .checkmark : .none // Ternary operator for setting the accessory type

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        
        person.isIncluded.toggle() // When tapped, this changes the inlcude property from true to false or vice versa.
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveList()
        
        tableView.reloadData()
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            people.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        saveList()
        tableView.reloadData()
    }
    
    /// This is the plus (+) button on the Randomizer Model Popup
    @objc func addButtonPressed() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new name", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            let newPerson = Person()
            newPerson.name = textField.text!
            
            self.people.append(newPerson)
            
            self.saveList()
            
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { alertTextField in
            alertTextField.autocapitalizationType = .words
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// This is the `Send` button on the Randomizer Modal Popup
    @objc func sendButtonPressed() {
        let randomizer = Randomizer(people: self.people)
        guard let peopleCount = randomizer?.people.count else {
            return
        }
        
        if peopleCount > 1 {
            randomizer?.chooseRandomPerson()
            delegate?.sendMessage(using: randomizer)
        } else {
            let alert = UIAlertController(title: "Please enter at least two entries", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }        
        
        print("Done Button Pressed")
        }
                                             
    // MARK: - Private Methods
    
    /// Saves the list using a `PropertyListEncoder`
    private func saveList() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(people)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding people array: \(error)")
        }
        
        print("Saved list successfully")
    }
    
    
    /// Loads the list using a `PropertyListDecoder`
    private func loadList() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                people = try decoder.decode([Person].self, from: data)
            } catch {
                print("Error decoding the people array: \(error)")
            }
        }
        print("Loaded list successfully")
    }

}
