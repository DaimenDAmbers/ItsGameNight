//
//  PostViewController.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/17/23.
//

import UIKit
import Messages

class ScheduleViewController: UIViewController {
    
//    weak var delegate: ScheduleViewControllerDelegate?
    var conversation: MSConversation?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))

        // Do any additional setup after loading the view.
    }
    
    @objc func didTapAdd() {
        print("Add tapped")
//        delegate?.sendCalendarInvite()
    }
}
