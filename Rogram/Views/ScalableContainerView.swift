//
//  ScalableContainerView.swift
//  Rogram
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation
import UIKit

class ScalableContainerView: UIView {
    
    private var animator: UIViewPropertyAnimator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut, animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            self?.layer.shadowOpacity = 0.3
        })
        
        animator?.startAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut, animations: { [weak self] in
            self?.transform = .identity
            self?.layer.shadowOpacity = 0
        })
        
        animator?.startAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        animator?.stopAnimation(true)
        
        animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut, animations: { [weak self] in
            self?.transform = .identity
            self?.layer.shadowOpacity = 0
        })
        
        animator?.startAnimation()
    }
}
