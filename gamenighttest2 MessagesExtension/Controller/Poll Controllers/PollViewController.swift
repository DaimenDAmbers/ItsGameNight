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
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let question = questionTextField.text else { return }
        poll = Poll(question: question, overrated: 0, underrated: 0, properlyRated: 0)
        delegate?.sendMessage(using: poll)
    }
}
