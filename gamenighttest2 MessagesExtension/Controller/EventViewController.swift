//
//  EventViewController.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/22/23.
//

import UIKit
import EventKitUI
import Messages

class EventViewController: EKEventEditViewController, UINavigationControllerDelegate {
//    weak var myDelegate: EventViewControllerDelegate?
    var conversation: MSConversation?
    
//    @objc func didTapAdd() {
//        print("Add tapped")
//        myDelegate?.sendEventMessage()
//    }
    
    
//    func createEvent() {
//        let eventStore: EKEventStore = EKEventStore()
//        
//        eventStore.requestAccess(to: .event, completion: { (success, error) in
//            if (success) && (error == nil) {
//                DispatchQueue.main.async {
//                    print("granted \(success)")
//                    print("error \(String(describing: error))")
//                    
//                    let event: EKEvent = EKEvent(eventStore: eventStore)
//                    
//                    event.title = "It's Game Night"
//                    event.startDate = Date()
//                    event.endDate = Date()
//                    event.notes = "Event created from \"It's Game Night\"."
//                    event.calendar = eventStore.defaultCalendarForNewEvents
//                    
//                    let editVC: EKEventEditViewController = EventViewController()
//                    editVC.eventStore = eventStore
//                    editVC.event = event
//                    editVC.delegate = self
//                    editVC.editViewDelegate = self
//                    self.present(editVC, animated: true, completion: nil) // FIXME: Getting a double modal with this implementation
//                    
//                }
//                
//            } else {
//                print("Failed to save event with error: \(String(describing: error)) or access not granted.")
//            }
//        })
//    }
}                                 
