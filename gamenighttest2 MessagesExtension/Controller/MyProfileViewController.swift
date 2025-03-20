//
//  MyProfileViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 3/17/25.
//

import UIKit

class MyProfileViewController: UIViewController {
    static let storyboardIdentifier = "MyProfileViewController"
    let userDefaults = Defaults()

    // MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hapticFeedbackSwitch: UISwitch!
    @IBOutlet weak var triviaPointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        nameTextField.text = userDefaults.getUsername()
        hapticFeedbackSwitch.isOn = userDefaults.getHapticFeedbackSetting()
        triviaPointsLabel.text = String(userDefaults.getScore())
    }
    
    @IBAction func tappedSwitch(_ sender: UISwitch) {
        userDefaults.updateHapticFeedback(hapticFeedbackSwitch.isOn)
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        SystemAlerts.showResetPointsAlert(on: self, completion: { didReset in
            if didReset {
                print("Selected reset")
                self.userDefaults.resetScore()
                self.triviaPointsLabel.text = String(self.userDefaults.getScore())
            } else {
                print("Selected cancel")
            }
        })
    }
}

extension MyProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = textField.text {
            nameTextField.text = name
            userDefaults.setUserName(name)
        }
    }
}
