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
    
    var shadowLayer = UIView()
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var numOfVotesLabel: UILabel!
    @IBOutlet weak var decisionLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
        //
        // add additional views to the containerView here
        //
        
        // add constraints
        shadowLayer.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        shadowLayer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        shadowLayer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        shadowLayer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
//    @IBAction func infoButtonTapped(_ sender: UIButton) {
//        print("Info button tapped")
//    }
    
}

extension UIView {
    
    /// Applies a shadow to the `UIView`
    /// - Parameter cornerRadius: Applies a `CGFloat`radius to the shadow.
    func applyShadow(cornerRadius: CGFloat) {
        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        //Shadow
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.30
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
