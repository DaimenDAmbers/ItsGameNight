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
    var authorizationStatus: EKAuthorizationStatus = .notDetermined
    var menuItems: [MenuItem] = []
    let defaults = Defaults()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        collectionView.register(HomeCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeCollectionViewCell.idendifier)
        
        let triviaMenuItem = MenuItem(label: "Trivia", image: UIImage(named: Constants.ImageTiles.trivia), score: defaults.getScore())
        let calendarMenuItem = MenuItem(label: "Scheduler", image: UIImage(named: Constants.ImageTiles.calendar))
        let randomizerMenuItem = MenuItem(label: "Randomizer", image: UIImage(named: Constants.ImageTiles.pieWheel))
        let pollMenuItem = MenuItem(label: "Rate a Topic", image: UIImage(named: Constants.ImageTiles.rateATopic))
        let stickerMenuItem = MenuItem(label: "Stickers", image: UIImage(named: Constants.ImageTiles.stickers))
        
        menuItems = [triviaMenuItem, calendarMenuItem, randomizerMenuItem, pollMenuItem, stickerMenuItem]
        
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(self.infoButtonTapped))
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    // MARK: Methods
    @objc private func infoButtonTapped() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: SettingsViewController.storyboardIdentifier) as? SettingsViewController else {
            fatalError("Unable to instantiate a SettingsViewController from the storyboard")
        }
        
        controller.navigationItem.title = "Settings"
        let navVC = UINavigationController(rootViewController: controller)
        
        self.present(navVC, animated: true, completion: nil)
    }
    
    /// Method to open the functionaility for the Calendar Invites
    private func openCalendarInvite() {
        self.authorizationStatus = eventHelper.checkAuthorization(with: self.eventStore)
        
        switch authorizationStatus {
        case .fullAccess, .writeOnly, .authorized:
            if let event = eventHelper.createCalendarEvent(with: self.eventStore) {
                presentVC(with: event)
            }
            
        case .notDetermined:
            eventHelper.requestAuthorization(with: self.eventStore)
            
        default:
            SystemAlerts.showCalendarPermissionAlert(on: self)
        }
    }
    
    /// Method to open the functionaility for the Randomizer
    private func openRandomizer() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: SelectPeopleViewController.storyboardIdentifier) as? SelectPeopleViewController else {
            fatalError("Unable to instantiate a SelectPeopleViewController from the storyboard")
        }
        
        controller.navigationItem.title = "Randomizer"
        controller.navigationItem.rightBarButtonItems = []
        controller.delegate = delegate
        controller.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PersonCell")

        let navVC = UINavigationController(rootViewController: controller)
        
        self.present(navVC, animated: true, completion: nil)
    }
    
    /// Method to open the functionaility for the Polls
    private func openRateATopic() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: RateATopicViewController.storyboardIdentifier) as? RateATopicViewController else {
            fatalError("Unable to instantiate a RateATopicViewController from the storyboard")
        }
        
        controller.delegate = delegate
        present(controller, animated: true, completion: nil)
    }
    
    /// Method to open the functionaility for the Stickers
    private func openStickers() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: StickerViewController.storyboardIdentifier) as? StickerViewController else {
            fatalError("Unable to instantiate a StickerViewController from the storyboard")
        }
        
        controller.delegate = delegate
        
        let navVC = UINavigationController(rootViewController: controller)
        self.present(navVC, animated: true, completion: nil)
    }
    
    /// Method to open the functionality for Trivia
    private func openTrivia() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: SelectModeViewController.storyboardIdentifier) as? SelectModeViewController else {
            fatalError("Unable to instantiate a CategoryViewController from the storyboard")
        }
        
        controller.navigationItem.title = "Trivia"
        controller.delegate = delegate
        
        let navVC = UINavigationController(rootViewController: controller)
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func openInfo(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: CoreInfoViewController.storyboardIdentifier) as? CoreInfoViewController else {
            fatalError("Unable to instantiate a ViewController from the storyboard")
        }
        if sender.tag == 0 {
            controller.navigationItem.title = "Trivia"
            controller.longDescription = Constants.CoreInfoLongDescription.trivia
        } else if sender.tag == 1 {
            controller.navigationItem.title = "Scheduler"
            controller.longDescription = Constants.CoreInfoLongDescription.scheduler
        } else if sender.tag == 2 {
            controller.navigationItem.title = "Randomizer"
            controller.longDescription = Constants.CoreInfoLongDescription.randomizer
        } else if sender.tag == 3 {
            controller.navigationItem.title = "Rate a Topic"
            controller.longDescription = Constants.CoreInfoLongDescription.rateATopic
        } else {
            controller.navigationItem.title = "Stickers"
            controller.longDescription = Constants.CoreInfoLongDescription.stickers
        }
        
        let navVC = UINavigationController(rootViewController: controller)
        self.present(navVC, animated: true, completion: nil)
    }
}

// MARK: - EKEventEditViewDelegate
extension HomeViewController: EKEventEditViewDelegate, UINavigationControllerDelegate {
    
    /// This method checks for actions on the Calendar Invite modal. This runs when either cancel or save is tapped.
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
        invite?.sentBy = defaults.getUsername()
        delegate?.sendMessage(using: invite, isNewMessage: true, sendImmediately: false)
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
}

// MARK: Collection View for the Home Screen
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let inset: CGFloat = 20
        
        /// This is the number of rows that we want for the collection view.
        let cellColumns: CGFloat = 1.0
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        let space: CGFloat = (layout.minimumInteritemSpacing) + (layout.sectionInset.left) + (layout.sectionInset.right)
        let size:CGFloat = (collectionView.frame.size.height - space) / cellColumns
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.idendifier, for: indexPath) as! HomeCollectionViewCell
        
        // Configure the cell
        let menuItem = menuItems[indexPath.row]
        cell.label.text = menuItem.label
        cell.image.image = menuItem.image
        cell.pointLabel.text = menuItem.pointLabel
        cell.infoButton.tag = indexPath.row
        cell.infoButton.addTarget(self, action: #selector(openInfo), for: UIControl.Event.touchUpInside)
        cell.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Item selected \(indexPath.row)")
        
        if indexPath.row == 0 {
            openTrivia()
        } else if indexPath.row == 1 {
            openCalendarInvite()
        } else if indexPath.row == 2 {
            openRandomizer()
        } else if indexPath.row == 3 {
            openRateATopic()
        } else {
            openStickers()
        }
    }
    
    @objc private func cardInfoButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            openTrivia()
        } else if sender.tag == 1 {
            openCalendarInvite()
        } else if sender.tag == 2 {
            openRandomizer()
        } else if sender.tag == 3 {
            openRateATopic()
        } else {
            openStickers()
        }
    }
}
