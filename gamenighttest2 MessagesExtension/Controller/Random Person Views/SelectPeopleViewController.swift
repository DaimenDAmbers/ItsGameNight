//
//  SelectPeopleViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 11/19/23.
//

import UIKit

class SelectPeopleViewController: UITableViewController {
    static let storyboardIdentifier = "SelectPeopleViewController"
    var people = [Person]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("People.plist")
//    print(dataFilePath)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
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
        
        cell.accessoryType = person.include == true ? .checkmark : .none // Ternary operator for setting the accessory type

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        
        person.include.toggle() // When tapped, this changes the inlcude property from true to false or vice versa.
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveList()
        
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
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
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "John Doe"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print("Done Button Pressed")
    }
    
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
