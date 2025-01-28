//
//  TriviaResultsViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/27/24.
//

import UIKit
import GoogleMobileAds

class TriviaResultsViewController: UIViewController {
    static let storyboardIdentifier = "TriviaResultsViewController"
    var message: TriviaMessage?
    
    // MARK: Image Constants
    let correctImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    let incorrectImage = UIImage(systemName: "x.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: Google Ad
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        closeButton.applyShadow(cornerRadius: 5, interfaceStyle: traitCollection.userInterfaceStyle)
        
        let googleAdsManager = GoogleAdsManager(controller:  self)
        bannerView = googleAdsManager.createBannerAd()
        self.addBannerViewToView(bannerView)
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    // MARK: IBActions
    @IBAction func tappedClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension TriviaResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let message = message else { return cell }
        let submission = message.submissions[indexPath.section]
        
        let queryItemAnswer = submission.getQueryItemAnswer()
        let (answer,index) = message.returnUserAnswerandIndex(for: queryItemAnswer)
        submission.setAnswer(to: answer)
        
        var textLabel = String()
        
        if submission.result == .correct {
            textLabel = "Correct!"
        } else {
            var answerLetter = String()
            switch index {
            case 0:
                answerLetter = "A"
            case 1:
                answerLetter = "B"
            case 2:
                answerLetter = "C"
            default:
                answerLetter = "D"
            }
            
            textLabel = "\(answerLetter) is incorrect"
        }
        
        cell.textLabel?.text = textLabel
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.imageView?.image = submission.result == .correct ? correctImage : incorrectImage
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return message?.submissions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let message = message else { return nil }
        let submission = message.submissions[section]
        return submission.name
    }
}
