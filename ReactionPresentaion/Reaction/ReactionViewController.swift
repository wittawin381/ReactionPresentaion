//
//  ReactionViewController.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 21/1/2568 BE.
//

import Foundation
import UIKit

protocol ReactionViewControllerDelegate: AnyObject {
    var reactionViewControllerSourceView: UIView? { get }
}

class ReactionViewController: UIViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reactionSelectionListView: ReactionSelectionListView! {
        didSet {
            reactionSelectionListView.delegate = self
        }
    }
    @IBOutlet weak var reactionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var reactionViewTrailingConstraint: NSLayoutConstraint!
    
    //Content View
    @IBOutlet weak var previewContentView: PreviewContentView!
    @IBOutlet weak var previewContentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewContentTrailingConstraint: NSLayoutConstraint!
    
    //Menu View
    @IBOutlet weak var menuViews: MenuView! {
        didSet {
            menuViews.delegate = self
        }
    }
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuViewTrailingConstraint: NSLayoutConstraint!
        
    weak var delegate: ReactionViewControllerDelegate?
    
    enum LayoutDirection {
        case leading
        case trailing
    }
    
    var layoutDirection: LayoutDirection = .leading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPreviewContentView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    override func updateViewConstraints() {
        configureLayout(for: layoutDirection)
        super.updateViewConstraints()
    }
    
    func configureLayout(for layoutDirection: LayoutDirection) {
        switch layoutDirection {
        case .leading:
            reactionViewLeadingConstraint.isActive = true
            reactionViewTrailingConstraint.isActive = false
            
            previewContentLeadingConstraint.isActive = true
            previewContentTrailingConstraint.isActive = false
            
            menuViewLeadingConstraint.isActive = true
            menuViewTrailingConstraint.isActive = false
        case .trailing:
            reactionViewLeadingConstraint.isActive = false
            reactionViewTrailingConstraint.isActive = true
            
            previewContentLeadingConstraint.isActive = false
            previewContentTrailingConstraint.isActive = true
            
            menuViewLeadingConstraint.isActive = false
            menuViewTrailingConstraint.isActive = true
        }
    }
    
    private func setupPreviewContentView() {
        previewContentView.backgroundColor = .clear
        guard let sourceView = delegate?.reactionViewControllerSourceView else { return }
        previewContentView.previewView = sourceView
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}

extension ReactionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == view {
            return true
        }
        return false
    }
}

extension ReactionViewController: ReactionSelectionListViewDelegate {
    func reactionSelectionListView(_ reactionSelectionListView: ReactionSelectionListView, didSelect reaction: String) {
        
    }
    
    func reactionSelectionListViewDidTapSeeMoreReaction(_ reactionSelectionListView: ReactionSelectionListView) {
        
    }
}

extension ReactionViewController: MenuViewDelegate {
    var menuViewMenus: [UIMenu] {
        [
            UIMenu(title: "title", identifier: UIMenu.Identifier(rawValue: "did")),
            UIMenu(title: "title2", identifier: UIMenu.Identifier(rawValue: "did2")),
            UIMenu(title: "title3"),
            UIMenu(title: "title4"),
            UIMenu(title: "titl5"),
            UIMenu(title: "title6")
        ]
    }
    
    func menuViewDidTap() {
        
    }
}
