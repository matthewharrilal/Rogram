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
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if transitioningForward {
            animatePresentation(using: transitionContext)
        } else {
            animateDismissal(using: transitionContext)
        }
    }
    
    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationViewController = transitionContext.viewController(forKey: .to),
              let presentedView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let endingFrame = transitionContext.finalFrame(for: destinationViewController)
        
        presentedView.frame = startingFrame
        presentedView.layer.cornerRadius = 18
        containerView.addSubview(presentedView)
        
        // Initially hide the subviews and prepare for a slight scale up animation
        presentedView.subviews.forEach { subview in
            subview.alpha = 0.0
            subview.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        presentedView.layoutIfNeeded()
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: [.calculationModeCubic]) {
            // First keyframe: Animate the main view to its final position with a spring effect
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6) {
                presentedView.frame = endingFrame
                presentedView.backgroundColor = .white
                presentedView.layoutIfNeeded()
            }
            
            // Second keyframe: Gradually fade in and scale the subviews as the view expands
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8) {
                presentedView.subviews.forEach { subview in
                    subview.alpha = 1.0
                    subview.transform = .identity // Reset the scale to normal
                }
                presentedView.layoutIfNeeded()
            }
            
        } completion: { completed in
            transitionContext.completeTransition(completed)
        }
    }
    
    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let dismissedView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let endingFrame = startingFrame // Transition back to the starting frame
        
        dismissedView.layoutIfNeeded()
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: [.calculationModeCubic]) {
            // First keyframe: Gradually fade out and scale down the subviews
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6) {
                dismissedView.subviews.forEach { subview in
                    subview.alpha = 0.0
                    subview.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
            }
            
            // Second keyframe: Animate the main view back to its original frame with a spring effect
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                dismissedView.frame = endingFrame
                dismissedView.backgroundColor = .clear
                dismissedView.layoutIfNeeded()
            }
            
        } completion: { completed in
            dismissedView.removeFromSuperview()
            transitionContext.completeTransition(completed)
        }
    }
}
