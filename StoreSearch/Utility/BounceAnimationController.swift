//
//  BounceAnimationController.swift
//  StoreSearch
//
//  Created by Dzmitry Hlushchuk on 2.07.24.
//

import UIKit

class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.4
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
           let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
            let containerView = transitionContext.containerView
            toView.frame = transitionContext.finalFrame(for: toViewController)
            containerView.addSubview(toView)
            toView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animateKeyframes(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.334) {
                        toView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.33) {
                        toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                        toView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                },
                completion: { finished in
                    transitionContext.completeTransition(finished)
                }
            )
        }
    }
    
}
