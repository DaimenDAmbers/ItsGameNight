//
//  TriviaResultsViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/27/24.
//

import UIKit

class TriviaResultsViewController: UIViewController {
    static let storyboardIdentifier = "TriviaResultsViewController"
    var message: TriviaMessage?
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tappedClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension TriviaResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message?.submissions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let message = message else { return cell }
        let submission = message.submissions[indexPath.row]
        
        let queryItemAnswer = submission.getQueryItemAnswer()
        let (answer,_) = message.returnUserAnswerandIndex(for: queryItemAnswer)
        submission.setAnswer(to: answer)
        
        var textLabel = String()
        if let name = submission.name {
            textLabel = "\(name) was \(submission.result)"
        } else {
            textLabel = "A \(Constants.noUserName) was \(submission.result)"
        }
        
        cell.textLabel?.text = textLabel
        
        return cell
    }
}
