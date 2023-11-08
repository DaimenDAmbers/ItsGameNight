//
//  MessageProtocol.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/23/23.
//

import Messages

protocol MessageDelegate: AnyObject {
    func changePresentationStyle(_ style: MSMessagesAppPresentationStyle)
    func sendMessage(with invite: CalendarInvite?)
    func changeAppState(to currentState: AppState)
}
