//
//  ChatCollectionViewRegistrator.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 29/1/2568 BE.
//

import UIKit

struct ChatCollectionViewRegistrator: CellRegistration {
    typealias Item = ChatRoomViewController.Item
    
    let textMessageCellRegistration = ChatRoomTextMessageCellRegistration()
    let imageMessageCellRegistration = ChatRoomImageMessageCellRegistration()
    let linkMessageCellRegistration = ChatRoomLinkMessageCellRegistration()
    
    func cellRegistration(for item: Item) -> any CellRegistrationProvider<Item> {
        let registrator: any CellRegistration<Item> = switch item.type {
        case .message:
            textMessageCellRegistration
        case .image:
            imageMessageCellRegistration
        case .link:
            linkMessageCellRegistration
        }
        
        return registrator.cellRegistration(for: item)
    }
}

