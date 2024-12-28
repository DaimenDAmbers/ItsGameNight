//
//  AppState.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/24/23.
//

import Foundation

enum AppState: String {
    case home, gameInvite, randomizer, poll, trivia
}

extension AppState: QueryItemRepresentable {
    var queryItemKey: String {
        return "App State"
    }
    
    var queryItemValue: String {
        return self.rawValue
    }
}
