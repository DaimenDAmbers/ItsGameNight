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
    static let noUserName = "No name"
    
    
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
                    This feature allows you to send a question for a specific category and difficulty. There are 10 categories and 3 difficulites to choose from. You also have the option to select "Any" for the category or difficuly if it does not matter. After the message is sent, you will be able to see the question and select your answer. The results of each submission are shown after you have selected your choice.
                    """
        static let scheduler =
                    """
                    The Scheduler allows you to schedule your next game night directly from the app. The event will show up in your calendar instantly when the message is created and sent, while allowing your receipient to also receive the details of the next game night. The recipient can then add the game night to their calendar.
                    """
        static let randomizer =
                    """
                    The Randomizer allows your to create and choose from a list of items to spin on a wheel. The winner is selected before being sent so that the same winner will be shown for you and your recipient.
                    """
        static let rateATopic =
                    """
                    Have you and your friends vote on a hot topic or an unpopular opinion. The choices for the votes are either Overrated, Underrated or Properly Rate. The answers are also tracked so that you can see who voted for which answer.
                    """
        static let stickers =
                    """
                    This sticker pack allows you to peel and stick these images onto messages in the conversation. You can also simply tap the sticker and send it as a picture.
                    """
    }
}
