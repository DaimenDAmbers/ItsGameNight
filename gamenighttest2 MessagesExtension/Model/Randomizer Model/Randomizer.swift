//
//  RandomPersonSelect.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 11/1/23.
//

import UIKit
import Messages

struct Randomizer: MessageTemplateProtocol {
    var people: [Person]
    
    var appState: AppState {
        return .randomizer
    }
    
    var image: UIImage {
        return UIImage(named: "Pie Wheel") ?? UIImage(named: "‎It's Game Night")!
    }
    
    var caption: String {
        return "Randomizer"
    }
    
    var subCaption: String {
        return "Open to see the random selection"
    }
    
    var trailingCaption: String?
    
    var trailingSubcaption: String?
    
    var imageTitle: String?
    
    var imageSubtitle: String?
    
    var summaryText: String?
    
    var sentBy: String?
    
    var localIdentifier: UUID?
    
    var longDescription: String?
    
    init?(people: [Person]) {
        self.people = people
    }
}

extension Randomizer {
    
    func chooseRandomPerson() {
        guard var randomPerson = people.randomElement() else { return }
        
        while randomPerson.isIncluded == false {
            randomPerson = people.randomElement()!
        }
        
        print("The person that was selected is: \(randomPerson.name)")
        randomPerson.isSelected = true
    }
    
    func getNumOfPeople() -> Int {
        return people.count
    }
    
    func returnNames() -> [String] {
        var names = [String]()
        for person in self.people {
            names.append(person.name)
        }
        
        return names
    }
    
    mutating func addNewName(_ person: Person) {
        people.append(person)
    }
}

extension Randomizer {
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        for person in self.people {
            if person.isIncluded == false { continue }
            let newPerson = URLQueryItem(name: "Person", value: person.name)
            let isSelected = URLQueryItem(name: person.name, value: String(person.isSelected))
            items.append(newPerson)
            items.append(isSelected)
        }
        
        items.append(appState.queryItem)
        
        return items
    }
    
    init?(queryItems: [URLQueryItem]) {
        self.people = [Person]()
        
        for queryItem in queryItems {
            
            guard let value = queryItem.value else { continue }
            
            if queryItem.name == "Person" {
                let person = Person()
                person.name = value
                people.append(person)
            }
            
            for person in self.people {
                if queryItem.name == person.name && queryItem.value == "true" {
                    person.isSelected = true
                }
            }
        }
    }
}

// MARK: - Message Initialization
extension Randomizer {

    // MARK: Initialization for messages
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = urlComponents.queryItems else { return nil }
        self.init(queryItems: queryItems)
    }
}
