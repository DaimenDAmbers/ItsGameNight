//
//  MessageProtocol.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/23/23.
//

import Messages

/// Delegation for the MessagesViewController
protocol MessageDelegate: AnyObject {
    func changePresentationStyle(_ style: MSMessagesAppPresentationStyle)
    func sendMessage(using template: MessageTemplateProtocol?)
    func changeAppState(to currentState: AppState)
}
