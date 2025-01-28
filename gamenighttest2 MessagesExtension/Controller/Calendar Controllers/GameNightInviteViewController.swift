//
//  CalendarViewController.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/24/23.
//

import UIKit
import Messages
import EventKit
import EventKitUI
import GoogleMobileAds

class GameNightInviteViewController: UIViewController {
    
    // MARK: Variables
    static let storyboardIdentifier = "GameNightInviteViewController"
    weak var delegate: MessageDelegate?
    let eventHelper = EventHelper()
    let eventStore = EKEventStore()
    let systemAlerts = SystemAlerts()
    var invite: CalendarInvite?
    var authorizationStatus: EKAuthorizationStatus = .notDetermined

    // MARK: View Variables
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var gameNightDetailsLabel: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var startTimeText: UILabel!
    @IBOutlet weak var endTimeText: UILabel!
    
    // MARK: Google Ads
    var bannerView: GADBannerView!

    // MARK: Methods
    override func viewDidLoad() {
        guard let unwrappedInvite = invite else { fatalError("No Invitation.") }
        let title: String
        let date: String
        let startTime: String
        let endTime: String
        let dateFormatter = DateFormatter()
        
        title = unwrappedInvite.event.title
        
        dateFormatter.dateFormat = "EEEE, MMMM d, YYYY"
        date = dateFormatter.string(from: unwrappedInvite.event.startDate)
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        startTime = dateFormatter.string(from: unwrappedInvite.event.startDate)
        endTime = dateFormatter.string(from: unwrappedInvite.event.endDate)
        
        if let username = unwrappedInvite.sentBy {
            gameNightDetailsLabel.text = "\(username) scheduled the next Game Night!"
        } else {
            gameNightDetailsLabel.text = "The next Game Night has been scheduled!"
        }

        titleText.text = title
        dateText.text = date
        startTimeText.text = startTime
        endTimeText.text = endTime
        
        saveButton.applyShadow(cornerRadius: 5)
        
        var googleAdsManager = GoogleAdsManager(controller: self)
        bannerView = googleAdsManager.createBannerAd()
        self.addBannerViewToView(bannerView)
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Save Button Tapped")
        self.authorizationStatus = eventHelper.checkAuthorization(with: self.eventStore)
        
        switch authorizationStatus {
        case .fullAccess, .writeOnly, .authorized:
            if let event = invite?.event { // Checks to see if there is an event in Calendar Invite
                guard let newEvent = eventHelper.retrieveCalendarEvent(for: event, with: eventStore) else { // Checks to see if the user has access to the Calendar App to view the event
                    return
                }
                    
                presentVC(with: newEvent)
            }
            
        case .notDetermined:
            eventHelper.requestAuthorization(with: self.eventStore)
            
        default:
            self.present(systemAlerts.showCalendarPermissionAlert(), animated: true, completion: nil)
        }
    }
}

// MARK: - Extensions
extension GameNightInviteViewController: UINavigationControllerDelegate, EKEventEditViewDelegate {
    
    /// Presents the ViewController when the `Save Event` button is tapped.
    private func presentVC(with event: EKEvent) {
        let editVC: EKEventEditViewController = CalendarViewController()
        editVC.eventStore = self.eventStore
        editVC.event = event
        editVC.delegate = self
        editVC.editViewDelegate = self
        self.present(editVC, animated: true, completion: nil)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension GameNightInviteViewController {
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
}
