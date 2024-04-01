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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        privacyPolicyButton.backgroundColor = UIColor(named: Constans.menuBackground)
        privacyPolicyButton.applyShadow(cornerRadius: 5)
        privacyPolicyButton.layer.cornerRadius = 5
        
        shareFeedbackButton.backgroundColor = UIColor(named: Constans.menuBackground)
        shareFeedbackButton.applyShadow(cornerRadius: 5)
        shareFeedbackButton.layer.cornerRadius = 5
        
        versionNumberLabel.text = Bundle.main.releaseVersionNumber
        nameTextField.delegate = self
        nameTextField.text = userDefaults.string(forKey: Constans.username)
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
            
            composeVC.setToRecipients([Constans.developerEmail])
            composeVC.setSubject("Share Feedback for It's Game Night")
            
            self.parent?.present(composeVC, animated: true, completion: nil)
            
        default:
            break
        }
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
            userDefaults.set(name, forKey: Constans.username)
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
