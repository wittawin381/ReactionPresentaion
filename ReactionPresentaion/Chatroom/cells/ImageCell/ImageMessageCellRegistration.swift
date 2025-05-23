//
//  ImageMessageCellRegistration.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 5/2/2568 BE.
//

import Foundation
import UIKit

struct ChatRoomImageMessageCellRegistration: CellRegistration {
    typealias Item = ChatRoomCollectionData.Item
    
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, indexPath, item in
        if case let .image(url) = item.type {
            cell.contentConfiguration = ImageMessageConfiguration(imageURL: url)
        }
    }
    
    func cellRegistration(for item: Item) -> any CellRegistrationProvider<Item> {
        cellRegistration
    }
}
