//
//  ReactableMessageContainerView.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 6/2/2568 BE.
//

import Foundation
import UIKit

class ReactableMessageContainerView: UIView {
    private let messageContainerView = MessageContainerView()
    private let messageReactionPreview = MessageReactionPreview()
    
    let messageContainerLayoutGuide = UILayoutGuide()
    
    var messageContainerBackgroundColor: UIColor? {
        get { messageContainerView.backgroundColor }
        set { messageContainerView.backgroundColor = newValue }
    }
    
    struct Configuration: Hashable {
        let messageContainerViewBackgroundColor: UIColor
        let reactionContainerViewBackgroundColor: UIColor
        
        static let defaultConfiguration = Configuration(
            messageContainerViewBackgroundColor: .systemGreen,
            reactionContainerViewBackgroundColor: .systemGreen.withAlphaComponent(0.8))
    }
    
    private var appliedConfiguration: Configuration = .defaultConfiguration
    var configuration: Configuration {
        get { appliedConfiguration }
        set {
            guard appliedConfiguration != newValue else { return }
            apply(configuration: newValue)
        }
    }
    
    init(configuration: Configuration) {
        super.init(frame: .zero)
        setupLayout()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyReactionViewMask()
    }
    
    private func apply(configuration: Configuration) {
        messageContainerView.backgroundColor = configuration.messageContainerViewBackgroundColor
        messageReactionPreview.backgroundColor = configuration.messageContainerViewBackgroundColor
    }
    
    func applyReactionViewMask() {
        let reactionViewLayer = CAShapeLayer()
        
        let desiredPadding: CGFloat = 4
        let widthRatio = (messageReactionPreview.bounds.width + desiredPadding) / messageReactionPreview.bounds.width
        let heightRatio = (messageReactionPreview.bounds.height + desiredPadding) / messageReactionPreview.bounds.height
        
        let width = messageReactionPreview.bounds.width * widthRatio
        let height = messageReactionPreview.bounds.height * heightRatio
        let maskOriginInMessageContainerCoordinate = convert(messageReactionPreview.frame, to: messageContainerView)
        
        let originOffsetX = (width - messageReactionPreview.bounds.width) / 2
        let originOffsetY = (height - messageReactionPreview.bounds.height) / 2
        let offsetMaskOrigin = CGPoint(
            x: maskOriginInMessageContainerCoordinate.origin.x - originOffsetX,
            y: maskOriginInMessageContainerCoordinate.origin.y - originOffsetY)
        
        let maskSize = CGSize(
            width: width,
            height: height)
        
        let maskRect = CGRect(
            origin: offsetMaskOrigin,
            size: maskSize)
        
        let path = UIBezierPath(roundedRect: maskRect, cornerRadius: height / 2)
        path.append(UIBezierPath(rect: messageContainerView.bounds))
        reactionViewLayer.path = path.cgPath
        reactionViewLayer.fillRule = .evenOdd
        messageContainerView.layer.mask = reactionViewLayer
    }
    
    func addContentView(_ contentView: UIView) {
        messageContainerView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: messageContainerView.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: messageContainerView.layoutMarginsGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: messageContainerView.layoutMarginsGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: messageContainerView.layoutMarginsGuide.topAnchor)
       ])
    }
    
    private func setupLayout() {
        addSubview(messageContainerView)
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageContainerBottomConstraint = messageContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        messageContainerBottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            messageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageContainerView.topAnchor.constraint(equalTo: topAnchor),
            messageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageContainerBottomConstraint
        ])
        
        addSubview(messageReactionPreview)
        messageReactionPreview.translatesAutoresizingMaskIntoConstraints = false
        let reactionBottomConstraint = messageReactionPreview.bottomAnchor.constraint(equalTo: bottomAnchor)
        reactionBottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            messageReactionPreview.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 8),
            messageReactionPreview.topAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant:  -6),
            messageReactionPreview.heightAnchor.constraint(equalToConstant: 16),
            reactionBottomConstraint
        ])
        
        addLayoutGuide(messageContainerLayoutGuide)
        NSLayoutConstraint.activate([
            messageContainerLayoutGuide.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor),
            messageContainerLayoutGuide.topAnchor.constraint(equalTo: messageContainerView.topAnchor),
            messageContainerLayoutGuide.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor),
            messageContainerLayoutGuide.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor),
        ])
    }
}
