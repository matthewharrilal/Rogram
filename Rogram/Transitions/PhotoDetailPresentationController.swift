//
//  PhotoDetailPresentationController.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation
import UIKit

// MARK: TODO -> Add Documentation
class PhotoDetailPresentationController: UIPresentationController {
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        UIScreen.main.bounds
    }
}
