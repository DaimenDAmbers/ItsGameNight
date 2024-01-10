//
//  Poll.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/10/24.
//

import UIKit
import EventKit
import Messages

// MARK: - Voting Enumeration
enum Vote {
    
    case overrated(Int), underrated(Int), properlyRated(Int), didNotVote(Int)
 
    var value: Int {
        switch self {
            
        case let .overrated(votes):
            return votes
        case let .underrated(votes):
            return votes
        case let .properlyRated(votes):
            return votes
        case let .didNotVote(votes):
            return votes
        }
    }
}

extension Vote: CustomStringConvertible {
    var description: String {
        switch self {
            
        case .overrated(_):
            return "Overrated"
        case .underrated(_):
            return "Underrated"
        case .properlyRated(_):
            return "Properly Rated"
        case .didNotVote(_):
            return "Did not vote"
            
        }
    }
}

// MARK: - Poll Structure
struct Poll: MessageTemplateProtocol {
//    var vote: Vote
    var question: String
    var overrated: Int
    var underrated: Int
    var properlyRated: Int
    
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
    
    init?(question: String, overrated: Int, underrated: Int, properlyRated: Int) {
        self.question = question
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
        let overrated = URLQueryItem(name: "Overrated", value: String(self.overrated))
        let underrated = URLQueryItem(name: "Underrated", value: String(self.underrated))
        let properlyRated = URLQueryItem(name: "Properly Rated", value: String(self.properlyRated))
        
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
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if queryItem.name == "Question" {
                question = value
            }
            
            if queryItem.name == "Overrated" {
                overrated = Int(value) ?? 0
            }
            
            if queryItem.name == "Underrated" {
                underrated = Int(value) ?? 0
            }
            
            if queryItem.name == "Properly Rated" {
                properlyRated = Int(value) ?? 0
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
