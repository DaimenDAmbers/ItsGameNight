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
        var cell = Vote(choice: VotingDecisions.allCases[indexPath.row])
        
        switch cell.choice {
        case .overrated:
            poll?.isOverrated = true
            poll?.isUnderrated = false
            poll?.isProperlyRated = false
        case .underrated:
            poll?.isOverrated = false
            poll?.isUnderrated = true
            poll?.isProperlyRated = false
        case .properlyRated:
            poll?.isOverrated = false
            poll?.isUnderrated = false
            poll?.isProperlyRated = true
        default:
            poll?.isOverrated = false
            poll?.isUnderrated = false
            poll?.isProperlyRated = false
        }
        print(poll?.isOverrated as Any)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return strings.count
        return VotingDecisions.allCases.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PollTableViewCell.idendifier, for: indexPath) as! PollTableViewCell
        if let unwrappedPoll = poll {
            let key = Array(poll!.votes.keys)[indexPath.section]
            let value = Array(poll!.votes.values)[indexPath.row]
            print("Keys: \(key)")
            print("Values: \(value)")
        }
        
        
        cell.customImageView.image = UIImage(systemName: "square.fill")
        cell.decisionLabel.text = VotingDecisions.allCases[indexPath.row].description
        
//        cell.voteLabel.text =
        
        return cell
    }
}
