//
//  ChatRoomCollectionData.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 5/2/2568 BE.
//

import Foundation
import UIKit

enum ChatRoomCollectionData {
    struct Section: Identifiable {
        let id = UUID()
        let section: SectionType
        let headerType: HeaderType
        let footerType: FooterType
        let items: [Item.ID: Item]
        
        enum HeaderType {
            case date(date: Date)
            case none
        }
        
        enum FooterType {
            case none
        }
    }
    
    enum SectionType: Hashable {
        case main
    }
    
    struct Item: Identifiable {
        let id = UUID()
        let sentTime: Date
        let type: ItemType
        let sender: Sender
        
        enum Sender {
            case inbound
            case outbound
        }
        
        enum ItemType: Hashable {
            case message(text: String)
            case image(url: String)
            case link(url: String)
        }
    }
}
