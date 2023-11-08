//
//  HomeViewController.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/15/23.
//

import UIKit
import Messages
import EventKit
import EventKitUI

class HomeViewController: UIViewController {
    static let storyboardIdentifier = "HomeViewController"
    
    // MARK: Variables
    /// Used to pass down delegation to next viewController.
    weak var delegate: MessageDelegate?
    
    var conversation: MSConversation?
    var invite: CalendarInvite?
    let eventStore: EKEventStore = EKEventStore()
    let eventHelper = EventHelper()
    let systemAlerts = SystemAlerts()
    
    @IBOutlet weak var stickersButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    
    // MARK: Methods
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case calendarButton:

            let authorizationStatus = eventHelper.checkAuthorization(with: self.eventStore)
            
            switch authorizationStatus {
            case .fullAccess, .writeOnly, .authorized:
                if let event = eventHelper.createCalendarEvent(with: self.eventStore) {
                    presentVC(with: event)
                }
                
            default:
                    self.present(systemAlerts.showCalendarPermissionAlert(), animated: true, completion: nil)
            }
            
//            if #available(iOSApplicationExtension 17.0, *) {
//                if authorizationStatus == .fullAccess || authorizationStatus == .writeOnly {
//                    if let event = eventHelper.createCalendarEvent(with: self.eventStore) {
//                        presentVC(with: event)
//                    }
//                }
//            } else {
//                if authorizationStatus == .authorized {
//                    if let event = eventHelper.createCalendarEvent(with: self.eventStore) {
//                        presentVC(with: event)
//                    }
//                }
//            }
            
//            if authorizationStatus == .denied {
//                // If user denied the Calendar request, this alert let's them know how to enable it.
//                if eventHelper.createCalendarEvent(with: self.eventStore) == nil {
//                    self.present(systemAlerts.showCalendarPermissionAlert(), animated: true, completion: nil)
//                }
//            }
            
        default:
            break
        } // End of sender switch statement
    }
}

// MARK: - EKEventEditViewDelegate
extension HomeViewController: EKEventEditViewDelegate, UINavigationControllerDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        if action == .saved {
            
            guard let event = controller.event, let eventStore = controller.eventStore else { fatalError("No event or event store available.") }
            
            invite = CalendarInvite(event: event, eventStore: eventStore)
            didTapAdd()
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    /// Sends a message after tapping the `Add` button within the event creation ViewController.
    @objc func didTapAdd() {
        delegate?.sendMessage(with: invite)
    }
    
    /// Presents the ViewController after the `Schedule a Game Night` button is tapped
    private func presentVC(with event: EKEvent) {
        let editVC: EKEventEditViewController = CalendarViewController() // Needed to be able to dismiss modal even after changing the presentation style
        editVC.eventStore = self.eventStore
        editVC.event = event
        editVC.delegate = self
        editVC.editViewDelegate = self
        editVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAdd))
        
        self.present(editVC, animated: true, completion: nil)
    }
}
