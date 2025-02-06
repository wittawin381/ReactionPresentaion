//
//  ReactionView.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 21/1/2568 BE.
//

import Foundation
import UIKit

private let kNumberOfReactionVisible = 5.5
private let kItemSize: CGFloat = 48
private let kCollectionViewPadding: CGFloat = 8

protocol ReactionSelectionListViewDelegate: AnyObject {
    func reactionSelectionListView(_ reactionSelectionListView: ReactionSelectionListView, didSelect reaction: String)
    func reactionSelectionListViewDidTapSeeMoreReaction(_ reactionSelectionListView: ReactionSelectionListView)
}

class ReactionSelectionListView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leadingBlurView: UIView!
    @IBOutlet weak var trailingBlurView: UIVisualEffectView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ReactionContentConfiguration>!
    
    private let reactions = ["\u{1F61D}", "\u{1F618}", "\u{1F975}", "\u{1F633}", "\u{1F49C}", "\u{1F496}", "\u{1F389}"];
    
    weak var delegate: ReactionSelectionListViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: (kNumberOfReactionVisible * kItemSize) + kCollectionViewPadding, height: kItemSize + (kCollectionViewPadding * 2))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: layer.cornerRadius).cgPath
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    enum Section {
        case main
    }
    
    private func setupView() {
        initCollectionView()
        setupBlurView()
        setupCorner()
    }
    
    private func initCollectionView() {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        let cellRegistration = UICollectionView.CellRegistration<ReactionCollectionViewCell, ReactionContentConfiguration> { cell, indexPath, item in
            cell.contentConfiguration = item
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ReactionContentConfiguration>(
            collectionView: collectionView) { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        
        setupData()
    }
    
    private func setupData() {
        let reactions = self.reactions
            .compactMap { UnicodeScalar($0) }
            .map(Character.init)
            .map { ReactionContentConfiguration(emoji: String($0)) }
                
        var snapshot = NSDiffableDataSourceSnapshot<Section, ReactionContentConfiguration>()
        snapshot.appendSections([.main])
        snapshot.appendItems(reactions)
        dataSource?.apply(snapshot)
    }
    
    private func setupCorner() {
        contentView.layer.cornerRadius = intrinsicContentSize.height / 2
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        
        collectionView.layer.cornerRadius = contentView.layer.cornerRadius
//        leadingBlurView.layer.cornerRadius = contentView.layer.cornerRadius
//        leadingBlurView.layer.maskedCorners = contentView.layer.maskedCorners.intersection(.layerMaxXMaxYCorner)
//        leadingBlurView.clipsToBounds = true
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        
        let layoutSize = NSCollectionLayoutSize(widthDimension: .absolute(kItemSize), heightDimension: .absolute(kItemSize))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(kItemSize), heightDimension: .absolute(kItemSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: kCollectionViewPadding,
            leading: kCollectionViewPadding,
            bottom: kCollectionViewPadding,
            trailing: kCollectionViewPadding)
        
        return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    }
    
    private func setupBlurView() {
//        let blurEffect = UIBlurEffect(style: .light)
//        leadingBlurView.effect = blurEffect
//        trailingBlurView.effect = blurEffect
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: ReactionSelectionListView.self), owner: self)
        
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupView()
    }
}

extension ReactionSelectionListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let reaction = reactions[safe: indexPath.item] else { return }
        delegate?.reactionSelectionListView(self, didSelect: reaction)
    }
}
