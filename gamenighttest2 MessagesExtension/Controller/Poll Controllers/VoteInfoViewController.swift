//
//  VoteInfoViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 4/17/24.
//

import UIKit

class VoteInfoViewController: UIViewController {
    static let storyboardIdentifier = "VoteInfoViewController"
    var votes: [Vote]?
    let cellID = "cellID"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension VoteInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let votes = votes else { return 0 }
        
        print("Number of votes in Table View: \(votes.count)")
        print("Votes value: \(votes)")
        
        if votes.isEmpty {
            return 1
        }
        
        return votes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        guard let votes = votes else { return cell }
        
        if votes.isEmpty {
            cell.textLabel?.text = "No votes"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.textLabel?.textAlignment = NSTextAlignment.center
            
            return cell
        } else {
            
            let voterName = votes[indexPath.row].voterName
            
            cell.textLabel?.text = voterName
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            
            return cell
        }
    }
}
