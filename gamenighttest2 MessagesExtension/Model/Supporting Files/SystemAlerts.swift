//
//  SystemAlerts.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 11/6/23.
//

import UIKit

class SystemAlerts: UIAlertController {
    
    // MARK: Methods
    func showCalendarPermissionAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Calendar Permission Required.", message: "Please allow \"It's Game Night\" access to your Calendar app to enable this feature.\n Settings -> Privacy & Security -> Calendars.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"Calendar Permission\" alert occured.")
        }))
        
        return alert
    }
}
