//
//  ChatCollectionViewRegistrator.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 29/1/2568 BE.
//

import UIKit

struct ChatCollectionViewRegistrator: CellRegistration {
    typealias Item = ChatRoomViewController.Item
    
    let textMessageCellRegistration: ChatRoomTextMessageCellRegistration
    let imageMessageCellRegistration: ChatRoomImageMessageCellRegistration
    
    init(actionHandler: ChatCollectionViewCustomActionConfiguration) {
        textMessageCellRegistration = ChatRoomTextMessageCellRegistration(actionHandler: actionHandler.textMessageActionConfiguration)
        imageMessageCellRegistration = ChatRoomImageMessageCellRegistration()
    }
    
    func cellRegistration(for item: Item) -> any CellRegistrationProvider<Item> {
        let registrator: any CellRegistration<Item> = switch item.type {
        case .message:
            textMessageCellRegistration
        case .image:
            imageMessageCellRegistration
        }
        
        return registrator.cellRegistration(for: item)
    }
    
    struct ChatCollectionViewCustomActionConfiguration {
        let textMessageActionConfiguration: MessageView<UILabel>.ActionHandler
    }
}

