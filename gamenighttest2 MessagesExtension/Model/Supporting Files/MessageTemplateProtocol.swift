//
//  Message.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/17/23.
//

import UIKit

/// Protocol for creating message to send for the different game types.
protocol MessageTemplateProtocol {
    
    // Required variables for the message.
    var appState: AppState {get}
    var image: UIImage {get}
    var caption: String {get}
    var subCaption: String {get}
    
    // Optional variables for the message.
    var trailingCaption: String? {get set}
    var trailingSubcaption: String? {get set}
    var imageTitle: String? {get set}
    var imageSubtitle: String? {get set}
    var summaryText: String? {get set}
    var sentBy: String? {get set}
    var localIdentifier: UUID? {get set}
    var longDescription: String? {get set}
    
    // Initializer for the queryitems
    var queryItems: [URLQueryItem] {get}
    init?(queryItems: [URLQueryItem])
}
