//
//  MessageReactionPreview.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 6/2/2568 BE.
//

import Foundation
import UIKit

class MessageReactionPreview: UIView {
    private let reactionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setupLayout() {
        layoutMargins = UIEdgeInsets(
            top: 4,
            left: 4,
            bottom: 4,
            right: 4)
        
        addSubview(reactionLabel)
        reactionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reactionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            reactionLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            reactionLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            reactionLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            reactionLabel.widthAnchor.constraint(greaterThanOrEqualTo: heightAnchor, constant: 8)
        ])
    }
}
