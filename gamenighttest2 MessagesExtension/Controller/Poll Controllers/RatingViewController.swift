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
//    var vote = Vote(choice: VotingDecisions.didNotVote)
    var vote: Vote?
    var newVote = Vote(choice: .didNotVote)
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
    
    
    @IBAction func sendVote(_ sender: UIButton) {
        if var unwrappedPoll = poll {
            unwrappedPoll.votes[newVote.choice]! += 1
            delegate?.sendMessage(using: unwrappedPoll)
        }
        
    }
}

extension RatingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var unwrappedPoll = poll else { return }
        var cell = Array(unwrappedPoll.votes.keys)[indexPath.row].description
        
        var oldVote = Vote(choice: .didNotVote)
        
        switch cell {
        case "Overrated":
            oldVote = newVote
            poll?.isOverrated = true
            poll?.isUnderrated = false
            poll?.isProperlyRated = false
            newVote.choice = .overrated
        case "Underrated":
            oldVote = newVote
            poll?.isOverrated = false
            poll?.isUnderrated = true
            poll?.isProperlyRated = false
            newVote.choice = .underrated
        case "Properly Rated":
            oldVote = newVote
            poll?.isOverrated = false
            poll?.isUnderrated = false
            poll?.isProperlyRated = true
            newVote.choice = .properlyRated
        default:
            oldVote = newVote
            poll?.isOverrated = false
            poll?.isUnderrated = false
            poll?.isProperlyRated = false
            newVote.choice = .didNotVote
        }
        
        print("This topic is \(newVote.choice).")        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return strings.count
        return VotingDecisions.allCases.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PollTableViewCell.idendifier, for: indexPath) as! PollTableViewCell
        
        if let unwrappedPoll = poll {
            let key = Array(unwrappedPoll.votes.keys)[indexPath.row].description
            let value = Array(unwrappedPoll.votes.values)[indexPath.row].description
            cell.decisionLabel.text = key
            cell.voteLabel.text = value
        }
        
        cell.customImageView.image = UIImage(systemName: "square.fill")
        
        return cell
    }
}
