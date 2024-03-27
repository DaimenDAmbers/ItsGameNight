//
//  Defaults.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 3/26/24.
//

import Foundation

struct Defaults {
    private let userDefaults = UserDefaults.standard
    
    func getUsername() -> String? {
        if let name = userDefaults.string(forKey: Constans.username), !name.trimmingCharacters(in: .whitespaces).isEmpty {
            return name
        } else {
            return nil
        }
    }
}
