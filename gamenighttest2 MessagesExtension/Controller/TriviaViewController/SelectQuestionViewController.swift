//
//  CategoryViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/17/24.
//

import UIKit
import GoogleMobileAds

class SelectQuestionViewController: UIViewController {
    
    // MARK: Variables
    static let storyboardIdentifier = "SelectQuestionViewController"
    var questions: [TriviaModel]?
    weak var delegate: MessageDelegate?
    var category: TriviaAPIData.Category?
    var difficulty: TriviaAPIData.Difficulty?
    var triviaManager = TriviaManager()
    
    // MARK: IB Outlet Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    // MARK: Google Ad
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        triviaManager.delegate = self
        tableView.register(SelectQuestionTableViewCell.nib(), forCellReuseIdentifier: SelectQuestionTableViewCell.identifier)
        refreshView()
        refreshButton.applyShadow(cornerRadius: 5, interfaceStyle: traitCollection.userInterfaceStyle)
        
        let googleAdsManager = GoogleAdsManager(controller:  self)
        bannerView = googleAdsManager.createBannerAd()
        self.addBannerViewToView(bannerView)
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    // MARK: Private functions
    
    /// Send the message with the selected question
    /// - Parameter question: This question is a conforms to the `TriviaModel`.
    private func sendMessage(with question: TriviaModel) {
        let message = TriviaMessage(triviaModel: question, submissions: [TriviaMessage.PersonSubmission](), questionType: .single)
        delegate?.sendMessage(using: message, isNewMessage: true, sendImmediately: false)
    }
    
    /// Calls the Trivia API and refreshes the view of the Table.
    private func refreshView() {
        if let category = category, let difficulty = difficulty {
            let request = triviaManager.getQuestion(category: category, difficulty: difficulty)
            triviaManager.fetchQuestion(with: request)
        }
    }
    
    // MARK: IB Actions
    @IBAction func tappedRefresh(_ sender: UIButton) {
        refreshView()
    }
    
}

// MARK: - UITableView Data Source
extension SelectQuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        questions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectQuestionTableViewCell.identifier, for: indexPath) as! SelectQuestionTableViewCell
        let questionNumber: String = "Question \(indexPath.row + 1)"
        cell.questionNumber.text = questionNumber
        cell.questionText.text = questions?[indexPath.row].question
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension SelectQuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let question = self.questions?[indexPath.row] {
            sendMessage(with: question)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 6
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}

// MARK: - Trivia Manager Delegate
extension SelectQuestionViewController: TriviaManagerDelegate {
    func didUpdateQuestion(for triviaQuestions: [TriviaModel]) {
        DispatchQueue.main.async {
            self.questions = triviaQuestions
            self.tableView.reloadData()
        }
    }
}
