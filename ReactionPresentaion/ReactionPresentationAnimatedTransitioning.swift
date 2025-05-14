//
//  ReactionPresentationAnimatedTransitioning.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 25/1/2568 BE.
//

import Foundation
import UIKit

protocol ReactionPresentationTransitioningDelegate: AnyObject {
    var reactionPresentationControllerSourceView: UIView { get }
    var reactionPresentationControllerLayoutDirection: ReactionViewController.LayoutDirection { get }
}

private let kTransitionDuration = 0.3
private let kPresentedShadowOpacity: Float = 0.1
private let kDismissedShadowOpacity: Float = 0

class ReactionPresentationAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let operation: Operation
    private weak var sourceTransitioningItem: ReactionPresentationTransitioningDelegate?
    
    init(operation: Operation, sourceTransitioningItem: ReactionPresentationTransitioningDelegate) {
        self.operation = operation
        self.sourceTransitioningItem = sourceTransitioningItem
    }
    
    enum Operation {
        case presented
        case dismissed
        
        var viewOpacity: Float {
            switch self {
            case .presented:
                kPresentedShadowOpacity
            case .dismissed:
                kDismissedShadowOpacity
            }
        }
    }
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        kTransitionDuration
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        switch operation {
        case .presented:
            animateTransitionForPresented(using: transitionContext)
        case .dismissed:
            animateTransitionForDismissed(using: transitionContext)
        }
    }
    
    private func animateTransitionForPresented(using transitionContext: any UIViewControllerContextTransitioning) {
        UIImpactFeedbackGenerator().impactOccurred()
        guard let sourceTransitioningItem,
              let toView = transitionContext.view(forKey: .to),
              let toViewController = transitionContext.viewController(forKey: .to) as? ReactionViewController else { return }
        
        let containerView = transitionContext.containerView
        toView.alpha = 0
        toView.frame = transitionContext.finalFrame(for: toViewController)
        containerView.addSubview(toView)
        
        
        let fromPreviewView = sourceTransitioningItem.reactionPresentationControllerSourceView
        let toPreviewView = toViewController.previewContentView
        
        let initialPreviewFrame = fromPreviewView.frameInWindow ?? .zero
        toViewController.topConstraint.constant = initialPreviewFrame.minY - 130
        toViewController.layoutDirection = sourceTransitioningItem.reactionPresentationControllerLayoutDirection
        toViewController.view.layoutIfNeeded()
        
        let snapshotView = preparePreviewContentViewSnapshot(for: operation, from: fromPreviewView, to: toPreviewView)
        
        if let snapshotView {
            containerView.addSubview(snapshotView)
        }
        
        
        let menuViewScale: CGFloat = 0.2
        let menuViewMask = UIView()
        if let menuView = toViewController.menuViews {
            let xPostion = switch sourceTransitioningItem.reactionPresentationControllerLayoutDirection {
            case .leading:
                snapshotView?.frame.minX ?? 0
            case .trailing:
                snapshotView?.frame.maxX ?? 0
            }
            let xDiffFromPreviewView = xPostion - (menuView.frameInWindow?.minX ?? 0)
            let translateX = ((menuView.bounds.width - (menuView.bounds.width  * menuViewScale)) / 2) - xDiffFromPreviewView
            let translateY = (menuView.bounds.height - (menuView.bounds.height  * menuViewScale)) / 2
            
            menuView.transform = CGAffineTransform(
                translationX: -translateX,
                y: -translateY)
            .scaledBy(x: menuViewScale, y: menuViewScale)
            
            menuViewMask.backgroundColor = .black
            menuViewMask.frame = CGRect(origin: menuView.bounds.origin, size: CGSize(width: menuView.bounds.width, height:  menuView.bounds.height / 2))
            menuViewMask.layer.cornerRadius = menuView.layer.cornerRadius
            menuView.mask = menuViewMask
        }
        
        let (maskView, shadowView): (UIView, UIView) = {
            if let reactionView = toViewController.reactionSelectionListView, let snapshotView {
                let reactionViewFrame = reactionView.frame
                let snapshotViewFrame = snapshotView.superview?.convert(snapshotView.frame, to: toViewController.view) ?? .zero
                
                let translateX = snapshotViewFrame.origin.x - reactionViewFrame.origin.x + snapshotView.frame.width - 28
                let translateY = snapshotViewFrame.origin.y - reactionViewFrame.origin.y - 10
                
                reactionView.transform = .init(translationX: translateX, y: translateY)
                
                let originInWindow = CGPoint(x: snapshotView.frame.maxX - 10.0, y: snapshotView.frame.minY - 10)
                let frameInReactionView = reactionView.convert(originInWindow, from: containerView)
                
                let shadowView = UIView(frame: CGRect(origin: originInWindow, size: CGSize(width: 10, height: 10)))
                shadowView.layer.cornerRadius = 5
                shadowView.backgroundColor = reactionView.backgroundColor
                shadowView.layer.shadowRadius = reactionView.layer.shadowRadius
                shadowView.layer.shadowOpacity = reactionView.layer.shadowOpacity
                shadowView.layer.shadowPath = UIBezierPath(
                    roundedRect: shadowView.bounds,
                    cornerRadius: shadowView.layer.cornerRadius).cgPath
                
                containerView.insertSubview(shadowView, belowSubview: toView)
                
                let maskView = UIView(frame: CGRect(origin: frameInReactionView, size: CGSize(width: 10, height: 10)))
                maskView.backgroundColor = .black
                maskView.layer.cornerRadius = maskView.bounds.height / 2
                
                reactionView.mask = maskView
                
                return (maskView, shadowView)
            }
            return (UIView(), UIView())
        } ()
        
        UIView.animate(
            springDuration: 0.4,
            bounce: 0.2,
            initialSpringVelocity: 3,
            animations: {
                toView.alpha = 1
                toViewController.menuViews?.transform = .identity
                
                self.animatePreviewContentViewSnapshot(
                    snapshotView: snapshotView,
                    to: toPreviewView,
                    for: self.operation)
                
                if let reactionView = toViewController.reactionSelectionListView {
                    reactionView.transform = .identity
                    maskView.frame = reactionView.bounds
                    maskView.layer.cornerRadius = reactionView.layer.cornerRadius
                    
                    shadowView.frame = reactionView.frameInWindow ?? .zero
                    shadowView.layer.cornerRadius = reactionView.frame.height / 2
                    shadowView.layer.shadowPath = UIBezierPath(
                        roundedRect: shadowView.bounds,
                        cornerRadius: shadowView.layer.cornerRadius).cgPath
                }
                
                menuViewMask.frame = toViewController.menuViews?.bounds ?? .zero
            },
            completion: { _ in
                toPreviewView?.isHidden = false
                snapshotView?.removeFromSuperview()
                maskView.removeFromSuperview()
                shadowView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
    private func animateTransitionForDismissed(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let sourceTransitioningItem,
              let fromView = transitionContext.view(forKey: .from),
              let fromViewController = transitionContext.viewController(forKey: .from) as? ReactionViewController else { return }
        
        let containerView = transitionContext.containerView
        
        let fromPreviewView = fromViewController.previewContentView
        let toPreviewView = sourceTransitioningItem.reactionPresentationControllerSourceView
        fromPreviewView?.layer.shadowOpacity = 0
        let snapshotView = preparePreviewContentViewSnapshot(for: operation, from: fromPreviewView, to: toPreviewView)
        
        if let snapshotView {
            containerView.addSubview(snapshotView)
        }
        
        fromView.alpha = 1
        
        let (maskView, shadowView): (UIView, UIView) = {
            if let reactionView = fromViewController.reactionSelectionListView {
                let shadowView = UIView(frame: reactionView.frameInWindow ?? .zero)
                shadowView.layer.cornerRadius = reactionView.layer.cornerRadius
                shadowView.backgroundColor = reactionView.backgroundColor
                shadowView.layer.shadowRadius = reactionView.layer.shadowRadius
                shadowView.layer.shadowOpacity = reactionView.layer.shadowOpacity
                shadowView.layer.shadowPath = UIBezierPath(
                    roundedRect: shadowView.bounds,
                    cornerRadius: shadowView.layer.cornerRadius).cgPath
                
                containerView.insertSubview(shadowView, belowSubview: fromView)
                
                let maskView = UIView(frame: reactionView.bounds)
                maskView.backgroundColor = .black
                maskView.layer.cornerRadius = reactionView.layer.cornerRadius
                
                reactionView.mask = maskView
                
                return (maskView, shadowView)
            }
            return (UIView(), UIView())
        } ()
        
        UIView.animate(
            springDuration: 0.4,
            bounce: 0.1,
            initialSpringVelocity: 3,
            animations: {
                fromView.alpha = 0
                
                let menuViewScale: CGFloat = 0.2
                if let menuView = fromViewController.menuViews {
                    let xPostion = switch sourceTransitioningItem.reactionPresentationControllerLayoutDirection {
                    case .leading:
                        toPreviewView.frame.minX
                    case .trailing:
                        toPreviewView.frame.maxX
                    }
                    let xDiffFromPreviewView = xPostion - (menuView.frameInWindow?.minX ?? 0)
                    let translateX = ((menuView.bounds.width - (menuView.bounds.width  * menuViewScale)) / 2) - xDiffFromPreviewView
                    let translateY = (menuView.bounds.height - (menuView.bounds.height  * menuViewScale)) / 2
                    menuView.transform = CGAffineTransform(
                        translationX: -translateX,
                        y: -translateY)
                    .scaledBy(x: menuViewScale, y: menuViewScale)
                }
                
                if let reactionView = fromViewController.reactionSelectionListView, let snapshotView {
                    reactionView.transform = .identity
                    
                    let reactionViewFrame = reactionView.frame
                    let previewViewFrame = snapshotView.superview?.convert(snapshotView.frame, to: fromViewController.view) ?? .zero
                    
                    let translateX = previewViewFrame.origin.x - reactionViewFrame.origin.x + snapshotView.frame.width - 28
                    let translateY = previewViewFrame.origin.y - reactionViewFrame.origin.y - reactionView.frame.height
    
                    reactionView.transform = .init(translationX: translateX, y: translateY)
                    
                    let originInWindow = CGPoint(x: snapshotView.frame.maxX - 10.0, y: snapshotView.frame.minY - 20)
                    let frameInReactionView = reactionView.convert(originInWindow, from: containerView)
                    
                    maskView.frame = CGRect(origin: frameInReactionView, size: CGSize(width: 0, height: 0))
                    maskView.layer.cornerRadius = maskView.bounds.height / 2.0
                    
                    shadowView.frame = maskView.frameInWindow ?? .zero
                    shadowView.layer.cornerRadius = shadowView.bounds.height / 2.0
                    shadowView.layer.shadowPath = UIBezierPath(
                        roundedRect: shadowView.bounds,
                        cornerRadius: shadowView.layer.cornerRadius).cgPath
                }
                
                self.animatePreviewContentViewSnapshot(snapshotView: snapshotView, to: toPreviewView, for: self.operation)
            },
            completion: { _ in
                fromPreviewView?.isHidden = false
                toPreviewView.isHidden = false
                snapshotView?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
    private func preparePreviewContentViewSnapshot(for operation: Operation, from fromPreviewView: UIView?, to toPreviewView: UIView?) -> UIView? {
        let snapshotView = fromPreviewView?.snapshotView(afterScreenUpdates: true)
        let initialPreviewFrame = fromPreviewView?.frameInWindow ?? .zero
        snapshotView?.frame = initialPreviewFrame
        snapshotView?.layer.shadowOpacity = operation.viewOpacity
        snapshotView?.backgroundColor = .clear
        snapshotView?.layer.shadowRadius = 10
        snapshotView?.layer.shadowPath = UIBezierPath(roundedRect: snapshotView?.bounds ?? .zero,
                                                      cornerRadius: 0).cgPath
        
        fromPreviewView?.isHidden = true
        toPreviewView?.isHidden = true
        
        return snapshotView
    }
    
    private func animatePreviewContentViewSnapshot(
        snapshotView: UIView?,
        to toView: UIView?,
        for operation: Operation
    ) {
        let finalPreviewFrame = toView?.frameInWindow ?? .zero
        snapshotView?.frame = finalPreviewFrame
        snapshotView?.layer.shadowOpacity = operation.viewOpacity
        snapshotView?.layer.shadowPath = UIBezierPath(roundedRect: snapshotView?.bounds ?? .zero,
                                                      cornerRadius: 0).cgPath
    }
}

extension UIView {
    var frameInWindow: CGRect? {
        superview?.convert(frame, to: nil)
    }
}
