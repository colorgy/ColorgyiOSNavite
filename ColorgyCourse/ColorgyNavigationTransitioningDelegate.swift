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
	
	public var navigationController: UINavigationController! {
		didSet {
			setupNavigationController()
		}
	}
	private func setupNavigationController() {
		pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
		navigationController.view.addGestureRecognizer(pan)
	}
	
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
		// need a edge gesture to exit presenting view
//		exitingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ColorgyNavigationTransitioningDelegate.handleExitingEdgeGesture(_:)))
//		exitingEdgeGesture.edges = .Left
//		presentingViewController.view.addGestureRecognizer(exitingEdgeGesture)
	}
	private var exitingEdgeGesture: UIScreenEdgePanGestureRecognizer!
	private var pan: UIPanGestureRecognizer!
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
			navigationController?.popViewControllerAnimated(true)
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
	
	@objc private func handlePan(gesture: UIPanGestureRecognizer) {
		
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
			navigationController?.popViewControllerAnimated(true)
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

extension ColorgyNavigationTransitioningDelegate : UINavigationControllerDelegate {
	public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		if operation == UINavigationControllerOperation.Pop {
			return self
		}
		return nil
	}
	
	public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return self
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
	private func OffStagePresentingVC() {
		let offset = presentingViewController.view.bounds.width
		presentingViewController.view.transform = CGAffineTransformMakeTranslation(offset, 0)
	}
	
	private func onStagePresentingVC() {
		presentingViewController.view.transform = CGAffineTransformIdentity
	}
	
	private func offStageMainVC() {
		let offset = mainViewController.view.bounds.width * 0.5
		mainViewController.view.transform = CGAffineTransformMakeTranslation(-offset, 0)
	}
	
	private func onStageMainVC() {
		mainViewController.view.transform = CGAffineTransformIdentity
	}
}

extension ColorgyNavigationTransitioningDelegate : UIViewControllerAnimatedTransitioning {
	public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 1
	}
	
	public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		let container = transitionContext.containerView()!
		let screen: (from: UIViewController, to: UIViewController) =
			(transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!,
			 transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
		
		let mainVC = isPresenting ? screen.from : screen.to
		let presentingVC = isPresenting ? screen.to : screen.from
		
		let duration = transitionDuration(transitionContext)
		
		// Start animation
		// initial state
		if isPresenting {
			OffStagePresentingVC()
		}
		
		// animation part
		UIView.animateWithDuration(duration, delay: 0, options: [], animations: { 
			if self.isPresenting {
				// presenting view enter from right to left
				self.onStagePresentingVC()
				// main view move a bit to left
				self.offStageMainVC()
			} else {
				// dismiss presenting view
				self.OffStagePresentingVC()
				// get back main view
				self.onStageMainVC()
			}
			}, completion: { (finished) in
				if transitionContext.transitionWasCancelled() {
					// transition was cancelled, not completing the transition
					transitionContext.completeTransition(false)
					// from view is still in presenting
					UIApplication.sharedApplication().keyWindow?.addSubview(screen.from.view)
				} else {
					// transition completed
					transitionContext.completeTransition(true)
					UIApplication.sharedApplication().keyWindow?.addSubview(screen.to.view)
				}
		})
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}