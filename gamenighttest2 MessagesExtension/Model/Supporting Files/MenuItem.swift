//
//  MenuItem.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 2/28/24.
//

import UIKit

struct MenuItem {
    var label: String
    var image: UIImage?
    var pointLabel: String?
    var score: Int?
    
    init(label: String, image: UIImage? = UIImage(named: "It's Game Night"), score: Int? = nil) {
        self.label = label
        self.image = image
        self.score = score
        
        // Creates the label for the points for the menu item.
        if let unwrappedScore = self.score {
            self.pointLabel = "Points: \(unwrappedScore)"
        }
    }
}
