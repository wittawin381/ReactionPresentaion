//
//  LinkMessageCell.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 5/2/2568 BE.
//

import Foundation
import UIKit
import LinkPresentation

extension MessageContentConfiguration {
    static func link(
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

protocol LinkPresentableView {
    var metadataProvider: LPMetadataProvider { get }
}

class LinkMessageCell: UICollectionViewCell, LinkPresentableView {
    let metadataProvider = LPMetadataProvider()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        metadataProvider.cancel()
    }
    
    
}

class LinkMessageView: UIView {
    private let loadingIndicator = UIActivityIndicatorView()
    private let linkPreview = LPLinkView()
    
    
}
