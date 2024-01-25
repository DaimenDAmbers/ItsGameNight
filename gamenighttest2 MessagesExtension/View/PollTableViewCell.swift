//
//  PollTableViewCell.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/14/24.
//

import UIKit

class PollTableViewCell: UITableViewCell {
    
    static let idendifier = "PollTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PollTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var numOfVotesLabel: UILabel!
    @IBOutlet weak var decisionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
