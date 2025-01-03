//
//  TriviaMessageViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/15/24.
//

import UIKit
import Messages

class TriviaMessageViewController: UIViewController {

    // MARK: Variables
    static let storyboardIdentifier = "TriviaMessageViewController"
    var trivia: TriviaMessage?
    let defaults = Defaults()
    weak var delegate: MessageDelegate?
    
    var allShuffledAnswers: [String] = []
    var choices: [Int : String] = [:]  // Choices and the index that they are in on screen
    var correctAnswerIndex = Int()
    var choiceSelected: [Int : TriviaMessage.PersonSubmission.Decision] = [:] // The selected choice by the user
    var userResults: TriviaMessage.PersonSubmission.Decision = .didNotSelect
    var userAnswer = String()
    var userAnswerIndex = Int()
    
    // MARK: IBOutlet Variables
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seeResults: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    // MARK: Image Constants
    let correctImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    let incorrectImage = UIImage(systemName: "x.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    let notSelectedImage = UIImage(systemName: "circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let message = trivia else { return }
        let triviaModel = message.triviaModel
        
        print("Trivia Message VC Query Items: \(message.queryItems)")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TriviaTableViewCell.nib(), forCellReuseIdentifier: TriviaTableViewCell.identifier)
        
        questionLabel.text = triviaModel.question
        categoryLabel.text = triviaModel.category
        difficultyLabel.text = triviaModel.difficulty

        allShuffledAnswers = message.shuffledAnswers
        correctAnswerIndex = message.correctAnswerIndex
        
        setupChoices(answers: allShuffledAnswers)

        if message.checkIfPersonAnswered(id: message.senderID) {
            disableUserInput(for: message, answers: allShuffledAnswers)
            seeResults.isEnabled = true
        } else {
            seeResults.isEnabled = false
        }
    }
    
    // MARK: Private functions
    /// Sets up the choices for the answers
    /// - Parameter answers: Takes in the array of answers and assigns them an index that can be selected in a list.
    private func setupChoices(answers: [String]) {
        for index in 0..<answers.count {
            choices[index] = answers[index]
            choiceSelected[index] = .didNotSelect
        }
    }
    
    private func setUserAnswerIndex(for answers: [String]) {
        for index in 0..<answers.count {
            if answers[index] == userAnswer {
                userAnswerIndex = index
            }
        }
    }
    
    /// Sends the results of the question as another message.
    /// - Parameter user: This is the user's name and choice from the question.
    private func sendResults(for user: TriviaMessage.PersonSubmission) {
        if var message = trivia {
            message.submissions.append(user)
            print("User's selected answer: \(user.selectedAnswer)")
            message.summaryText = "\(user.name ?? Constants.noUserName) was \(user.choice)"
            delegate?.sendMessage(using: message, isNewMessage: false, sendImmediately: true)
        }
        
    }
    
    private func disableUserInput(for message: TriviaMessage, answers: [String]) {
        for submission in message.submissions {
            if submission.id == message.senderID {
                seeResults.isEnabled = false
                tableView.allowsSelection = false
                updateFeedbackLabel(for: submission.choice)
                userAnswer = message.fetechUserAnswer(for: submission.getQueryItemAnswer())
                setUserAnswerIndex(for: answers)
                showUserAnswer(choice: submission.choice)
                showCorrectAnswer()
            }
        }
    }
    
    private func updateFeedbackLabel(for state: TriviaMessage.PersonSubmission.Decision) {
        switch state {
        case .correct:
            feedbackLabel.text = "Good job!"
        case .incorrect:
            feedbackLabel.text = "Better luck next time!"
        case .didNotSelect:
            break
        }
        
        feedbackLabel.isHidden = false
    }
    
    private func updateTableWithAnswer(at row: Int, decision: TriviaMessage.PersonSubmission.Decision) {
        choiceSelected[row] = decision
        userResults = decision
        if row != correctAnswerIndex {
            showCorrectAnswer()
        }
    }
    
    private func showCorrectAnswer() {
        choiceSelected[correctAnswerIndex] = .correct
    }
    
    private func showUserAnswer(choice: TriviaMessage.PersonSubmission.Decision) {
        switch choice {
        case .correct:
            choiceSelected[userAnswerIndex] = .correct
        case .incorrect:
            choiceSelected[userAnswerIndex] = .incorrect
        default:
            choiceSelected[userAnswerIndex] = .didNotSelect
        }
    }
    
    private func sendUserResults() {
        guard let senderID = trivia?.senderID else { return }
        let user = TriviaMessage.PersonSubmission()
        user.id = senderID
        user.name = defaults.getUsername()
        user.choice = userResults
        user.selectedAnswer = userAnswer
        sendResults(for: user)
    }
    
    @IBAction func tappedSeeResultsButton(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: TriviaResultsViewController.storyboardIdentifier) as? TriviaResultsViewController else {
            fatalError("Unable to instantiate a TriviaResultsViewController from the storyboard")
        }
        
        controller.navigationItem.title = "Trivia Results"
        controller.message = trivia
        
        let navVC = UINavigationController(rootViewController: controller)
        self.present(navVC, animated: true, completion: nil)
    }
}

// MARK: - UITableView Data Source
extension TriviaMessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allShuffledAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TriviaTableViewCell.identifier, for: indexPath) as! TriviaTableViewCell
        cell.answerText.text = allShuffledAnswers[indexPath.row].description
        cell.answerImage.image = UIImage(systemName: "circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        let choices = choiceSelected[indexPath.row]
        
        switch choices {
        case .correct:
            cell.answerImage.image = correctImage
        case .incorrect:
            cell.answerImage.image = incorrectImage
        case .didNotSelect:
            cell.answerImage.image = notSelectedImage
        case .none:
            cell.answerImage.image = notSelectedImage
        }
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension TriviaMessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 6

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let message = trivia else { return }
        guard let selectedCell = choices[indexPath.row] else { return }
                
        if message.checkIfAnswerIsCorrect(selectedCell) {
            updateTableWithAnswer(at: indexPath.row, decision: .correct)
            updateFeedbackLabel(for: .correct)
        } else {
            updateTableWithAnswer(at: indexPath.row, decision: .incorrect)
            updateFeedbackLabel(for: .incorrect)
        }
        
        userAnswer = message.setUserAnswer(for: selectedCell)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        let hapticFeedback = defaults.getHapticFeedbackSetting()
        if hapticFeedback { generator.impactOccurred() }
        
        tableView.reloadData()
        
        sendUserResults()
    }
}
