//
//  AnyCellRegistration.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 3/2/2568 BE.
//

import Foundation
import UIKit

struct AnyCellRegistration<Item>: CellRegistration {
    private let _cellRegistration: (Item) -> any CellRegistrationProvider<Item>
    private let _register: (UICollectionView, IndexPath, Item) -> UICollectionViewCell
    
    func cellRegistration(for item: Item) -> any CellRegistrationProvider<Item> {
        _cellRegistration(item)
    }
    
    init<Registrator>(_ register: Registrator) where Registrator: CellRegistration, Registrator.Item == Item {
        self._cellRegistration = { item in register.cellRegistration(for: item) }
        self._register = { collectionView, indexPath, item in
            register.register(to: collectionView, for: indexPath, item: item)
        }
    }
    
    func register(to collectionView: UICollectionView, for indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        _register(collectionView, indexPath, item)
    }
}
