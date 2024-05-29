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
    var menuItems: [MenuItem] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        collectionView.register(HomeCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeCollectionViewCell.idendifier)
        
        let calendarMenuItem = MenuItem(label: "Scheduler", image: UIImage(named: Constans.ImageTiles.calendar))
        let randomizerMenuItem = MenuItem(label: "Randomizer", image: UIImage(named: Constans.ImageTiles.pieWheel))
        let pollMenuItem = MenuItem(label: "Rate a Topic", image: UIImage(named: Constans.ImageTiles.rateATopic))
        let stickerMenuItem = MenuItem(label: "Stickers", image: UIImage(named: Constans.ImageTiles.stickers))
        
        menuItems = [calendarMenuItem, randomizerMenuItem, pollMenuItem, stickerMenuItem]
        
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(self.infoButtonTapped))
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    // MARK: Methods
    @objc private func infoButtonTapped() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: InfoViewController.storyboardIdentifier) as? InfoViewController else {
            fatalError("Unable to instantiate a InfoViewController from the storyboard")
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
            self.present(systemAlerts.showCalendarPermissionAlert(), animated: true, completion: nil)
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
        delegate?.sendMessage(using: invite, isNewMessage: true)
    }
    
    /// Presents the ViewController after the `Schedule a Game Night` button is tapped
    private func presentVC(with event: EKEvent) {
        let editVC: EKEventEditViewController = CalendarViewController() // Needed to be able to dismiss modal even after changing the presentation style
//        guard let controller = storyboard?.instantiateViewController(withIdentifier: CalendarViewController.storyboardIdentifier) as? CalendarViewController else {
//            fatalError("Unable to instantiate a CalendarViewController from the storyboard")
//        }
        
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
//
//// MARK: Randomizer View Controller
//extension HomeViewController {
//    /// Sends a message after tapping the `Done` button within the randomizer ViewController.
//    @objc func didTapDone() {
//        let people = [Person]()
//        let randomizer = Randomizer(people: people)
//        delegate?.sendMessage(using: randomizer, isNewMessage: true)
//    }
//}

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
        cell.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Item selected \(indexPath.row)")
        
        if indexPath.row == 0 {
            openCalendarInvite()
        } else if indexPath.row == 1 {
            openRandomizer()
        } else if indexPath.row == 2 {
            openRateATopic()
        } else {
            openStickers()
        }
    }
}
