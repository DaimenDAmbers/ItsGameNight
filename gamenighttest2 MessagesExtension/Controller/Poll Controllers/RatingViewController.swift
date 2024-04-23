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
    let choices = [VotingDecisions.overrated, VotingDecisions.underrated, VotingDecisions.properlyRated]
    let pollHelper = PollHelper()
    let defaults = Defaults()

    @IBOutlet weak var voteButtons: UITableView!
    @IBOutlet weak var sendVoteButton: UIButton!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sentByLabel: UILabel!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedPoll = poll {
            questionText.text = unwrappedPoll.question
            sentByLabel.text = unwrappedPoll.sentBy
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
            newVote.voterName = defaults.getUsername()
            unwrappedPoll.votes!.append(newVote)
            unwrappedPoll.image = createImage() ?? UIImage(named: "It's Game Night")!
            unwrappedPoll.createSummaryText(for: defaults.getUsername(), with: newVote.choice)
            delegate?.sendMessage(using: unwrappedPoll, isNewMessage: false)
        }
    }
    
    // MARK: Private functions
    private func createImage() -> UIImage? {
        guard let titleText = poll?.question else { return nil }
        guard let backgroundImage = UIImage(named: Constans.ImageTiles.rateATopic) else { return nil }
        
        let titleLabel = pollHelper.createTitleLabel(for: titleText)
        guard let titleImage = titleLabel.createImage() else { return nil }
        
        let messageImage = backgroundImage.mergeImage(with: titleImage)
        
        return messageImage
    }
    
    private func shouldEnableButton() {
        let enableButton = decisions.contains { $0.value == true}
        sendVoteButton.isEnabled = enableButton
    }
}

// MARK: - Extenstions
extension RatingViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Did select row at
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editablePoll = poll // Resets the poll values
        guard var unwrappedPoll = editablePoll else { return }
        let cell = choices[indexPath.row]
        
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
            unwrappedPoll.votes!.append(newVote)
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
        let isSelected = decisions[choices[indexPath.row]]
        
        if let unwrappedPoll = editablePoll {
            cell.numOfVotesLabel.text = unwrappedPoll.getNumOfVotes(for: choices[indexPath.row]).description
        }
        
        cell.decisionLabel.text = choices[indexPath.row].description
        cell.customImageView.image = isSelected! ? UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) : UIImage(systemName: "circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        cell.infoButton.tag = indexPath.row
        cell.infoButton.addTarget(self, action: #selector(infoButtonTapped), for: UIControl.Event.touchUpInside)
        
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
    
    @objc func infoButtonTapped(_ sender: UIButton) {
        guard let unwrappedPoll = poll else { return }
        if sender.tag == 0 {
            print("Overrated info button tapped")
            presentInfoVC(title: "Overrated Votes", votes: unwrappedPoll.returnVotes(for: .overrated))
            
        } else if sender.tag == 1 {
            print("Underrated info button tapped")
            presentInfoVC(title: "Underrated Votes", votes: unwrappedPoll.returnVotes(for: .underrated))
            
        } else {
            print("Properly Rated info button tapped")
            presentInfoVC(title: "Properly Rated Votes", votes: unwrappedPoll.returnVotes(for: .properlyRated))
        }
    }
    
    private func presentInfoVC(title: String, votes: [Vote]?) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: VoteInfoViewController.storyboardIdentifier) as? VoteInfoViewController else {
            fatalError("Unable to instantiate a StickerViewController from the storyboard")
        }
        
        controller.navigationItem.title = title
        controller.votes = votes
        let navVC = UINavigationController(rootViewController: controller)
        self.present(navVC, animated: true, completion: nil)
    }
}
