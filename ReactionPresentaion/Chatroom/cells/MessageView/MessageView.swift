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

protocol MessageViewDelegate: AnyObject {
    var messageViewMessageContentView: UIView { get }
}

class MessageView: UIView {
    struct Configuration: Hashable {
        let messageContainerConfiguration: ReactableMessageContainerView.Configuration
        
        static let defaultConfiguration = Configuration(
            messageContainerConfiguration: .defaultConfiguration)
    }
    
    enum Direction {
        case inbound
        case outbound
    }
    
    weak var delegate: MessageViewDelegate?
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    } ()
    
    private let messageContainerView: ReactableMessageContainerView = {
        let view = ReactableMessageContainerView(configuration: .defaultConfiguration)
        view.messageContainerBackgroundColor = .systemGreen
        return view
    } ()
    
    private let defaultContentView: UIView = UIView()
    var messageContentView: UIView {
        defaultContentView
    }
    
    private let avatarView = AvatarView()
    
    private var appliedConfiguration: Configuration = .defaultConfiguration
    var messageViewConfiguration: Configuration {
        get { appliedConfiguration }
        set {
            guard appliedConfiguration != newValue else { return }
            apply(configuration: newValue)
        }
    }
    
    init(direction: Direction, configuration: Configuration = .defaultConfiguration) {
        super.init(frame: .zero)
        layout(direction: direction)
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                avatarView.widthAnchor.constraint(equalToConstant: 18)
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
    
    private func apply(configuration: Configuration) {
        messageContainerView.configuration = configuration.messageContainerConfiguration
    }
}
