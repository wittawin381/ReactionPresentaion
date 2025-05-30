//
//  TextMessageCellRegistration.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 5/2/2568 BE.
//

import Foundation
import UIKit

typealias TextMessageCelllRegistration<Item> = UICollectionView.CellRegistration<UICollectionViewCell, Item>

struct ChatRoomTextMessageCellRegistration: CellRegistration {
    typealias Item = ChatRoomCollectionData.Item
    
    private let inboundCellRegistration: TextMessageCelllRegistration<Item>
    private let outboundCellRegistration: TextMessageCelllRegistration<Item>
    
    init(actionHandler: MessageView<UILabel>.ActionHandler?) {        
        inboundCellRegistration = TextMessageCelllRegistration<Item> { cell, indexPath, item in
            if case let .message(message) = item.type {
                cell.contentConfiguration = MessageContentConfiguration.text(
                    direction: .inbound,
                    actionHandler: actionHandler,
                    viewConfigurator: { label in
                        label.text = message
                    }
                )
            }
        };
        
        outboundCellRegistration = TextMessageCelllRegistration<Item> { cell, indexPath, item in
            if case let .message(message) = item.type {
                cell.contentConfiguration = MessageContentConfiguration.text(
                    direction: .outbound,
                    actionHandler: actionHandler,
                    viewConfigurator: { label in
                        label.text = message
                    }
                )
            }
        };
    }

    func cellRegistration(for item: Item) -> any CellRegistrationProvider<Item> {
        switch item.sender {
        case .inbound:
            inboundCellRegistration
        case .outbound:
            outboundCellRegistration
        }
    }
}
