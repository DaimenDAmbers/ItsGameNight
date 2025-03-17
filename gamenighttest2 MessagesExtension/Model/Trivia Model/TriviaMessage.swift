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
    
    var questionPoints: Int {
        var points = Int()
        
        if triviaModel.difficulty == "Easy" {
            points = 1
        } else if triviaModel.difficulty == "Medium" {
            points = 2
        } else if triviaModel.difficulty == "Hard" {
            points = 3
        } else {
            points = 0
        }
        
        return points
    }
    
    var shuffledAnswers: [String]
    
    // MARK: Message Protocol Variables
    var appState: AppState {
        return .trivia
    }
    
    var image: UIImage {
        return UIImage(named: Constants.ImageTiles.trivia) ?? UIImage(named: Constants.ImageTiles.logo)!
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
    
    var localIdentifier: UUID?
    
    var longDescription: String?
    
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
    
    /// Checks against the `localParticipantIdenifier` from the conversation.
    /// - Parameter id: This is the user's `localParticipantIdentifer`
    /// - Returns: True when the ID is found inside of the array of the people that have submitted an answer.
    func checkIfPersonAnswered(id: UUID?) -> Bool {
        for submission in submissions {
            if submission.id == id {
                return true
            }
        }
        
        return false
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
    
    func returnUserAnswerandIndex(for value: String) -> (answer: String, index: Int) {
        var userAnswer = String()
        var index = Int()
        
        
        if value == "incorrectAnswer_1" {
            userAnswer = incorrectAnswer_1
        } else if value == "incorrectAnswer_2" {
            userAnswer = incorrectAnswer_2
        } else if value == "incorrectAnswer_3" {
            userAnswer = incorrectAnswer_3
        } else {
            userAnswer = correctAnswer
        }
        
        for i in 0..<shuffledAnswers.count {
            if userAnswer == shuffledAnswers[i] {
                index = i
            }
        }
        
        return (userAnswer, index)
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

            
            let choice = URLQueryItem(name: submission.id?.uuidString ?? "No ID", value: submission.result.rawValue)
            let selectedAnswer = URLQueryItem(name: submission.id?.uuidString ?? "No ID", value: submission.getQueryItemAnswer())
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
                if queryItem.name == submission.id?.uuidString && (queryItem.value == "correct" || queryItem.value == "incorrect") {
                    let decision = TriviaMessage.PersonSubmission.Decision(rawValue: value)
                    submission.result = decision ?? .didNotSelect
                } else if queryItem.name == submission.id?.uuidString && (queryItem.value == "incorrectAnswer_1" || queryItem.value == "incorrectAnswer_2" || queryItem.value == "incorrectAnswer_3" || queryItem.value == "correctAnswer") {
                    submission.setQueryItemAnswer(to: value)
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
        var result: Decision = .didNotSelect
        var queryItemAnswer: String = ""
        var answer: String = ""
        var selectedAnswerIndex: Int = 0
        
        enum Decision: String, CaseIterable {
            case correct, incorrect, didNotSelect
        }
        
        // MARK: Functions
        
        /// Returns the query item for the answer that the user selected
        /// - Returns: Returns a string value that matches the name of the query item if they are correct or incorrect.
        func getQueryItemAnswer() -> String {
            return queryItemAnswer
        }
        
        /// Set's the query item for the answer that was selected.
        func setQueryItemAnswer(to value: String) {
            self.queryItemAnswer = value
        }
        
        /// Sets the user's answer to the value from the list of answers
        func setAnswer(to value: String) {
            self.answer = value
        }
        
        /// The user's answer
        /// - Returns: Returns the string value of the user's answer
        func getAnswer() -> String {
            return answer
        }
        
        /// This is the index of the selected answer of the user
        /// - Returns: Returns an integer of where the index is of the selected answer.
        func getSelectedAnswerIndex() -> Int {
            return selectedAnswerIndex
        }
        
        /// Sets the user's selected index to the value that was choosen.
        func setSelectedAnswerIndex(to value: Int) {
            self.selectedAnswerIndex = value
        }
    }
}
