//
//  TabBarController.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/14/23.
//

import UIKit
import Messages

class TabBarController: UITabBarController {
    
    static let storyboardIdentifier = "TabBarController"
    var conversation: MSConversation?
    
    override func viewDidLoad() {
//        guard let conversation = conversation else { fatalError() }
        print("TabBarController: \(String(describing: conversation))")
    }
  
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(viewController.title)
        if viewController.title == "Home" {
            let vc = HomeViewController()
            vc.conversation = conversation
            vc.delegate = delegate as? any HomeViewControllerDelegate
            print("End of tabBarController func")
        }
    }
}
