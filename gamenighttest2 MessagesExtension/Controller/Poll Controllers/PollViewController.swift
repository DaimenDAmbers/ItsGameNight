//
//  PollViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/10/24.
//

import UIKit

class PollViewController: UIViewController {
    static let storyboardIdentifier = "PollViewController"
    var poll: Poll?
    weak var delegate: MessageDelegate?
    @IBOutlet weak var questionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // Do any additional setup after loading the view.
        questionTextField.delegate = self
        questionTextField.returnKeyType = .done
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let question = questionTextField.text else { return }
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        poll = Poll(question: question, votes: [VotingDecisions.didNotVote: 0], image: image)
        delegate?.sendMessage(using: poll)
    }
}

extension PollViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
