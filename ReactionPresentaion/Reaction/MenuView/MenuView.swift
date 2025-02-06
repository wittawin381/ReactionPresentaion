//
//  MenuView.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 24/1/2568 BE.
//

import Foundation
import UIKit

private let kMenuHeight: CGFloat = 44

protocol MenuViewDelegate: AnyObject {
    var menuViewMenus: [UIMenu] { get }
    
    func menuViewDidTap()
}

class MenuView: UIView {
    private let contentView = UIView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIMenu>?
    
    weak var delegate: MenuViewDelegate? {
        didSet {
            applyCollectionViewSnapshotIfDataExisted()
        }
    }
    
    enum Section {
        case main
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        guard let menus = delegate?.menuViewMenus else { return .zero }
        return CGSize(width: 200, height: kMenuHeight * CGFloat(menus.count))
    }
    
    private func commonInit() {
        layoutViews()
        initCollectionView()
        applyCollectionViewSnapshotIfDataExisted()
        setupCorner()
        setupShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: layer.cornerRadius).cgPath
    }
    
    private func layoutViews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func initCollectionView() {
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UIMenuElement> { cell, indexPath, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.title
            cell.contentConfiguration = configuration
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, UIMenu>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func applyCollectionViewSnapshotIfDataExisted() {
        guard let menus = delegate?.menuViewMenus else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIMenu>()
        snapshot.appendSections([.main])
        snapshot.appendItems(menus)
        dataSource?.apply(snapshot)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(kMenuHeight))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        
        return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    }
    
    private func setupCorner() {
        layer.cornerRadius = 16
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    private func setupShadow() {
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
    }
}

extension MenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.menuViewDidTap()
    }
}
