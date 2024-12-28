//
//  TriviaMessage.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/14/24.
//

import UIKit
import Messages


// MARK: Trivia Structure
struct TriviaMessage: MessageTemplateProtocol {
    
    // MARK: Unique Trivia Varibles
    var triviaModel: TriviaModel
    var submissions = [TriviaMessage.PersonSubmission]()
    var incorrectAnswer_1: String {
        return triviaModel.incorrectAnswers[0]
    }
    
    var incorrectAnswer_2: String {
        return triviaModel.incorrectAnswers[1]
    }
    
    var incorrectAnswer_3: String {
        return triviaModel.incorrectAnswers[2]
    }
    
    var correctAnswer: String {
        return triviaModel.correctAnswer
    }
    
    var correctAnswerIndex: Int {
        for index in 0..<shuffledAnswers.count {
            if shuffledAnswers[index] == correctAnswer {
                return index
            }
        }
        return 0
    }
    
    var shuffledAnswers: [String]
    
    // MARK: Message Protocol Variables
    var appState: AppState {
        return .trivia
    }
    
    var image: UIImage {
        return UIImage(named: "Calendar") ?? UIImage(named: "It's Game Night")!
    }
    
    var caption: String {
        return "Trivia Time!"
    }
    
    var subCaption: String {
        return triviaModel.question
    }
    
    var trailingCaption: String?
    
    var trailingSubcaption: String?
    
    var imageTitle: String?
    
    var imageSubtitle: String?
    
    var summaryText: String?
    
    var sentBy: String?
    
    var senderID: UUID?
    
    init?(triviaModel: TriviaModel, submissions: [TriviaMessage.PersonSubmission], sentby: String? = nil, questionType: TriviaModel.QuestionType) {
        self.triviaModel = triviaModel
        self.submissions = submissions
        self.sentBy = sentby
        self.trailingCaption = questionType.description
        
        var answers: [String] = triviaModel.incorrectAnswers
        answers.append(triviaModel.correctAnswer)
        answers.shuffle()
        self.shuffledAnswers = answers
    }
    
    // MARK: Functions
    
    /// Checks is the selected answer is the correct answer.
    /// - Parameter value: This is the `String` value of the answer.
    /// - Returns: Returns true if it matches the answer.
    func checkIfAnswerIsCorrect(_ value: String) -> Bool {
        if value == triviaModel.correctAnswer {
            return true
        } else {
            return false
        }
    }
    
    func checkIfPersonAnswered(id: UUID?) -> Bool {
        if id == senderID {
            return true
        } else {
            return false
        }
    }
    
    /// Assigns the user's answer to a QueryItem for any answer
    /// - Parameter value: The answer that was selected
    func setUserAnswer(for value: String) -> String {
        var userAnswer = String()
        if value == incorrectAnswer_1 {
            userAnswer = "incorrectAnswer_1"
        } else if value == incorrectAnswer_2 {
            userAnswer = "incorrectAnswer_2"
        } else if value == incorrectAnswer_3 {
            userAnswer = "incorrectAnswer_3"
        } else {
            userAnswer = "correctAnswer"
        }
        
        return userAnswer
    }
    
    /// Fetches the user's answer from the QueryItem
    /// - Parameter value: String value for the queryItem
    func fetechUserAnswer(for value: String) -> String {
        var userAnswer = String()
        if value == "incorrectAnswer_1" {
            userAnswer = incorrectAnswer_1
        } else if value == "incorrectAnswer_2" {
            userAnswer = incorrectAnswer_2
        } else if value == "incorrectAnswer_3" {
            userAnswer = incorrectAnswer_3
        } else {
            userAnswer = correctAnswer
        }
        
        return userAnswer
    }
}

//MARK: - Query Items
extension TriviaMessage {
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        let id = URLQueryItem(name: "questionID", value: triviaModel.id)
        let category = URLQueryItem(name: "category", value: triviaModel.category)
        let question = URLQueryItem(name: "question", value: triviaModel.question)
        let correctAnswer = URLQueryItem(name: "correctAnswer", value: triviaModel.correctAnswer)
        let difficulty = URLQueryItem(name: "difficulty", value: triviaModel.difficulty)
          
