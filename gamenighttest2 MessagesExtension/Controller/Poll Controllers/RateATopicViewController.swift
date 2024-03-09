//
//  PollViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/10/24.
//

import UIKit

class RateATopicViewController: UIViewController {
    
    // MARK: - Variables
    static let storyboardIdentifier = "RateATopicViewController"
    var poll: Poll?
    let pollHelper = PollHelper()
    weak var delegate: MessageDelegate?
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var questionTextView: UITextView!
    let maxTextLength: Int = 50
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
      // Do any additional setup after loading the view.
        questionTextView.delegate = self
        questionTextView.returnKeyType = .done
        questionTextView.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        questionTextView.text = "Enter a question..."
        questionTextView.textColor = .lightGray
        questionTextView.clipsToBounds = true
        questionTextView.layer.cornerRadius = 10
        
        sendButton.isEnabled = false
        characterCountLabel.text = String(maxTextLength)
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let question = questionTextView.text else { return }
        let messageImage = createImage() ?? UIImage(named: "It's Game Night")!
        poll = Poll(question: question, votes: [VotingDecisions.didNotVote: 0], image: messageImage)
        delegate?.sendMessage(using: poll, isNewMessage: true)
    }
    
    private func createImage() -> UIImage? {
        guard let titleText = questionTextView.text else { return nil }
        guard let backgroundImage = UIImage(named: "It's Game Night") else { return nil }
        
        let titleLabel = pollHelper.createTitleLabel(for: titleText)
        guard let titleImage = titleLabel.createImage() else { return nil }
        
        let messageImage = backgroundImage.mergeImage(with: titleImage)
        
        return messageImage
    }
}

// MARK: - Extensions
extension RateATopicViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let currentString = (textView.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: text)
        
        if newString.count == 0 {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        
        let numLabel = String(maxTextLength - newString.count)
        characterCountLabel.text = numLabel
        
        return newString.count <= maxTextLength
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter a question..."
            textView.textColor = UIColor.lightGray
        }
    }
}
