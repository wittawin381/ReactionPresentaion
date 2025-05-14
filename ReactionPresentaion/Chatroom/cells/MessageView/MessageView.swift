//
//  MessageView.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 6/2/2568 BE.
//

import Foundation
import UIKit

private let kMessageContentPadding: CGFloat = 2
private let kLabelHorizontalPadding: CGFloat = 8
private let kLabelVerticalPadding: CGFloat = 6

struct MessageContentConfiguration<MessageContentView>: UIContentConfiguration where MessageContentView: UIView {
    typealias ContentViewProvider = () -> MessageContentView
    typealias ContentViewConfigurator = (MessageContentView) -> Void
    
    let direction: MessageView<MessageContentView>.Direction
    let messageContainerConfiguration: ReactableMessageContainerView.Configuration
    let messageViewActionHandler: MessageView<MessageContentView>.ActionHandler?
    let messageContentViewProvider: ContentViewProvider?
    let messageContentViewConfigurator: ContentViewConfigurator
    
    init(
        direction: MessageView<MessageContentView>.Direction,
        actionHandler: MessageView<MessageContentView>.ActionHandler?,
        messageContentViewProvider: @escaping ContentViewProvider,
        messageContentViewConfigurator: @escaping ContentViewConfigurator
    ) {
        self.direction = direction
        self.messageContainerConfiguration = .defaultConfiguration
        self.messageViewActionHandler = actionHandler
        self.messageContentViewProvider = messageContentViewProvider
        self.messageContentViewConfigurator = messageContentViewConfigurator
    }
    
    func makeContentView() -> any UIView & UIContentView {
        return MessageView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> MessageContentConfiguration {
        self
    }
}

class MessageView<MessageContentView>: UIView where MessageContentView: UIView {
    enum Direction {
        case inbound
        case outbound
    }
        
    private let contentView: UIView = {
        let view = UIView()
        return view
    } ()
    
    private let messageContainerView: ReactableMessageContainerView = {
        let view = ReactableMessageContainerView(configuration: .defaultConfiguration)
        view.messageContainerBackgroundColor = .systemGreen
        return view
    } ()
    
    private var messageContentView: MessageContentView
    
    private let avatarView = AvatarView()
    
    private var appliedConfiguration: MessageContentConfiguration<MessageContentView>
        
    init(configuration: MessageContentConfiguration<MessageContentView>) {
        appliedConfiguration = configuration
        messageContentView = configuration.messageContentViewProvider?() ?? MessageContentView()
        configuration.messageContentViewConfigurator(messageContentView)
        super.init(frame: .zero)
        layout(direction: configuration.direction)
        apply(configuration: configuration)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler))
        messageContainerView.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func longPressGestureHandler(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            appliedConfiguration.messageViewActionHandler?.messageViewLongPressActionHandler?(self)
        }
    }
}

extension MessageView {
    private func layout(direction: Direction) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        switch direction {
        case .inbound:
            contentView.addSubview(avatarView)
            avatarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                avatarView.widthAnchor.constraint(equalToConstant: 24)
            ])
            
            contentView.addSubview(messageContainerView)
            messageContainerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                messageContainerView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
                messageContainerView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
                messageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -kMessageContentPadding),
                messageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kMessageContentPadding),
                
                messageContainerView.messageContainerLayoutGuide.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor)
            ])
        case .outbound:
            contentView.addSubview(messageContainerView)
            messageContainerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                messageContainerView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
                messageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                messageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -kMessageContentPadding),
                messageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kMessageContentPadding)
            ])
        }
        
        messageContainerView.addContentView(messageContentView)
    }
}

extension MessageView: UIContentView {
    var configuration: any UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfiguration = newValue as? MessageContentConfiguration<MessageContentView> else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    private func apply(configuration: MessageContentConfiguration<MessageContentView>) {
        messageContainerView.configuration = configuration.messageContainerConfiguration
        configuration.messageContentViewConfigurator(messageContentView)
    }
}

extension MessageView {
    struct ActionHandler {
        let messageViewLongPressActionHandler: ((UIView) -> Void)?
        let messageViewProfileImageActionHandler: (() -> Void)?
    }
}

extension MessageView: ReactionViewControllerDelegate {
    var reactionViewControllerSourceView: UIView? {
        messageContainerView
    }
}

extension MessageView: ReactionPresentationTransitioningDelegate {
    var reactionPresentationControllerLayoutDirection: ReactionViewController.LayoutDirection {
        switch appliedConfiguration.direction {
        case .inbound:
            .leading
        case .outbound:
            .trailing
        }
    }
    
    var reactionPresentationControllerSourceView: UIView {
        messageContainerView
    }
}
