//
//  PhotoTransitionDelegate.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation
import UIKit

// MARK: TODO -> Add Documentation
class PhotoTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private lazy var transitionAnimator = PhotoDetailAnimator(startingFrame: startingFrame)
    
    public var startingFrame: CGRect = .zero {
        didSet {
            transitionAnimator = PhotoDetailAnimator(startingFrame: startingFrame)
        }
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PhotoDetailPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.transitioningForward = true
        return transitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.transitioningForward = false
        return transitionAnimator
    }
}
