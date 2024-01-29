//
//  PollHelper.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/29/24.
//

import UIKit

extension String {
    
    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                    withAttributes: attributes)
        }
    }
}

extension UIImage {
    func mergeImage(size: CGSize? = nil, with titleImage: UIImage) -> UIImage {
        let backgroundImage = self
        let size = size ?? CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundImage.draw(in: areaSize)

        titleImage.draw(in: CGRect(x: 0, y: areaSize.height/2, width: size.width, height: titleImage.size.height), blendMode: .normal, alpha: 0.8)

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
