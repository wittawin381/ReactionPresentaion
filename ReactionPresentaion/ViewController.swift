//
//  ViewController.swift
//  ReactionPresentaion
//
//  Created by Wittawin Muangnoi on 21/1/2568 BE.
//

import UIKit

class ViewController: UIViewController, UIContextMenuInteractionDelegate {
    @IBOutlet weak var interactionView: UIView!
    
    let reactionPresentationTransitionController = ReactionPresentaionTransitionController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactionPresentationTransitionController.transitioningViewController = self
        interactionView.layer.cornerRadius = 16
    }
    
    @IBAction func buttonDidTap() {
        let chatRoomViewController = ChatRoomViewController()
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                suggestedActions in
            let inspectAction =
                UIAction(title: NSLocalizedString("InspectTitle", comment: ""),
                         image: UIImage(systemName: "arrow.up.square")) { action in
                }
                
            let duplicateAction =
                UIAction(title: NSLocalizedString("DuplicateTitle", comment: ""),
                         image: UIImage(systemName: "plus.square.on.square")) { action in
                }
                
            let deleteAction =
                UIAction(title: NSLocalizedString("DeleteTitle", comment: ""),
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive) { action in
                }
                                            
            return UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
        })
    }
}

extension ViewController: ReactionViewControllerDelegate {
    var reactionViewControllerSourceView: UIView? {
        interactionView
    }
}

extension ViewController: ReactionPresentationTransitioningDelegate {
    var reactionPresentationControllerSourceView: UIView {
        interactionView
    }
}
