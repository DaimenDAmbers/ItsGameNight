//
//  RandomPersonSelect.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 11/1/23.
//

import UIKit
import Messages

struct RandomPerson: MessageTemplateProtocol {
    var names: [String] = ["Daimen", "Charlese", "Justin", "Austyn", "Ashley", "Tyson"]
    
    var appState: AppState {
        return .home
    }
    
    var image: UIImage {
        return UIImage(named: "It's Game Night") ?? UIImage(named: "‎Let's Coast Logo")!
    }
    
    var caption: String {
        return "Who Was Chosen???"
    }
    
    var subCaption: String {
        return "A person from the group was selected at Random."
    }
}

extension RandomPerson {
    
    /// Returns a random person from the group chat.
    /// - Returns: Returns the random person's name.
    func returnPerson(from conversation: MSConversation?) -> String {
        guard let conversation = conversation else { fatalError("Could not find a conversation inside the selectRandomPerson function.") }
        
        var people = [String]()
        people.append(conversation.localParticipantIdentifier.uuidString)
        
        for person in conversation.remoteParticipantIdentifiers {
            people.append(person.uuidString)
        }
        
        // TODO: Uncomment to pull from conversation
        //    guard let name = people.randomElement() else {
        //        return "No names Available"
        //    }
        
        // TODO: This is testing purposes
        let testNames = ["Daimen", "Charlese", "Justin", "Austyn", "Ashley", "Tyson"]
        let name = testNames.randomElement()!
        
        
        print("Available names: \(people)")
        return name
    }
    
    func returnNumOfPeople() -> Int {
        return names.count
    }
    
    func returnNames() -> [String]{        
        return names
    }
    
    mutating func addNewName(_ name: String) {
        names.append(name)
    }
}
