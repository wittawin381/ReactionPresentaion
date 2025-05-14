//
//  ChatCell.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 29/1/2568 BE.
//

import Foundation
import UIKit

extension MessageContentConfiguration {
    static func text(
        direction: MessageView<UILabel>.Direction,
        actionHandler: MessageView<UILabel>.ActionHandler?,
        viewConfigurator: @escaping (UILabel) -> Void
    ) -> MessageContentConfiguration<UILabel> {
        return MessageContentConfiguration<UILabel>(
            direction: direction,
            actionHandler: actionHandler,
            messageContentViewProvider: {
                let label = UILabel()
                label.numberOfLines = 0
                label.textColor = .systemBackground
                return label
            },
            messageContentViewConfigurator: viewConfigurator
        )
    }
}
