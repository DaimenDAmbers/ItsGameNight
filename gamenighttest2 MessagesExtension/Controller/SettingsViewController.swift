//
//  SettingsViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 3/21/24.
//

import UIKit
import SafariServices
import MessageUI

class SettingsViewController: UIViewController {
    static let storyboardIdentifier = "SettingsViewController"
    
    let privacyPolicyURL = URL(string: Constants.privacyPolicy)
    
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var shareFeedbackButton: UIButton!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var gameNightImage: UIImageView!
    @IBOutlet weak var myProfileButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageContainer.applyShadow(cornerRadius: imageContainer.frame.width / 2, interfaceStyle: traitCollection.userInterfaceStyle)
        gameNightImage.layer.cornerRadius = gameNightImage.frame.width / 2
        
        privacyPolicyButton.backgroundColor = UIColor(named: Constants.menuBackground)
        privacyPolicyButton.applyShadow(cornerRadius: 5, interfaceStyle: traitCollection.userInterfaceStyle)
        privacyPolicyButton.layer.cornerRadius = 5
        
        shareFeedbackButton.backgroundColor = UIColor(named: Constants.menuBackground)
        shareFeedbackButton.applyShadow(cornerRadius: 5, interfaceStyle: traitCollection.userInterfaceStyle)
        shareFeedbackButton.layer.cornerRadius = 5
        
        myProfileButton.backgroundColor = UIColor(named: Constants.menuBackground)
        myProfileButton.applyShadow(cornerRadius: 5, interfaceStyle: traitCollection.userInterfaceStyle)
        myProfileButton.layer.cornerRadius = 5
        
        versionNumberLabel.text = Bundle.main.releaseVersionNumber
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
            
        case myProfileButton:
            openMyProfile()
            
        default:
            break
        }
    }
    
    /// Method to open the functionaility for the Randomizer
    private func openMyProfile() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: MyProfileViewController.storyboardIdentifier) as? MyProfileViewController else {
            fatalError("Unable to instantiate a SelectPeopleViewController from the storyboard")
        }
        
        controller.navigationItem.title = "My Profile"
        let navVC = UINavigationController(rootViewController: controller)
        
        self.present(navVC, animated: true, completion: nil)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
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
