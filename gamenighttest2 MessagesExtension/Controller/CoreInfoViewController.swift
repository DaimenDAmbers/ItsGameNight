//
//  CoreInfoViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/2/25.
//

import UIKit

class CoreInfoViewController: UIViewController {
    static let storyboardIdentifier = "CoreInfoViewController"
    var longDescription: String = ""
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        descriptionLabel.text = longDescription
        descriptionLabel.sizeToFit()
    }
}
