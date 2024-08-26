//
//  PhotoDetailAnimator.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation
import UIKit

// MARK: TODO -> Add Documentation
class PhotoDetailAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var transitioningForward: Bool = true

    private let startingFrame: CGRect
    
    init(startingFrame: CGRect) {
        self.startingFrame = startingFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitioningForward {
            guard let destinationViewController = transitionContext.viewController(forKey: .to),
                  let presentedView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }
            
            let endingFrame = transitionContext.finalFrame(for: destinationViewController)
            presentedView.frame = startingFrame
            presentedView.layer.cornerRadius = 18
            containerView.addSubview(presentedView)
            presentedView.layoutIfNeeded()
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [.curveEaseInOut]) {
                presentedView.frame = endingFrame
                presentedView.layoutIfNeeded()
            } completion: { completed in
                transitionContext.completeTransition(completed)
            }
            
        } else {
            guard let sourceViewController = transitionContext.viewController(forKey: .from),
                  let dismissedView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }
            
            let endingFrame = startingFrame // Transition back to the starting frame
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [.curveEaseInOut]) {
                dismissedView.frame = endingFrame
                dismissedView.layoutIfNeeded()
            } completion: { completed in
                dismissedView.removeFromSuperview()
                transitionContext.completeTransition(completed)
            }
        }
    }
}
