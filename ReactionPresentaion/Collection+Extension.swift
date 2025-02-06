//
//  Collection+Extension.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 25/1/2568 BE.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
