//
//  ReactionPresentaionController.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 21/1/2568 BE.
//

import UIKit

protocol ReactionPresentaionControllerSourceItem {
    
}

class ReactionPresentaionController: UIPresentationController {
    override var shouldPresentInFullscreen: Bool { true }
    override var shouldRemovePresentersView: Bool { false }
    
    private var visualEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(visualEffectView)
        visualEffectView.frame = containerView!.bounds
        visualEffectView.contentView.addSubview(presentedViewController.view)
        visualEffectView.alpha = 0
        visualEffectView.contentView.frame = presentedViewController.view.bounds
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self else { return }
            visualEffectView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        visualEffectView.alpha = 1
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self else { return }
            visualEffectView.alpha = 0
        }, completion: { [weak self] context in
            if (!context.isCancelled) {
                guard let self else { return }
                visualEffectView.removeFromSuperview()
            }
        })
    }
}
