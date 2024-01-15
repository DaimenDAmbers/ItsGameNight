//
//  Poll.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/10/24.
//

import UIKit
import EventKit
import Messages

// MARK: - Poll Structure
struct Poll: MessageTemplateProtocol {
//    var vote: Vote
    var question: String
    var votes: [VotingDecisions: Int]
    var overrated: Int
    var underrated: Int
    var properlyRated: Int
    private var totalVotes: Int {
        return overrated + underrated + properlyRated
    }
    
    var isOverrated: Bool = false
    var isUnderrated: Bool = false
    var isProperlyRated: Bool = false
    
    var appState: AppState {
        return .poll
    }
    
    var image: UIImage {
        return UIImage(named: "It's Game Night") ?? UIImage(named: "‎It's Game Night")!
    }
    
    var caption: String {
        return "Game Night Topic"
    }
    
    var subCaption: String {
        return "How would you rate this topic?"
    }
    
    init?(question: String, votes: [VotingDecisions: Int], overrated: Int, underrated: Int, properlyRated: Int) {
        self.question = question
        self.votes = votes
        self.overrated = overrated
        self.underrated = underrated
        self.properlyRated = properlyRated
    }
}


// MARK: - Query Items
extension Poll {
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        let question = URLQueryItem(name: "Question", value: self.question)
        let overrated = URLQueryItem(name: "Overrated", value: String(self.votes[.overrated] ?? 0))
        let underrated = URLQueryItem(name: "Underrated", value: String(self.votes[.underrated] ?? 0))
        let properlyRated = URLQueryItem(name: "Properly Rated", value: String(self.votes[.properlyRated] ?? 0))
        
        items.append(question)
        items.append(overrated)
        items.append(underrated)
        items.append(properlyRated)
        items.append(appState.queryItem)
        
        return items
    }
    
    init?(queryItems: [URLQueryItem]) {
        self.question = String()
        self.overrated = 0
        self.underrated = 0
        self.properlyRated = 0
        
        self.votes = [:]
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if queryItem.name == "Question" {
                question = value
            }
            
            if queryItem.name == "Overrated" {
//                overrated = Int(value) ?? 0
                votes[VotingDecisions.overrated] = Int(value) ?? 0
            }
            
            if queryItem.name == "Underrated" {
//                underrated = Int(value) ?? 0
                votes[VotingDecisions.underrated] = Int(value) ?? 0
            }
            
            if queryItem.name == "Properly Rated" {
//                properlyRated = Int(value) ?? 0
                votes[VotingDecisions.properlyRated] = Int(value) ?? 0
            }
        }
    }
}

// MARK: - Message Initialization
extension Poll {

    // MARK: Initialization for messages
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = urlComponents.queryItems else { return nil }
        self.init(queryItems: queryItems)
    }
}
