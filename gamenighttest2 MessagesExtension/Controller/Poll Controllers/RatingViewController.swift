//
//  RatingViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/10/24.
//

import UIKit

class RatingViewController: UIViewController {
    static let storyboardIdentifier = "RatingViewController"
    var poll: Poll?
    weak var delegate: MessageDelegate?
    @IBOutlet weak var questionText: UINavigationItem!
    var strings = ["Overrated", "Underrated", "Properly Rated"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedPoll = poll { 
            questionText.title = unwrappedPoll.question
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PollTableViewCell.nib(), forCellReuseIdentifier: PollTableViewCell.idendifier)
    }
}

extension RatingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vote = strings[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PollTableViewCell.idendifier, for: indexPath) as! PollTableViewCell
        cell.customImageView.image = UIImage(systemName: "square.fill")
        cell.decisionLabel.text = strings[indexPath.row]
        
        return cell
    }
}
