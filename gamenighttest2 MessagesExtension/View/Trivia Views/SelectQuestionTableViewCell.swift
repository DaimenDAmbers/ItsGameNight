//
//  CategoryTableViewCell.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/20/24.
//

import UIKit

class SelectQuestionTableViewCell: UITableViewCell {
    
    // MARK: Variables
    static let identifier = "SelectQuestionTableViewCell"
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionText: UILabel!
    

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
        return UINib(nibName: SelectQuestionTableViewCell.identifier, bundle: nil)
    }
}
