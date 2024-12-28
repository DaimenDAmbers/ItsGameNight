//
//  TriviaQuestion.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/14/24.
//

import Foundation

struct TriviaAPIData: Codable {
    var id: String
    var category: Category
    var correctAnswer: String
    var incorrectAnswers: [String]
    var question: Question
    var difficulty: Difficulty
    
    struct Question: Codable {
        var text: String
    }
    
    enum Category: String, Codable, CaseIterable, CustomStringConvertible {
        case music = "music"
        case sport_and_leisure = "sport_and_leisure"
        case film_and_tv = "film_and_tv"
        case arts_and_literature = "arts_and_literature"
        case history = "history"
        case society_and_culture = "society_and_culture"
        case science = "science"
        case geography = "geography"
        case food_and_drink = "food_and_drink"
        case general_knowledge = "general_knowledge"
        case any = "any"
        
        var description: String {
            switch self {
                
            case .music:
                return "Music"
            case .sport_and_leisure:
                return "Sport and Leisure"
            case .film_and_tv:
                return "Film and TV"
            case .arts_and_literature:
                return "Arts and Literature"
            case .history:
                return "History"
            case .society_and_culture:
                return "Society and Culture"
            case .science:
                return "Science"
            case .geography:
                return "Geography"
            case .food_and_drink:
                return "Food and Drink"
            case .general_knowledge:
                return "General Knowledge"
            case .any:
                return "Any Category"
            }
        }
    }
    
    enum Difficulty: String, Codable, CaseIterable, CustomStringConvertible {
        case easy, medium, hard, any
        
        var description: String {
            switch self {
                
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
            case .any:
                return "Any"
            }
        }
    }
}
