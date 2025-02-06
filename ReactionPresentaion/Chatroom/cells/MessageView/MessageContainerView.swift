//
//  MessageContainerView.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 6/2/2568 BE.
//

import Foundation
import UIKit

protocol MessageContainerContentAdjustableView {
    func messageContainer(maskedCorner: CACornerMask)
}

class MessageContainerView: UIView, MessageContainerContentAdjustableView {    
    private var maskedCorner: CACornerMask = [
        .layerMinXMinYCorner,
        .layerMaxXMaxYCorner,
        .layerMinXMaxYCorner,
        .layerMaxXMinYCorner
    ]
    
    private var defaultLayoutMargins = UIEdgeInsets(
        top: 8,
        left: 8,
        bottom: 8,
        right: 8)
    
    override var layoutMargins: UIEdgeInsets {
        get { defaultLayoutMargins }
        set { defaultLayoutMargins = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        layer.maskedCorners = maskedCorner
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
//        let radiusPath = UIBezierPath(
//            roundedRect: bounds,
//            byRoundingCorners: maskedCorner,
//            cornerRadii: CGSize(width: 16, height: 16)
//        )
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = radiusPath.cgPath
//        layer.mask = maskLayer
    }
    
    func messageContainer(maskedCorner: CACornerMask) {
        self.maskedCorner = maskedCorner
        setNeedsLayout()
    }
}
