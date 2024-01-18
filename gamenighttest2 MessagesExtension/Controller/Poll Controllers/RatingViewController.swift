//
//  RatingViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/10/24.
//

import UIKit

class RatingViewController: UIViewController {
    static let storyboardIdentifier = "RatingViewController"
    weak var delegate: MessageDelegate?
    
    var poll: Poll?
    var newVote = Vote(choice: .didNotVote)
    var decisions: [VotingDecisions : Bool] = [.underrated: false, .overrated: false, .properlyRated: false]

    @IBOutlet weak var sendVoteButton: UIButton!
    @IBOutlet weak var questionText: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedPoll = poll {
            questionText.title = unwrappedPoll.question
            print("Number of total votes: \(unwrappedPoll.totalVotes)")
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PollTableViewCell.nib(), forCellReuseIdentifier: PollTableViewCell.idendifier)
        shouldEnableButton()
    }
    
    @IBAction func sendVote(_ sender: UIButton) {
        if var unwrappedPoll = poll {
            decisions.keys.forEach { if decisions[$0] == true { newVote.choice = $0 }}
            print("Submitting vote for \(newVote.choice)")
            unwrappedPoll.votes[newVote.choice]! += 1
            unwrappedPoll.image = createImage()
            delegate?.sendMessage(using: unwrappedPoll)
        }
    }
    
    private func createImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    private func shouldEnableButton() {
        let enableButton = decisions.contains { $0.value == true}
        print("Should enable button is \(true)")
        sendVoteButton.isEnabled = enableButton
    }
}

extension RatingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell = Array(decisions.keys)[indexPath.row]
        
        switch cell {
        case .overrated:
            decisions[.overrated]?.toggle()
            decisions.updateValue(false, forKey: .underrated)
            decisions.updateValue(false, forKey: .properlyRated)
            print("Tapped Overrated")
            shouldEnableButton()
        case .underrated:
            decisions[.underrated]?.toggle()
            decisions.updateValue(false, forKey: .overrated)
            decisions.updateValue(false, forKey: .properlyRated)
            print("Tapped Underrated")
            shouldEnableButton()
        case .properlyRated:
            decisions[.properlyRated]?.toggle()
            decisions.updateValue(false, forKey: .overrated)
            decisions.updateValue(false, forKey: .underrated)
            print("Tapped Properly Rated")
            shouldEnableButton()
        default:
            decisions.keys.forEach { decisions[$0] = false }
            shouldEnableButton()
            print("No voting option selected")
        }
       
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decisions.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PollTableViewCell.idendifier, for: indexPath) as! PollTableViewCell
        let key = Array(decisions.keys)[indexPath.row]
        let value = Array(decisions.values)[indexPath.row]
        
        if let unwrappedPoll = poll {
            cell.votePercentLabel.text = unwrappedPoll.votes[key]?.description
        }
        
        cell.decisionLabel.text = key.description
        cell.customImageView.image = value ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle.fill")
        
        return cell
    }
}
