//
//  SystemAlerts.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 11/6/23.
//

import UIKit

class SystemAlerts: UIAlertController {
    
    // MARK: Methods
    
    /// Used in the CalendarViewController and the GameNightInviteViewController. Shows if there is a permission issue.
    /// - Returns: `UIAlertController`
    func showCalendarPermissionAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Calendar Permission Required.", message: "Please allow \"It's Game Night\" access to your Calendar app to enable this feature.\n Settings -> Privacy & Security -> Calendars.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"Calendar Permission\" alert occured.")
        }))
        
        return alert
    }
    
    /// Used in the SelectPeopleViewController. Shows if there are less than two people in the Randomizer.
    /// - Returns: `UIAlertController`
    func showLessThanTwoEntriesAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Please enter at least two entries", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancel)
        
        return alert
    }
}
