//
//  TriviaManager.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/19/24.
//

import Foundation

protocol TriviaManagerDelegate {
    func didUpdateQuestion(for triviaQuestions: [TriviaModel])
}

struct TriviaManager {
    
    var delegate: TriviaManagerDelegate?
    
    func fetchQuestion(with request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            if let trivia = self.parseJSON(data) {
                delegate?.didUpdateQuestion(for: trivia)
            }
        }
        
        task.resume()
    }
    
    func parseJSON(_ triviaData: Data) -> [TriviaModel]? {
        guard let parsedData = try? JSONSerialization.jsonObject(with: triviaData) else { return nil }
        
        let decoder = JSONDecoder()
        do {
            if parsedData is [String:Any] {
                let decodedData = try decoder.decode(TriviaAPIData.self, from: triviaData)
                let id = decodedData.id
                let category = decodedData.category.description
                let correctAnswer = decodedData.correctAnswer
                let incorrectAnswers = decodedData.incorrectAnswers
                let question = decodedData.question.text
                let difficulty = decodedData.difficulty.description
                
                let triviaQuestion = TriviaModel(id: id, category: category, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers, question: question, difficulty: difficulty)
                return [triviaQuestion]
                
            } else {
                let decodedData = try decoder.decode([TriviaAPIData].self, from: triviaData)
                var triviaArray: [TriviaModel] = []
                for data in decodedData {
                    let id = data.id
                    let category = data.category.description
                    let correctAnswer = data.correctAnswer
                    let incorrectAnswers = data.incorrectAnswers
                    let question = data.question.text
                    let difficulty = data.difficulty.description
                    
                    let triviaQuestion = TriviaModel(id: id, category: category, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers, question: question, difficulty: difficulty)
                    triviaArray.append(triviaQuestion)
                }

                return triviaArray
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    /// Creates a URL request from `https:the-trivia-api.com` and brings back only one question matching the `id`.
    /// - Parameter id: The ID of the question
    /// - Returns: Returns a request URL that can be used in a `URLSession`.
    func getQuestion(with id: String) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "the-trivia-api.com"
        components.path = "/v2/question/"
        components.path.append(id)
        
        let url = components.url
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        return request
    }
    
    /// Creates a URL request from `https:the-trivia-api.com` and returns a number of questions.
    /// - Parameter limit: Number of questions to return
    /// - Parameter category: The category of the question.
    /// - Parameter difficulty: The difficulty of the question.
    /// - Returns: Returns a request URL that can be used in a `URLSession`.
    func getQuestion(numOfQuestions: Int = 3, category: TriviaAPIData.Category, difficulty: TriviaAPIData.Difficulty) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "the-trivia-api.com"
        components.path = "/v2/questions"
        components.queryItems = [
            URLQueryItem(name: "limit", value: numOfQuestions.description),
//            URLQueryItem(name: "categories", value: category.rawValue),
            URLQueryItem(name: "types", value: "text_choice")
//            URLQueryItem(name: "difficulties", value: difficulty.rawValue)
        ]
        
        if category != .any {
            components.queryItems?.append(URLQueryItem(name: "categories", value: category.rawValue))
        }
        
        if difficulty != .any {
            components.queryItems?.append(URLQueryItem(name: "difficulties", value: difficulty.rawValue))
        }
        
        
        
        let url = components.url
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        return request
    }
}
