//
//  RandomPersonSelect.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 11/1/23.
//

import UIKit

struct RandomPersonSelect: MessageTemplateProtocol {
    var appState: AppState {
        return .home
    }
    
    var image: UIImage {
        return UIImage(named: "It's Game Night") ?? UIImage(named: "‎Let's Coast Logo")!
    }
    
    var caption: String {
        return "Who Was Chosen???"
    }
    
    var subCaption: String {
        return "A person from the group was selected at Random."
    }
}
