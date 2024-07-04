//
//  SlideOutAnimationController.swift
//  StoreSearch
//
//  Created by Dzmitry Hlushchuk on 2.07.24.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
            let containerView = transitionContext.containerView
            let time = transitionDuration(using: transitionContext)
            UIView.animate(
                withDuration: time,
                animations: {
                    fromView.center.y -= containerView.bounds.size.height
                    fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                },
                completion: { finished in
                    transitionContext.completeTransition(finished)
                }
            )
        }
    }
    
}
