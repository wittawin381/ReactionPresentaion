//
//  ImageMessageCell.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 5/2/2568 BE.
//

import Foundation
import UIKit

struct ImageMessageConfiguration: UIContentConfiguration {
    let imageURL: String
    
    func makeContentView() -> any UIView & UIContentView {
        ImageMessageView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> ImageMessageConfiguration {
        self
    }
}

class ImageMessageView: UIView {
    private var appliedConfiguration: ImageMessageConfiguration = ImageMessageConfiguration(imageURL: "")
    
    private let contentView = UIView()
    private let imageView = UIImageView()
    
    init(configuration: ImageMessageConfiguration) {
        super.init(frame: .zero)
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}

extension ImageMessageView: UIContentView {
    var configuration: any UIContentConfiguration {
        get { appliedConfiguration }
        set(newValue) {
            guard let newConfiguration = newValue as? ImageMessageConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    private func apply(configuration: ImageMessageConfiguration) {
        
    }
}
