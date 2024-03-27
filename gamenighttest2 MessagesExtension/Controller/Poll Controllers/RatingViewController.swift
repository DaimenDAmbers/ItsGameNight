//
//  RatingViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/10/24.
//

import UIKit

class RatingViewController: UIViewController {
    
    // MARK: Variables
    static let storyboardIdentifier = "RatingViewController"
    weak var delegate: MessageDelegate?
    
    var poll: Poll?
    var editablePoll: Poll?
    var newVote = Vote(choice: .didNotVote)
    var decisions: [VotingDecisions : Bool] = [.overrated: false, .underrated: false, .properlyRated: false]
    let pollHelper = PollHelper()
    let defaults = Defaults()

    @IBOutlet weak var voteButtons: UITableView!
    @IBOutlet weak var sendVoteButton: UIButton!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedPoll = poll {
            questionText.text = unwrappedPoll.question
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PollTableViewCell.nib(), forCellReuseIdentifier: PollTableViewCell.idendifier)
        shouldEnableButton()
    }
    
    @IBAction func sendVote(_ sender: UIButton) {
        if var unwrappedPoll = poll {
            decisions.keys.forEach { if decisions[$0] == true { newVote.choice = $0 }}
            print("Submitting a vote for \(newVote.choice)")
            unwrappedPoll.votes[newVote.choice]! += 1
            unwrappedPoll.image = createImage() ?? UIImage(named: "It's Game Night")!
            unwrappedPoll.summaryText = createSummaryText(for: defaults.getUsername(), with: newVote.choice)
            delegate?.sendMessage(using: unwrappedPoll, isNewMessage: false)
        }
    }
    
    // MARK: Private functions
    private func createImage() -> UIImage? {
        guard let titleText = poll?.question else { return nil }
        guard let backgroundImage = UIImage(named: "It's Game Night") else { return nil }
        
        let titleLabel = pollHelper.createTitleLabel(for: titleText)
        guard let titleImage = titleLabel.createImage() else { return nil }
        
        let messageImage = backgroundImage.mergeImage(with: titleImage)
        
        return messageImage
    }
    
    private func shouldEnableButton() {
        let enableButton = decisions.contains { $0.value == true}
        sendVoteButton.isEnabled = enableButton
    }
    
    private func createSummaryText(for name: String?, with decision: VotingDecisions) -> String? {
        guard let name = name else { return "Anonymous voted \(decision.description)" }
        return "\(name) voted \(decision.description)"
    }
}

// MARK: - Extenstions
extension RatingViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Did select row at
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editablePoll = poll // Resets the poll values
        guard var unwrappedPoll = editablePoll else { return }
        let cell = Array(decisions.keys)[indexPath.row]
        
        
        switch cell {
        case .overrated:
            decisions[.overrated]?.toggle()
            decisions.updateValue(false, forKey: .underrated)
            decisions.updateValue(false, forKey: .properlyRated)
            print("Tapped Overrated")
        case .underrated:
            decisions[.underrated]?.toggle()
            decisions.updateValue(false, forKey: .overrated)
            decisions.updateValue(false, forKey: .properlyRated)
            print("Tapped Underrated")
        case .properlyRated:
            decisions[.properlyRated]?.toggle()
            decisions.updateValue(false, forKey: .overrated)
            decisions.updateValue(false, forKey: .underrated)
            print("Tapped Properly Rated")
        default:
            decisions.keys.forEach { decisions[$0] = false }
            print("No voting option selected")
        }
        
        // Loops through all keys and finds the ones that are try and makes the newVote.choice equal to that value.
        decisions.keys.forEach { if decisions[$0] == true {
            newVote.choice = $0
            unwrappedPoll.votes[newVote.choice]! += 1
        } else {
                newVote.choice = .didNotVote
            }}
        
        editablePoll = unwrappedPoll
        shouldEnableButton()
        
        tableView.reloadData()
    }
    
    // MARK: Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decisions.keys.count
    }
    
    // MARK: Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PollTableViewCell.idendifier, for: indexPath) as! PollTableViewCell
        let key = Array(decisions.keys)[indexPath.row]
        let value = Array(decisions.values)[indexPath.row]
        
        if let unwrappedPoll = editablePoll {
            cell.numOfVotesLabel.text = unwrappedPoll.votes[key]?.description
        }
        
        cell.decisionLabel.text = key.description
        cell.customImageView.image = value ? UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) : UIImage(systemName: "circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        return cell
    }
    
    // MARK: Will Display
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 6

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}
