//
//  TriviaTableViewCell.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/18/24.
//

import UIKit

class TriviaTableViewCell: UITableViewCell {
    
    // MARK: Variables
    static let identifier = "TriviaTableViewCell"
    var shadowLayer = UIView()
    
    // MARK: IBOulets
    @IBOutlet weak var answerImage: UIImageView!
    @IBOutlet weak var answerText: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: TriviaTableViewCell.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Layouts a subview for each cell
    func layoutSubview() {
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
          
        // set the cornerRadius of the containerView's layer
        shadowLayer.layer.cornerRadius = 10
        shadowLayer.layer.masksToBounds = true
        
        addSubview(shadowLayer)
        
        // add constraints
        shadowLayer.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        shadowLayer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        shadowLayer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        shadowLayer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
