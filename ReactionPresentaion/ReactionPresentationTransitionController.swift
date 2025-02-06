//
//  ReactionPresentationTransitionController.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 28/1/2568 BE.
//

import UIKit

class ReactionPresentaionTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    weak var transitioningViewController: ReactionPresentationTransitioningDelegate?
    
    init(transitioningViewController: ReactionPresentationTransitioningDelegate? = nil) {
        self.transitioningViewController = transitioningViewController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let transitioningViewController else { return nil }
        return ReactionPresentationAnimatedTransitioning(
            operation: .presented,
            sourceTransitioningItem: transitioningViewController)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let transitioningViewController else { return nil }
        return ReactionPresentationAnimatedTransitioning(
            operation: .dismissed,
            sourceTransitioningItem: transitioningViewController)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ReactionPresentaionController(presentedViewController: presented, presenting: presenting)
    }
}
