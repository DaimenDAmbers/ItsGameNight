//
//  Defaults.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 3/26/24.
//

import Foundation

struct Defaults {
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Username settings
    func getUsername() -> String {
        if let name = userDefaults.string(forKey: Constants.username), !name.trimmingCharacters(in: .whitespaces).isEmpty {
            return name
        } else {
            return Constants.noUserName
        }
    }
    
    /// Updates the username
    func setUserName(_ name: String) {
        userDefaults.set(name, forKey: Constants.username)
        print("Username updated successfully. Name is \(name).")
    }
    
    // MARK: - Haptic Feedback
    
    /// Returns the value of the haptic feedback settings
    func getHapticFeedbackSetting() -> Bool {
        let hapticFeedbackSetting = userDefaults.bool(forKey: Constants.hapticFeedback)
        return hapticFeedbackSetting
    }
    
    /// Updates the haptic feedback setting
    /// - Parameter value: This value is either true or false
    func updateHapticFeedback(_ value: Bool) {
        userDefaults.set(value, forKey: Constants.hapticFeedback)
        print("Haptic feedback is set to \(value).")
    }
    
    // MARK: - Trivia Score
    
    /// Gets the total score for the player
    func getScore() -> Int {
        let score = userDefaults.integer(forKey: Constants.score)
        return score
    }
    
    /// This method is used to update the points for the player
    /// - Parameter pointsEarned: An `Int` for the number of points the player received.
    func updateScore(_ pointsEarned: Int) {
        var score = userDefaults.integer(forKey: Constants.score)
        score += pointsEarned
        userDefaults.set(score,forKey: Constants.score)
        
        print("\(pointsEarned) added to score. User has a total of \(score) point(s).")
    }
    
    func resetScore() {
        userDefaults.set(0, forKey: Constants.score)
        print("Score for user has been reset to 0.")
    }
}
