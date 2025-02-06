//
//  ChatCell.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 29/1/2568 BE.
//

import Foundation
import UIKit

private let kMessageContentPadding: CGFloat = 2
private let kLabelHorizontalPadding: CGFloat = 8
private let kLabelVerticalPadding: CGFloat = 6

struct TextMessageConfiguration: UIContentConfiguration, Hashable {
    let message: String
    let sentTime: Date
    let direction: MessageView.Direction
    
    func makeContentView() -> any UIView & UIContentView {
        TextMessageView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> TextMessageConfiguration {
        self
    }
}

class TextMessageView: MessageView {
    private var appliedConfiguration: TextMessageConfiguration = TextMessageConfiguration(
        message: "",
        sentTime: Date.now,
        direction: .inbound
    )
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    } ()
    
    private let avatarView = AvatarView()
    
    override var messageContentView: UIView {
        messageLabel
    }
    
    init(configuration: TextMessageConfiguration) {
        super.init(direction: configuration.direction)
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextMessageView: UIContentView {
    var configuration: any UIContentConfiguration {
        get {
            appliedConfiguration
        }
        set(newValue) {
            guard let newConfiguration = newValue as? TextMessageConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    private func apply(configuration: TextMessageConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        messageLabel.text = configuration.message
    }
}
