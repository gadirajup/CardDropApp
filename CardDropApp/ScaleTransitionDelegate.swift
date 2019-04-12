//
//  ScaleTransitionDelegate.swift
//  CardDropApp
//
//  Created by Prudhvi Gadiraju on 4/11/19.
//  Copyright © 2019 Brian Advent. All rights reserved.
//

import UIKit

protocol Scaling {
    func scalingImageView(transition: ScaleTransitionDelegate) -> UIImageView?
}

enum TransitionState {
    case begin
    case end
}

class ScaleTransitionDelegate: NSObject {
    let animationDuration = 0.5
}

extension ScaleTransitionDelegate: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return .init(animationDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let background = transitionContext.viewController(forKey: .from)!
        let foreground = transitionContext.viewController(forKey: .to)!
        
        guard let backgroundImageView = (background as? Scaling)?.scalingImageView(transition: self) else {return}
        guard let foregroundImageView = (foreground as? Scaling)?.scalingImageView(transition: self) else {return}
        
        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        imageViewSnapshot.contentMode = .scaleAspectFill
        imageViewSnapshot.layer.masksToBounds = true
        
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        
        let foregroundBGColor = foreground.view.backgroundColor
        foreground.view.backgroundColor = .clear
        container.backgroundColor = .white
        
        container.addSubview(background.view)
        container.addSubview(foreground.view)
        container.addSubview(imageViewSnapshot)
        
        let transitionStateA = TransitionState.begin
        let transitionStateB = TransitionState.end
        
        prepareViews(for: transitionStateA, containerView: container, background: background, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        
        foreground.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.prepareViews(for: transitionStateB, containerView: container, background: background, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        }) { (_) in
            background.view.transform = .identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            
            foreground.view.backgroundColor = foregroundBGColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func prepareViews(for state: TransitionState, containerView: UIView, background: UIViewController, backgroundImageView: UIImageView, foregroundImageView: UIImageView, snapshotImageView: UIImageView) {
        switch state {
        case .begin:
            background.view.transform = .identity
            background.view.alpha = 1
            snapshotImageView.frame = containerView.convert(backgroundImageView.frame, from: backgroundImageView.superview)
        case .end:
            background.view.alpha = 0
            snapshotImageView.frame = containerView.convert(foregroundImageView.frame, from: foregroundImageView.superview)
        }
    }
}

extension ScaleTransitionDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is Scaling && toVC is Scaling {
            return self
        } else {
            return nil
        }
    }
}
