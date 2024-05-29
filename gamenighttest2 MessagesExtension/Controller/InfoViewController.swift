//
//  InfoViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 3/21/24.
//

import UIKit
import SafariServices
import MessageUI

class InfoViewController: UIViewController {
    static let storyboardIdentifier = "InfoViewController"
    
    let privacyPolicyURL = URL(string: "https://www.letscoastmerchandise.com/privacy-policy")
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var shareFeedbackButton: UIButton!
    @IBOutlet weak var hapticFeedbackSwitch: UISwitch!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var gameNightImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageContainer.applyShadow(cornerRadius: imageContainer.frame.width / 2)
        gameNightImage.layer.cornerRadius = gameNightImage.frame.width / 2
        
        privacyPolicyButton.backgroundColor = UIColor(named: Constants.menuBackground)
        privacyPolicyButton.applyShadow(cornerRadius: 5)
        privacyPolicyButton.layer.cornerRadius = 5
        
        shareFeedbackButton.backgroundColor = UIColor(named: Constants.menuBackground)
        shareFeedbackButton.applyShadow(cornerRadius: 5)
        shareFeedbackButton.layer.cornerRadius = 5
        
        versionNumberLabel.text = Bundle.main.releaseVersionNumber
        nameTextField.delegate = self
        nameTextField.text = userDefaults.string(forKey: Constants.username)
        hapticFeedbackSwitch.isOn = userDefaults.bool(forKey: Constants.hapticFeedback)
        
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        switch sender {
        case privacyPolicyButton:
            if let url = privacyPolicyURL {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            }
        case shareFeedbackButton:
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            composeVC.setToRecipients([Constants.developerEmail])
            composeVC.setSubject("Share Feedback for It's Game Night")
            
            self.parent?.present(composeVC, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    @IBAction func tappedSwitch(_ sender: UISwitch) {
        userDefaults.set(hapticFeedbackSwitch.isOn, forKey: Constants.hapticFeedback)
    }
}

extension InfoViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

extension InfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = textField.text {
            nameTextField.text = name
            userDefaults.set(name, forKey: Constants.username)
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
