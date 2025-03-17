//
//  HomeCollectionViewCell.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 2/26/24.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let idendifier = "HomeCollectionViewCell"
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: HomeCollectionViewCell.idendifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor(named: "MenuBackground")
        self.layer.cornerRadius = 10
    }

}
