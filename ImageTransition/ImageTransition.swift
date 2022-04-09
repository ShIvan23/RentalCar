//
//  ImageTransition.swift
//  RentalCar
//
//  Created by Ivan on 09.04.2022.
//

import UIKit

final class ImageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.3
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let currentView = presenting ? toView! : fromView!
        
        UIView.animate(
            withDuration: duration) {
                if self.presenting {
                    containerView.addSubview(currentView)
                    currentView.alpha = 0.0
                }
                currentView.alpha = self.presenting ? 1.0 : 0.0
            } completion: { _ in
                transitionContext.completeTransition(true)
            }
    }
}
