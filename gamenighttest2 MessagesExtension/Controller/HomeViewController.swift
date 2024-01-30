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
    var authorizationStatus: EKAuthorizationStatus = .notDetermined
    
    @IBOutlet weak var stickersButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var randomizerButton: UIButton!
    @IBOutlet weak var rateATopicButton: UIButton!
    
    // MARK: Methods
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
            
        case calendarButton:

            self.authorizationStatus = eventHelper.checkAuthorization(with: self.eventStore)
            
            switch authorizationStatus {
            case .fullAccess, .writeOnly, .authorized:
                if let event = eventHelper.createCalendarEvent(with: self.eventStore) {
                    presentVC(with: event)
                }
                
            case .notDetermined:
                eventHelper.requestAuthorization(with: self.eventStore)
                
            default:
                self.present(systemAlerts.showCalendarPermissionAlert(), animated: true, completion: nil)
            }
            
        case randomizerButton:
            print("Random button tapped")
            let vc = SelectPeopleViewController()
            
            vc.navigationItem.title = "Randomizer"
            vc.navigationItem.rightBarButtonItems = []
            vc.delegate = delegate
            vc.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PersonCell")

            let navVC = UINavigationController(rootViewController: vc)
            
            self.present(navVC, animated: true, completion: nil)
            
        case rateATopicButton:
            print("Rate A Topic tapped")
//            let vc = PollViewController()
//            vc.navigationItem.title = "Rate a Topic"
//            vc.delegate = delegate
//            let navVC = NavigationViewController(rootViewController: vc)
//            self.present(vc, animated: true, completion: nil)
            
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
        delegate?.sendMessage(using: invite)
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

extension HomeViewController {    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToCalendar" {
            switch self.authorizationStatus {
            case .fullAccess, .writeOnly, .authorized:
                return true
                
            default:
                return false
            }
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStickers" {
            let destinationVC = segue.destination as? StickerViewController
            destinationVC?.delegate = delegate
        if segue.identifier == "goToPollVC" {
            let destinationVC = segue.destination as! RateATopicViewController
            destinationVC.delegate = delegate
        }
    }
}

// MARK: Randomizer View Controller
extension HomeViewController {
    /// Sends a message after tapping the `Done` button within the randomizer ViewController.
    @objc func didTapDone() {
        let people = [Person]()
        let randomizer = Randomizer(people: people)
        delegate?.sendMessage(using: randomizer)
    }
}
