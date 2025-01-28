//
//  UIViewExtension.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/27/25.
//

import UIKit

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
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func applyShadow(cornerRadius: CGFloat, interfaceStyle: UIUserInterfaceStyle) {
        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        //Shadow
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.30
        if interfaceStyle == .light {
            layer.shadowColor = UIColor.black.cgColor
        } else {
            layer.shadowColor = UIColor.white.cgColor
        }
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
