//
//  Message.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/17/23.
//

import UIKit

/// Protocol for creating message to send for the different game types.
protocol MessageTemplateProtocol {
    var appState: AppState {get}
    var image: UIImage {get}
    var caption: String {get}
    var subCaption: String {get}
    
    var queryItems: [URLQueryItem] {get}
    init?(queryItems: [URLQueryItem])
}
