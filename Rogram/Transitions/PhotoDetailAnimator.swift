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
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            transitioningForward,
            let destinationViewController = transitionContext.viewController(forKey: .to)
        else { 
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        let containerView = transitionContext.containerView
        let presentedView = transitionContext.view(forKey: .to)
        
        // Provided via the presentation controller
        let endingFrame = transitionContext.finalFrame(for: destinationViewController)
        
        if let presentedView = presentedView {
            presentedView.frame = startingFrame
            presentedView.layer.cornerRadius = 18
            presentedView.layoutIfNeeded()
            containerView.addSubview(presentedView)
            
            UIView.animate(withDuration: 0.5) {
                presentedView.frame = endingFrame
            } completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
