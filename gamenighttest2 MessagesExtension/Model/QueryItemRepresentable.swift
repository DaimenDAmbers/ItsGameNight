//
//  QueryItemRepresentable.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/29/23.
//

import Foundation

protocol QueryItemRepresentable {
    
    var queryItemKey: String { get }
    
    var queryItemValue: String { get }
    
    var queryItem: URLQueryItem { get }
}

extension QueryItemRepresentable {
    var queryItem: URLQueryItem {
        return URLQueryItem(name: queryItemKey, value: queryItemValue)
    }
}
