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
    
    // MARK: Poll Variables
    var question: String
//    var votes: [VotingDecisions: Int]
    var votes: [Vote]?
    var image: UIImage
    
    var overratedVotes: Int {
        return getNumOfVotes(for: .overrated)
    }
    var underratedVotes: Int {
        return getNumOfVotes(for: .underrated)
    }
    var properlyRatedVotes: Int {
        return getNumOfVotes(for: .properlyRated)
    }
    var totalVotes: Int {
        return overratedVotes + underratedVotes + properlyRatedVotes
    }
    
    // MARK: Protocol Variables
    var appState: AppState {
        return .poll
    }
    
    var caption: String {
        return "What's your rating?"
    }
    
    var subCaption: String {
        return "Overrated: \(overratedVotes)\nUnderrated: \(underratedVotes)\nProperly Rated: \(properlyRatedVotes)"
    }
    
    /// This is populated if the user adds their name to the app in the Settigns.
    var sentBy: String?
    
    var summaryText: String?
    
    init?(question: String, votes: [Vote]? = nil, image: UIImage, sentBy: String?) {
        self.question = question
        self.votes = votes
        self.image = image
        
        if let sentBy = sentBy {
            self.sentBy = "Question sent by \(sentBy)"
        }
    }
    
    /// Summary text is created if the user has added their name to the app in Settings
    mutating func createSummaryText(for name: String?, with decision: VotingDecisions) {
        guard let name = name else { return }
        self.summaryText = "\(name) voted \(decision.description)"
    }
    
    func getNumOfVotes(for descision: VotingDecisions) -> Int {
        guard let votes = votes else { return 0 }
        var numOfVotes = Int()
        for vote in votes {
            if vote.choice == descision {
                numOfVotes+=1
            }
        }
        return numOfVotes
    }
    
    func returnVotes(for decision: VotingDecisions) -> [Vote]? {
        guard let votes = votes else { return nil }
        var specificVotes = [Vote]()
        for vote in votes {
            if vote.choice == decision {
                specificVotes.append(vote)
            }
        }
        
        return specificVotes
    }
}

// MARK: - Query Items
extension Poll {
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        let question = URLQueryItem(name: "Question", value: self.question)
        
        if let votes = votes {
            for vote in votes {
                
                let voterDescision = URLQueryItem(name: vote.choice.description, value: vote.voterName?.description ?? "Anonymous")
                items.append(voterDescision)
            }
        }
        
        let sentBy = URLQueryItem(name: "Sent By", value: self.sentBy)
        
        items.append(question)
        items.append(sentBy)
        items.append(appState.queryItem)
        
        return items
    }
    
    init?(queryItems: [URLQueryItem]) {
        self.question = String()        
        self.votes = [Vote]()
        self.image = UIImage(named: "It's Game Night") ?? UIImage(named: "‎It's Game Night")!
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if queryItem.name == "Question" {
                question = value
            }

            if queryItem.name == "Overrated" {
                let vote = Vote(choice: .overrated, voterName: value)
                votes!.append(vote)
            }
            
            if queryItem.name == "Underrated" {
                let vote = Vote(choice: .underrated, voterName: value)
                votes!.append(vote)
            }
            
            if queryItem.name == "Properly Rated" {
                let vote = Vote(choice: .properlyRated, voterName: value)
                votes!.append(vote)
            }
            
            if queryItem.name == "Sent By" {
                sentBy = value
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
