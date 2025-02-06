//
//  ReactionCollectionViewCell.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 21/1/2568 BE.
//

import Foundation
import UIKit

struct ReactionBackgroundConfiguration {
    static func configuration(for state: UICellConfigurationState, cornerRadius: CGFloat) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = cornerRadius
        if state.isSelected {
            background.backgroundColor = .systemGreen
            return background
        }
        
        return background
    }
}

struct ReactionContentConfiguration: UIContentConfiguration, Hashable {
    let emoji: String
    
    func makeContentView() -> any UIView & UIContentView {
        ReactionImageView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> ReactionContentConfiguration {
        ReactionContentConfiguration(emoji: emoji)
    }
}

class ReactionImageView: UIView, UIContentView {
    var configuration: any UIContentConfiguration {
        didSet {
            guard let reactionConfiguration = configuration as? ReactionContentConfiguration else { return }
            configure(with: reactionConfiguration)
        }
    }
    
    private let emojiLabel: UILabel = UILabel()
    
    init(configuration: ReactionContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        emojiLabel.font = .systemFont(ofSize: bounds.width / 1.5)
    }
    
    private func configure(with configuration: ReactionContentConfiguration) {
        emojiLabel.text = configuration.emoji
    }
    
    private func initLayout() {
        addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiLabel.topAnchor.constraint(equalTo: topAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        emojiLabel.textAlignment = .center
    }
}

class ReactionCollectionViewCell: UICollectionViewCell {
    override func updateConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration = ReactionBackgroundConfiguration.configuration(for: state, cornerRadius: bounds.width / 2)
        
        guard let oldConfiguration = contentConfiguration as? ReactionContentConfiguration else { return }
        contentConfiguration = ReactionContentConfiguration(emoji: oldConfiguration.emoji).updated(for: state)
    }
}
