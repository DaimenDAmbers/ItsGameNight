//
//  PlayerProfile.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 3/16/25.
//

import Foundation

struct PlayerProfile {
    static var shared = PlayerProfile()
    var points: Int = 0
    
    func receivePoints(_ points: Int) {
        PlayerProfile.shared.points += points
        print("Number of points: \(PlayerProfile.shared.points)")
    }
}
