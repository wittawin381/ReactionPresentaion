//
//  LinkMessageCell.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 5/2/2568 BE.
//

import Foundation
import UIKit

struct LinkMessageConfiguration: UIContentConfiguration, Hashable {
    let url: String
    
    func makeContentView() -> any UIView & UIContentView {
        LinkMessageView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> LinkMessageConfiguration {
        self
    }
}

class LinkMessageView: UIView {
    private var appliedConfiguration: LinkMessageConfiguration = LinkMessageConfiguration(url: "")
    
    init(configuration: LinkMessageConfiguration) {
        super.init(frame: .zero)
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LinkMessageView: UIContentView {
    var configuration: any UIContentConfiguration {
        get { appliedConfiguration }
        set(newValue) {
            guard let newConfiguration = newValue as? LinkMessageConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    private func apply(configuration: LinkMessageConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
    }
}
