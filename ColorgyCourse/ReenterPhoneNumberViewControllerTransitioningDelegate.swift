//
//  ReenterPhoneNumberViewControllerTransitioningDelegate.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/27.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

final public class ReenterPhoneNumberViewControllerTransitioningDelegate: NSObject {
	private var isPresenting: Bool = false
	public var transitionDurationForPresentation: NSTimeInterval = 0.2
	public var transitionDurationForDismissal: NSTimeInterval = 0.2
	
	public var presentingViewController: ReenterPhoneViewController? {
		didSet {
			setupPresentingVC()
		}
	}
	public var mainViewController: PhoneValidationViewController? {
		didSet {
			setupMainVC()
		}
	}
	
	private func setupPresentingVC() {
		presentingViewController?.transitioningDelegate = self
	}
	
	private func setupMainVC() {
		mainViewController?.transitioningDelegate = self
	}
}

extension ReenterPhoneNumberViewControllerTransitioningDelegate : UIViewControllerTransitioningDelegate {
	public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
}

extension ReenterPhoneNumberViewControllerTransitioningDelegate : UIViewControllerAnimatedTransitioning {
	public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return isPresenting ? transitionDurationForPresentation : transitionDurationForDismissal
	}
	
	public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		// preparation code
		let container = transitionContext.containerView()!
		let screen: (from: UIViewController, to: UIViewController) =
			(transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!,
			 transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
		let duration = transitionDuration(transitionContext)
		
		let presentingVC = !isPresenting ? screen.from as! ReenterPhoneViewController : screen.to as! ReenterPhoneViewController
		let mainVC = !isPresenting ? screen.to as! PhoneValidationViewController : screen.from as! PhoneValidationViewController
		
		if isPresenting {
			// initial state
			presentingVC.reenterPhoneNumberView.transform = CGAffineTransformMakeScale(1.15, 1.15)
			presentingVC.reenterPhoneNumberView.alpha = 0
			presentingVC.view.backgroundColor = UIColor.blackColor().withAlpha(0)
		}
		
		let mainVCSnapshot = mainVC.view.resizableSnapshotViewFromRect(mainVC.view.bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
		container.addSubview(mainVCSnapshot)
		container.addSubview(presentingVC.view)
		
		UIView.animateWithDuration(duration, animations: { 
			if self.isPresenting {
				// goto reenter
				presentingVC.reenterPhoneNumberView.transform = CGAffineTransformIdentity
				presentingVC.reenterPhoneNumberView.alpha = 1
				presentingVC.view.backgroundColor = UIColor.blackColor().withAlpha(0.7)
			} else {
				// back
				presentingVC.view.alpha = 0
				presentingVC.reenterPhoneNumberView.alpha = 0
			}
			}, completion: { (finished) in
				transitionContext.completeTransition(true)
		})
	}
}