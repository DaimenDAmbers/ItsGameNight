//
//  TriviaModel.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/19/24.
//

import Foundation

struct TriviaModel {
    var id: String
    var category: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    var question: String
    var difficulty: String
    var questionType: QuestionType?
}

extension TriviaModel {
    enum QuestionType: String, QueryItemRepresentable, CustomStringConvertible {
        case single, quiz
        var queryItemKey: String {
            return "questionType"
        }
        
        var queryItemValue: String {
            return self.description
        }
        
        var description: String {
            switch self {
            case .single:
                return "One Question"
            case .quiz:
                return "Quiz"
            }
        }
    }
}
