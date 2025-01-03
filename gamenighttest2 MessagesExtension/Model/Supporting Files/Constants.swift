//
//  Constants.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 3/21/24.
//

import Foundation

struct Constants {
    static let menuBackground = "MenuBackground"
    static let gameNightBackground = "GameNightBackground"
    static let username = "username"
    static let developerEmail = "daimenambers@yahoo.com"
    static let hapticFeedback = "Haptic Feedback"
    static let noUserName = "Gamenight User"
    
    
    /// Tiles on the home screen
    struct ImageTiles {
        static let calendar = "Calendar"
        static let pieWheel = "Pie Wheel"
        static let rateATopic = "Rate A Topic"
        static let stickers = "It's Game Night"
        static let trivia = "Trivia"
        static let logo = "It's Game Night"
    }
    
    /// Long descriptions of the apps functions
    struct CoreInfoLongDescription {
        static let trivia =
                    """
                    Here's the long description for Trivia
                    """
        static let scheduler =
                    """
                    Here's the long description for the Scheduler
                    """
        static let randomizer =
                    """
                    Here's the long description for the Randomizer
                    """
        static let rateATopic =
                    """
                    Here's the long description for Rate a Topic
                    """
        static let stickers =
                    """
                    Here's the long description for Stickers
                    """
    }
}
