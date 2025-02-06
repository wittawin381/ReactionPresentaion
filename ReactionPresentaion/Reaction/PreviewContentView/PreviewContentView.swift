//
//  PreviewContentView.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 25/1/2568 BE.
//

import Foundation
import UIKit

class PreviewContentView: UIView {
    private var preferredMaxLayoutWidth: CGFloat = 0
    private var preferredMaxLayoutHeight: CGFloat = 0
    
    var previewView: UIView? {
        didSet {
            guard let previewView else { return }
            let replicatorLayer = CAReplicatorLayer()
            let previewLayer = previewView.snapshotView(afterScreenUpdates: true)!.layer
            replicatorLayer.addSublayer(previewLayer)
            replicatorLayer.instanceCount = 1
            
            self.previewLayer?.removeFromSuperlayer()
            layer.addSublayer(replicatorLayer)
            self.previewLayer = replicatorLayer
            
            setNeedsLayout()
        }
    }
    
    private var previewLayer: CALayer?
        
    override var intrinsicContentSize: CGSize {
        
        guard let sourceView = previewView else {
            return .zero
        }
               
        let width = preferredMaxLayoutWidth == 0 ? sourceView.frame.width : preferredMaxLayoutWidth
        
        let finalSize = sizeThatFits(CGSize(width: width, height: sourceView.frame.height))
        
        previewLayer?.transform = CATransform3DMakeScale(
            finalSize.width / sourceView.frame.width,
            finalSize.height / sourceView.frame.height,
            0)
        
        return finalSize
    }
    
    override func layoutSubviews() {
        if frame.size.width != preferredMaxLayoutWidth || frame.size.height != preferredMaxLayoutHeight {
            preferredMaxLayoutWidth = frame.size.width
            preferredMaxLayoutHeight = frame.size.height
            return invalidateIntrinsicContentSize()
        }
        
        if let sourceView = previewView {
            layer.cornerRadius = sourceView.layer.cornerRadius
            layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                            cornerRadius: sourceView.layer.cornerRadius).cgPath
            layer.shadowRadius = 10
            layer.shadowOpacity = 0.1
        }
        super.layoutSubviews()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let sourceView = previewView else {
            return .zero
        }
        let maxWidth = size.width
                
        let preferredWidthSize = sizeForPreviewPreferredWidth(sourceViewSize: sourceView.frame.size, maxWidth: maxWidth)
        
        if preferredWidthSize.height > preferredMaxLayoutHeight && preferredMaxLayoutHeight != 0 {
            let heightToMaxHeight = preferredMaxLayoutHeight / preferredWidthSize.height
            let width = preferredWidthSize.width * heightToMaxHeight
        
            return CGSize(width: width, height: preferredMaxLayoutHeight)
        }
        
        return preferredWidthSize
    }
    
    private func sizeForPreviewPreferredWidth(sourceViewSize: CGSize, maxWidth: CGFloat) -> CGSize {
        if sourceViewSize.width > maxWidth {
            let width = maxWidth
            let ratio = maxWidth / sourceViewSize.width
            let height = sourceViewSize.height * ratio
            return CGSize(width: width, height: height)
        } else {
            let width = sourceViewSize.width
            let ratio = sourceViewSize.width / maxWidth
            let height = sourceViewSize.height * ratio
            return CGSize(width: width, height: height)
        }
    }
}
