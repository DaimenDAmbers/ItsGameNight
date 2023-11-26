//
//  MessageProtocol.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/23/23.
//

import Messages

protocol MessageDelegate: AnyObject {
    func changePresentationStyle(_ style: MSMessagesAppPresentationStyle)
//    func sendMessage(with invite: CalendarInvite?)
//    func sendMessage(with people: RandomPerson?)
    func sendMessage(using template: MessageTemplateProtocol?)
    func changeAppState(to currentState: AppState)
}
