//
//  SystemAlerts.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 11/6/23.
//

import UIKit

class SystemAlerts: UIAlertController {

    /// Parent alert for alerts with an array of actions.
    /// - Parameters:
    ///   - vc: Takes in the View Controller
    ///   - title: Title of the alert
    ///   - message: Message for the alert
    ///   - actions: An array of actions for the alert
    private static func showAlert(on vc: UIViewController, with title: String, with message: String, with actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { action in
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

// MARK: - Alerts
extension SystemAlerts {
    
    /// Used in the CalendarViewController and the GameNightInviteViewController. Shows if there is a permission issue.
    static func showCalendarPermissionAlert(on vc: UIViewController) {
        let title = "Calendar Permission Required"
        let message = "Please allow \"It's Game Night\" access to your Calendar app to enable this feature.\n Settings -> Privacy & Security -> Calendars."
        let action = UIAlertAction(title: "OK", style: .default)
        
        self.showAlert(on: vc, with: title, with: message, with: [action])
    }
    
    /// Used in the SelectPeopleViewController. Shows if there are less than two people in the Randomizer.
    static func showLessThanTwoEntriesAlert(on vc: UIViewController) {
        let title = "Not enough selected"
        let message = "Please enter at least two entries."
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        self.showAlert(on: vc, with: title, with: message, with: [cancel])
    }
    
    /// Shows and alert to reset the Trivia Points for the user. This is used in the `MyProfileViewController`.
    static func showResetPointsAlert(on vc: UIViewController, completion: @escaping (Bool) -> Void) {
        let title = "Reset Trivia Points?"
        let message = "Are you sure you want to reset your Trivia points?"
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        let reset = UIAlertAction(title: "Reset", style: .destructive) { _ in
            completion(true)
        }
        
        self.showAlert(on: vc, with: title, with: message, with: [cancel, reset])
    }
}
