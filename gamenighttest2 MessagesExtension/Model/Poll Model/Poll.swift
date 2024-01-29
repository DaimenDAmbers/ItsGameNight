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
    var overratedVotes: Int {
        return votes[.overrated] ?? 0
    }
    var underratedVotes: Int {
        return votes[.underrated] ?? 0
    }
    var properlyRatedVotes: Int {
        return votes[.properlyRated] ?? 0
    }
    var totalVotes: Int {
        return overratedVotes + underratedVotes + properlyRatedVotes
    }
    
    var isOverrated: Bool = false
    var isUnderrated: Bool = false
    var isProperlyRated: Bool = false
    
    var appState: AppState {
        return .poll
    }
    
//    var image: UIImage {
//        return UIImage(named: "It's Game Night") ?? UIImage(named: "‎It's Game Night")!
//    }
    
    var image: UIImage
    
    var caption: String {
        return "What's your vote?"
    }
    
    var subCaption: String {
        return "Overrated: \(overratedVotes)\nUnderrated: \(underratedVotes)\nProperlyRated: \(properlyRatedVotes)"
    }
    
    init?(question: String, votes: [VotingDecisions: Int], image: UIImage) {
        self.question = question
        self.votes = votes
        self.image = image
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
        self.votes = [:]
        self.image = UIImage(named: "It's Game Night") ?? UIImage(named: "‎It's Game Night")!
        
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
