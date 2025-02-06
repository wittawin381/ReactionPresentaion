//
//  UICollectionViewCellRegistration+Extension.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 3/2/2568 BE.
//

import Foundation
import UIKit

protocol CellRegistrationProvider<Item> {
    associatedtype Item
    
    var cellRegistration: AnyCellRegistration<Item> { get }
}

protocol CellRegistration<Item> {
    associatedtype Item
    
    func cellRegistration(for item: Item) -> any CellRegistrationProvider<Item>
    func register(to collectionView: UICollectionView, for indexPath: IndexPath, item: Item) -> UICollectionViewCell
}

extension CellRegistration {
    func register(to collectionView: UICollectionView, for indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        cellRegistration(for: item).cellRegistration.register(to: collectionView, for: indexPath, item: item)
    }
}

extension UICollectionView.CellRegistration: CellRegistration, CellRegistrationProvider {
    var cellRegistration: AnyCellRegistration<Item> {
        AnyCellRegistration(self)
    }
    
    func cellRegistration(for item: Item) -> any CellRegistrationProvider<Item> {
        self
    }
    
    func cellRegistration(for item: Item) -> AnyCellRegistration<Item> {
        AnyCellRegistration(self)
    }
    
    func register(to collectionView: UICollectionView, for indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: self, for: indexPath, item: item)
    }
}
