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
    
    init(label: String, image: UIImage? = UIImage(named: "It's Game Night")) {
        self.label = label
        self.image = image
    }
}
