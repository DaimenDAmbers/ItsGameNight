//
//  CalendarInvite.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/29/23.
//

import UIKit
import EventKit
import Messages

struct CalendarInvite: MessageTemplateProtocol {
    // MARK: Calendar Variables
    var event: EKEvent
    var eventStore: EKEventStore
    var identifier: String?
    var store: String?
    
    // MARK: Protocol variables Template
    var appState: AppState {
        return .gameInvite
    }
    
    var title: String {
        return "It's Game Night"
    }
    
    var image: UIImage {
        return UIImage(named: "Calendar") ?? UIImage(named: "‎It's Game Night")!
    }
    
    var caption: String {
        return "Game Night Invite"
    }
    
    var subCaption: String {
        return "Open to see the next scheduled Game Night"
    }
    
    var trailingCaption: String?
    
    var trailingSubcaption: String?
    
    var imageTitle: String?
    
    var imageSubtitle: String?
    
    var summaryText: String?
    
    var sentBy: String?
    
    var senderID: UUID?
    
    /// - Tag: QueryItems
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        
        let title = URLQueryItem(name: "Title", value: event.title)
        let isAllDay = URLQueryItem(name: "All Day Checkbox", value: String(event.isAllDay))
        let startDate = URLQueryItem(name: "Start Date", value: formatter.string(from: event.startDate))
        let endDate = URLQueryItem(name: "End Date", value: formatter.string(from: event.endDate))
        let location = URLQueryItem(name: "Location", value: event.location)
        let notes = URLQueryItem(name: "Notes", value: event.notes)
        let url = URLQueryItem(name: "Url", value: event.url?.absoluteString)
        let identifier = URLQueryItem(name: "Event Identifier", value: event.eventIdentifier)
        let sentBy = URLQueryItem(name: "Sent By", value: self.sentBy)
        
        // TODO: Phase 2 - Save the event on send.
//        let store = URLQueryItem(name: "Event Store", value: eventStore.description)
//        print("Here is the calendar in the queryItems: \(eventStore.defaultCalendarForNewEvents)")
        
        items.append(title)
        items.append(isAllDay)
        items.append(startDate)
        items.append(endDate)
        items.append(location)
        items.append(notes)
        items.append(url)
        items.append(identifier)
        items.append(sentBy)
//        items.append(store)  // PHASE 2
        
        items.append(appState.queryItem)
    
        return items
    }
    
    init?(event: EKEvent, eventStore: EKEventStore) {
        self.event = event
        self.eventStore = eventStore
    }
    
    /// The query items that are retrieved fromt the URLQueryItems Message.
    init?(queryItems: [URLQueryItem]) {
        self.eventStore = EKEventStore()
        self.event = EKEvent(eventStore: eventStore)
        
        for queryItem in queryItems {

            guard let value = queryItem.value else { continue }
            
            if queryItem.name == "Title" {
                event.title = value
            }
            
            if queryItem.name == "All Day Checkbox" {
                event.isAllDay = Bool(value) ?? false
            }
            
            if queryItem.name == "Start Date" {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
                
                event.startDate = formatter.date(from: value)!
            }
            
            if queryItem.name == "End Date" {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
                
                event.endDate = formatter.date(from: value)!
            }
            
            if queryItem.name == "Location" {
                event.location = value
            }
            
            if queryItem.name == "Notes" {
                event.notes = value
            }
            
            if queryItem.name == "Url" {
                let url = URL(string: value)
                event.url = url
            }
            
            if queryItem.name == "Event Identifier" {
                identifier = value
            }
            
            if queryItem.name == "Sent By" {
                sentBy = value
            }
            
            // TODO: Phase 2 for saving on send.
//            if queryItem.name == "Event Store" {
//                store = value
//            }
        }
    }
}

// MARK: - Message Initialization
extension CalendarInvite {

    // MARK: Initialization for messages
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = urlComponents.queryItems else { return nil }
        self.init(queryItems: queryItems)
    }
}
