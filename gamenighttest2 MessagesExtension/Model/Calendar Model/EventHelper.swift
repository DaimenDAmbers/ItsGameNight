//
//  EventHelper.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 11/3/23.
//

import UIKit
import EventKit

class EventHelper {
    
    // MARK: Properties
    var store: EKEventStore!
    let defaults = Defaults()
    
    // MARK: Methods
    /*
     Received from here https://stackoverflow.com/questions/28379603/how-to-add-an-event-in-the-device-calendar-using-swift
     */
    /// Create's a calendar event using `EKEvent`
    /// - Returns: Returns a `EKEvent`.
    func createCalendarEvent(with eventStore: EKEventStore) -> EKEvent? {
        // Act base upon the current authorisation status

        self.store = eventStore
        let event: EKEvent = EKEvent(eventStore: self.store)
        
        event.title = "It's Game Night"
        event.startDate = Date.nearestHour(Date())() // Rounds to the nearest hour.
        
        let twoHourInterval = TimeInterval(exactly: 7200) // Creates a two hour interval.
        event.endDate = event.startDate.addingTimeInterval(twoHourInterval!)
        
        event.timeZone = .current
        if let name = defaults.getUsername() {
            event.notes = "\(name) created an event from \"It's Game Night\"."
        } else {
            event.notes = "Event created from \"It's Game Night\"."
        }
        event.calendar = self.store.defaultCalendarForNewEvents
        
        return event
    }
    
    /// Retrieves the calendar invite
    /// - Returns: Returns the calendar invite for a new event store.
    func retrieveCalendarEvent(for event: EKEvent, with eventStore: EKEventStore) -> EKEvent? {
        self.store = eventStore
        let newEvent: EKEvent = EKEvent(eventStore: store)
        
        newEvent.title = event.title
        newEvent.startDate = event.startDate
        newEvent.endDate = event.endDate
        newEvent.notes = event.notes
        newEvent.isAllDay = event.isAllDay
        newEvent.location = event.location
        newEvent.url = event.url
        
        newEvent.calendar = self.store.defaultCalendarForNewEvents
        
        return newEvent
    }
    
    /// Saves the Event using the event and the event store.
    func saveEvent(event: EKEvent, store: EKEventStore) {
        self.store = store
        event.calendar = self.store.defaultCalendarForNewEvents // TODO: Could cause a problem if they change their calendar to a non default calendar then save.
        do {
            try self.store.save(event, span: .thisEvent, commit: true)
            print("Saved event with ID: \(String(describing: event.eventIdentifier))")
        } catch let error as NSError {
            print("Failed to save event with error: \(error)")
        }
    }
    
    /// Checks the authorization status of the user's device
    /// - Parameter eventStore: Pass the event store from the entity that calls this method.
    /// - Returns: Returns an enum for `EKAuthorizationStatus`
    func checkAuthorization(with eventStore: EKEventStore) -> EKAuthorizationStatus {
        let status: EKAuthorizationStatus
        self.store = eventStore
        
        status = EKEventStore.authorizationStatus(for: .event)
        return status
    }
    
    /// Request authorization to use the calendar application.
    func requestAuthorization(with eventStore: EKEventStore) {
        self.store = eventStore
        if #available(iOSApplicationExtension 17.0, *) {
            requestWriteAccessToCalendar()
        } else {
            requestAuthorisationToCalendar()
        }
    }
    
    // MARK: Private Methods
    /// Requests authorization to use the Calendar App.
    private func requestAuthorisationToCalendar() {
        store.requestAccess(to: .event) { (granted, error)  in
            if (granted) && (error == nil) {
                DispatchQueue.main.async {
                    print("User has granted access to calendar")
                }
            } else {
                DispatchQueue.main.async {
                    print("User has denied access to calendar")
                }
            }
        }
    }
    
    @available(iOSApplicationExtension 17.0, *)
    /// Request Full Access to the Calendar App.
    private func requestFullAccessToCalendar() {
        store.requestFullAccessToEvents() { (granted, error) in
            if (granted) && (error == nil) {
                DispatchQueue.main.async {
                    print("User has granted full access to calendar")
                }
            } else {
                DispatchQueue.main.async {
                    print("User has denied access to calendar")
                }
            }
        }
    }
    
    @available(iOSApplicationExtension 17.0, *)
    /// Request Write-Only Access to the Calendar App.
    private func requestWriteAccessToCalendar() {
        store.requestWriteOnlyAccessToEvents() { (granted, error) in
            if (granted) && (error == nil) {
                DispatchQueue.main.async {
                    print("User has granted write-only access to calendar")
                }
            } else {
                DispatchQueue.main.async {
                    print("User has denied access to calendar")
                }
            }
        }
    }
}

extension Date {
    func nearestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
}
