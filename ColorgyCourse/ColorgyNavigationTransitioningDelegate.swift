//
//  ColorgyNavigationTransitioningDelegate.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/15.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

final public class ColorgyNavigationTransitioningDelegate: UIPercentDrivenInteractiveTransition {
	private var isInteractive: Bool = false
	private var isPresenting: Bool = false
	
	public var mainViewController: UIViewController! {
		didSet {
			setupMainVC()
		}
	}
	private func setupMainVC() {
		
	}
	
	public var presentingViewController: UIViewController! {
		didSet {
			setupPresentingVC()
		}
	}
	private func setupPresentingVC() {
		exitingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ColorgyNavigationTransitioningDelegate.handleExitingEdgeGesture(_:)))
		exitingEdgeGesture.edges = .Left
		presentingViewController.view.addGestureRecognizer(exitingEdgeGesture)
	}
	private var exitingEdgeGesture: UIScreenEdgePanGestureRecognizer!
	@objc private func handleExitingEdgeGesture(gesture: UIScreenEdgePanGestureRecognizer) {
		
		// get offset
		let translation = gesture.translationInView(presentingViewController.view)
		// calculate the progress
		// max from x to 0 to prevent negative progress
		// min from x to 1 is to prevent progress to exceed 0~1
		let progress = min(max((translation.x / UIScreen.mainScreen().bounds.width), 0), 1)
		
		// handle gesture
		switch gesture.state {
		case .Began:
			// while began, mark interactive flag to true
			isInteractive = true
			// start the dismiss work
//			navigationController?.popViewControllerAnimated(true)
			presentingViewController.dismissViewControllerAnimated(true, completion: nil)
		case .Changed:
			// update ui according to the progress
			updateInteractiveTransition(progress)
		default:
			// finished, cancelled, interrupted
			isInteractive = false
			// check the progress, larger than 50% will finish the transition
			progress > 0.5 ? finishInteractiveTransition() : cancelInteractiveTransition()
		}
	}
}

extension ColorgyNavigationTransitioningDelegate : UIViewControllerTransitioningDelegate {
	public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
	
	public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return isInteractive ? self : nil
	}
	
	public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return isInteractive ? self : nil
	}
}

extension ColorgyNavigationTransitioningDelegate {
	private func offStagePresentingVC() {
		presentingViewController.view.transform = CGAffineTransformMakeTranslation(presentingViewController.view.bounds.width, 0)
	}
	
	private func onStagePresentingVC() {
		presentingViewController.view.transform = CGAffineTransformIdentity
	}
	
	private func offStageMainVC() {
		let mainOffset: CGFloat = 150
		let move = CGAffineTransformMakeTranslation(-mainOffset, 0)
		mainViewController.view.transform = CGAffineTransformScale(move, 0.9, 0.9)
	}
	
	private func onStageMainVC() {
		mainViewController.view.transform = CGAffineTransformIdentity
	}
}

extension ColorgyNavigationTransitioningDelegate : UIViewControllerAnimatedTransitioning {
	public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.4
	}
	
	// Animation code
	public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		let container = transitionContext.containerView()!
		let screen: (from: UIViewController, to: UIViewController) =
			(transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!,
			 transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
		
		let mainVC = isPresenting ? screen.from : screen.to
		let presentingVC = isPresenting ? screen.to : screen.from
		
		let mainVCSnapshot = mainVC.view.resizableSnapshotViewFromRect(UIScreen.mainScreen().bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
		let presentingVCSnapshot = presentingVC.view.resizableSnapshotViewFromRect(UIScreen.mainScreen().bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
		
		let duration = transitionDuration(transitionContext)
		
		container.addSubview(mainVC.view)
		container.addSubview(presentingVC.view)
		
		// Start animation
		// initial state
		if isPresenting {
			offStagePresentingVC()
		} else {
			offStageMainVC()
		}
		
		// animation part
		UIView.animateWithDuration(duration, delay: 0, options: [], animations: { 
			if self.isPresenting {
				// presenting view enter from right to left
				self.onStagePresentingVC()
				// main view move a bit to left
				self.offStageMainVC()
			} else {
				// get back main view
				self.onStageMainVC()
				// dismiss presenting view
				self.offStagePresentingVC()
			}
			}, completion: { (finished) in
				if transitionContext.transitionWasCancelled() {
					// transition was cancelled, not completing the transition
					transitionContext.completeTransition(false)
					// from view is still in presenting
					presentingVCSnapshot.removeFromSuperview()
					screen.from.view.transform = CGAffineTransformIdentity
					UIApplication.sharedApplication().keyWindow?.addSubview(screen.from.view)
				} else {
					// transition completed
					transitionContext.completeTransition(true)
					screen.to.view.transform = CGAffineTransformIdentity
					UIApplication.sharedApplication().keyWindow?.addSubview(screen.to.view)
				}
		})
		
	}
}