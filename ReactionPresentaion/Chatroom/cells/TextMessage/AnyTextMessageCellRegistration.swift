//
//  AnyTextMessageCellRegistration.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 5/2/2568 BE.
//

import Foundation
import UIKit

protocol ContentConfigurator {
    func config(to cell: UICollectionViewCell)
}

protocol TextMessageCellConfigurable {
    func configure(with data: ChatRoomViewController.Item)
}

struct AnyCollectionViewCellRegistration<Cell, Item>: CellRegistration where Cell: UICollectionViewCell, Item: ContentConfigurator {
    private let cellRegistration = UICollectionView.CellRegistration<Cell, Item> { cell, indexPath, item in
        item.config(to: cell)
    };

    func cellRegistration(for item: Item) -> any CellRegistrationProvider<Item> {
        cellRegistration
    }
}
