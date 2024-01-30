//
//  PollHelper.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/29/24.
//

import UIKit

/// A helper struct for the polls functionality
struct PollHelper {
    
    /// Creates a UILabel that will be the title of the  image of the iMessage.
    /// - Parameter text: This is a `String` that will be on the title of the message.
    /// - Returns: A UILabel that can then be used as an image.
    func createTitleLabel(for text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = text
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }
}

extension UIImage {
    func mergeImage(size: CGSize? = nil, with titleImage: UIImage) -> UIImage {
        let backgroundImage = self
        let size = size ?? CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundImage.draw(in: areaSize)

        titleImage.draw(in: CGRect(x: 0, y: areaSize.height/2, width: size.width, height: titleImage.size.height), blendMode: .normal, alpha: 0.9)

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIView {

    /// Creates an image from the view's contents, using its layer.
    ///
    /// - Returns: An image, or nil if an image couldn't be created.
    func createImage(with size: CGSize? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size ?? bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }

}
