//
//  ChatRoomController.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 5/2/2568 BE.
//

import Foundation

protocol ChatRoomStoreDelegate: AnyObject {
    
}

final class ChatRoomStore {
    weak var delegate: ChatRoomStoreDelegate?
    
    private let dataSource = MockMessageDataSource()
    private var _messageSections: [ChatRoomCollectionData.Section] = []
    var messageSections: [ChatRoomCollectionData.Section] {
        _messageSections
    }
    
    init() {
        _messageSections = dataSource.allItems()
    }
    
    func item(at section : Int, id: UUID) -> ChatRoomCollectionData.Item? {
        _messageSections[section].items[id]
    }
}

protocol DataSource {
    associatedtype Item
    
    func allItems() -> [Item]
}

class MockMessageDataSource: DataSource {
    typealias Section = ChatRoomCollectionData.Section
    typealias Message = ChatRoomCollectionData.Item
    
    func allItems() -> [ChatRoomCollectionData.Section] {
        return [
            Section(
                section: .main,
                headerType: .date(date: Date.now),
                footerType: .none,
                    items: Dictionary(
                        uniqueKeysWithValues: [
                            Message(
                                sentTime: Date.now,
                                type: .message(text: "MEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssageMEssage"),
                                sender: .outbound
                            )
                    ].map { ($0.id, $0) })
            ),
            Section(
                section: .main,
                headerType: .date(date: Date.now),
                footerType: .none,
                    items: Dictionary(
                        uniqueKeysWithValues: [
                            Message(
                                sentTime: Date.now,
                                type: .message(text: "MEssage2"),
                                sender: .inbound
                            ),
                            Message(
                                sentTime: Date.now,
                                type: .message(text: "เก็ยไว"),
                                sender: .inbound
                            ),
                            Message(
                                sentTime: Date.now,
                                type: .message(text: "เกย์"),
                                sender: .inbound
                            )
                    ].map { ($0.id, $0) })
            ),
            Section(
                section: .main,
                headerType: .date(date: Date.now),
                footerType: .none,
                    items: Dictionary(
                        uniqueKeysWithValues: [
                            Message(
                                sentTime: Date.now,
                                type: .message(text: "MEssage3"),
                                sender: .outbound
                            )
                    ].map { ($0.id, $0) })
            ),
        ]
    }
}