        if let trailingCaption = trailingCaption {
            let item = URLQueryItem(name: "trailingCaption", value: trailingCaption)
            items.append(item)
        }
        
        items.append(appState.queryItem)
        items.append(id)
        items.append(category)
        items.append(difficulty)
        items.append(question)
        items.append(correctAnswer)
        
        var index = 0
        for incorrectAnswer in triviaModel.incorrectAnswers {
            index = index + 1
            let wrongAnswer = URLQueryItem(name: "incorrectAnswer_\(index)", value: incorrectAnswer)
            items.append(wrongAnswer)
        }
        
        for shuffledAnswer in self.shuffledAnswers {
            items.append(URLQueryItem(name: "answers", value: shuffledAnswer))
        }
        
        for submission in self.submissions {
            let newSubmission = URLQueryItem(name: "submission", value: submission.id?.uuidString)

            
            let choice = URLQueryItem(name: submission.id?.uuidString ?? "No ID", value: submission.choice.rawValue)
            let selectedAnswer = URLQueryItem(name: submission.id?.uuidString ?? "No ID", value: submission.selectedAnswer)
            items.append(newSubmission)
            items.append(choice)
            items.append(selectedAnswer)
            
            if let name = submission.name {
                let name = URLQueryItem(name: submission.id?.uuidString ?? "No ID", value: name)
                items.append(name)
            }
        }
        
        print("All query items: \(items)")
        
        return items
    }
    
    // MARK: - Initalizer for QueryItems
    init?(queryItems: [URLQueryItem]) {
        self.triviaModel = TriviaModel(id: "", category: "", correctAnswer: "", incorrectAnswers: [], question: "", difficulty: "", questionType: .single)
        self.submissions = [PersonSubmission]()
        self.shuffledAnswers = []
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if queryItem.name == "questionID" {
                triviaModel.id = value
            }
            
            if queryItem.name == "category" {
                triviaModel.category = value
            }
            
            if queryItem.name == "difficulty" {
                triviaModel.difficulty = value
            }
            
            if queryItem.name == "question" {
                triviaModel.question = value
            }
            
            if queryItem.name == "correctAnswer" {
                triviaModel.correctAnswer = value
            }
            
            if queryItem.name == "incorrectAnswer_1" || queryItem.name == "incorrectAnswer_2" || queryItem.name == "incorrectAnswer_3" {
                triviaModel.incorrectAnswers.append(value)
            }
            
            if queryItem.name == "answers" {
                self.shuffledAnswers.append(value)
            }
            
            if queryItem.name == "trailingCaption" {
                trailingCaption = value
            }
            
            if queryItem.name == "submission" {
                let id = UUID(uuidString: value)
                let user = PersonSubmission()
                user.id = id
                self.submissions.append(user)
            }
            
            for submission in submissions {
                if queryItem.name == submission.id?.uuidString && queryItem.value == "correct" || queryItem.value == "incorrect" {
                    let decision = TriviaMessage.PersonSubmission.Decision(rawValue: value)
                    submission.choice = decision ?? .didNotSelect
                } else if queryItem.name == submission.id?.uuidString && (queryItem.value == "incorrectAnswer_1" || queryItem.value == "incorrectAnswer_2" || queryItem.value == "incorrectAnswer_3" || queryItem.value == "correctAnswer") {
                    submission.selectedAnswer = value
                } else if queryItem.name == submission.id?.uuidString {
                    submission.name = value
                }
            }
        }
    }
}

//MARK: - Messessage Initialization
extension TriviaMessage {
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = urlComponents.queryItems else { return nil }
        self.init(queryItems: queryItems)
    }
}

// MARK: - Extension for Person Submission
extension TriviaMessage {
    class PersonSubmission: Identifiable {
        var id: UUID?
        var name: String?
        var choice: Decision = .didNotSelect
        var selectedAnswer: String = ""
        
        enum Decision: String, CaseIterable {
            case correct, incorrect, didNotSelect
        }
        
        // MARK: Functions
        func getQueryItemAnswer() -> String {
            return selectedAnswer
        }        
    }
}
