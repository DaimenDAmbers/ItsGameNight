//
//  Vote.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/14/24.
//

import Foundation

enum VotingDecisions: String, CaseIterable {
    case overrated, underrated, properlyRated, didNotVote
}

extension VotingDecisions: CustomStringConvertible {
    var description: String {
        switch self {
            
        case .overrated:
            return "Overrated"
        case .underrated:
            return "Underrated"
        case .properlyRated:
            return "Properly Rated"
        case .didNotVote:
            return "Did not vote"
        }
    }
}

// MARK: - Voting Struct
struct Vote {
    let choice: VotingDecisions
    var isSelected: Bool = false
}


