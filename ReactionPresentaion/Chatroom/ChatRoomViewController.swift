//
//  ChatRoomViewController.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 29/1/2568 BE.
//

import Foundation
import UIKit

class ChatRoomViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reactionPresentationTransitionController = ReactionPresentaionTransitionController()
    
    typealias Section = ChatRoomCollectionData.Section
    typealias Item = ChatRoomCollectionData.Item
    
    private var dataSource: UICollectionViewDiffableDataSource<Section.ID, Item.ID>?
    private let chatRoomStore = ChatRoomStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        
        fetchInitialMessages()
    }
    
    private func initCollectionView() {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        
        let registration = ChatCollectionViewRegistrator(actionHandler: chatRoomCollectionViewActionHandler)
        
        dataSource = UICollectionViewDiffableDataSource<Section.ID, Item.ID>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self, let item = chatRoomStore.item(at: indexPath.section, id: itemIdentifier) else {
                return UICollectionViewCell()
            }
            return registration.register(to: collectionView, for: indexPath, item: item)
        }
    }
    
    private func fetchInitialMessages() {
        var snapshot = NSDiffableDataSourceSnapshot<Section.ID, Item.ID>()
        chatRoomStore.messageSections.forEach { section in
            snapshot.appendSections([section.id])
            snapshot.appendItems(section.items.map(\.key))
        }
        
        dataSource?.apply(snapshot)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(48))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(48))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    }
}

extension ChatRoomViewController {
    private var chatRoomCollectionViewActionHandler: ChatCollectionViewRegistrator.ChatCollectionViewCustomActionConfiguration {
        ChatCollectionViewRegistrator.ChatCollectionViewCustomActionConfiguration(
            textMessageActionConfiguration: textMessageActionConfiguration
        )
    }
    
    private var textMessageActionConfiguration: MessageView<UILabel>.ActionHandler {
        MessageView<UILabel>.ActionHandler(
            messageViewLongPressActionHandler: { [weak self] view in
                guard let self else { return }
                let reactionViewController = ReactionViewController()
                reactionViewController.transitioningDelegate = self.reactionPresentationTransitionController
                reactionViewController.modalPresentationStyle = .custom
                reactionViewController.delegate = view as? ReactionViewControllerDelegate
                reactionPresentationTransitionController.transitioningViewController = view as? ReactionPresentationTransitioningDelegate
                present(reactionViewController, animated: true)
            },
            messageViewProfileImageActionHandler: {
                
            }
        )
    }
}
