//
//  MessageProtocol.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/23/23.
//

import Messages

/// Delegation for the MessagesViewController
protocol MessageDelegate: AnyObject {
    
    /// Changes the presentation style for the app.
    /// - Parameter style: The presenation style can be either `compact` or `extendended`.
    func changePresentationStyle(_ style: MSMessagesAppPresentationStyle)
    
    /// Sends the message using the `MSMessagesAppViewController` as the delegate.
    /// - Parameters:
    ///   - template: This is a protocol that the messages must inherit before using in this method. It contains variables such as the `caption` and `image` for the message.
    ///   - isNewMessage: If this is true, a new message will be created and placed into the view. If this is false, it will reuse the session of a previously created message.
    ///   - sendImmediately: If this is true, the message will be sent immediate when the delegate method is call and will NOT be inserted into the user's text field.
    func sendMessage(using template: MessageTemplateProtocol?, isNewMessage: Bool, sendImmediately: Bool)
    
    /// Update the app to the current state
    /// - Parameter currentState: This is the parament that is mapped to the `MessageTemplateProtocol`.
    func changeAppState(to currentState: AppState)
}
