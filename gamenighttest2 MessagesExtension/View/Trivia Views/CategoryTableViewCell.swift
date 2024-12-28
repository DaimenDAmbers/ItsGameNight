//
//  CategoryTableViewCell.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/21/24.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: Variables
    static let identifier = "CategoryTableViewCell"
    @IBOutlet weak var categoryText: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: CategoryTableViewCell.identifier, bundle: nil)
    }
}
