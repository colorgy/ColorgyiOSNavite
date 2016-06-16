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
		exitingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ColorgyNavigationTransitioningDelegate.handleExitingEdgeGesture(_:)))
		exitingEdgeGesture.edges = .Left
		navigationController.view.addGestureRecognizer(exitingEdgeGesture)
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
		exitingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ColorgyNavigationTransitioningDelegate.handleExitingEdgeGesture(_:)))
		exitingEdgeGesture.edges = .Left
		pan = UIPanGestureRecognizer(target: self, action: #selector(ColorgyNavigationTransitioningDelegate.handlePanGesture(_:)))
		presentingViewController.view.addGestureRecognizer(pan)
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
	private var pan: UIPanGestureRecognizer!
	@objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
		
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
	
	private func offStageMainView(view: UIView) {
		let offset = mainViewController.view.bounds.width * 0.5
		view.transform = CGAffineTransformMakeTranslation(-offset, 0)
	}
	
	private func onStageMainView(view: UIView) {
		view.transform = CGAffineTransformIdentity
	}
}

extension ColorgyNavigationTransitioningDelegate : UIViewControllerAnimatedTransitioning {
	public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 1
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
		let mainOffset: CGFloat = 150
		if isPresenting {
			presentingVC.view.transform = CGAffineTransformMakeTranslation(presentingVC.view.bounds.width, 0)
		} else {
			
		}
		
		// animation part
		UIView.animateWithDuration(duration, delay: 0, options: [], animations: { 
			if self.isPresenting {
				// presenting view enter from right to left
				presentingVC.view.transform = CGAffineTransformIdentity
				// main view move a bit to left
				mainVC.view.transform = CGAffineTransformMakeTranslation(-150, 0)
			} else {
				
				// get back main view
				mainVC.view.transform = CGAffineTransformIdentity
				// dismiss presenting view
				presentingVC.view.transform = CGAffineTransformMakeTranslation(presentingVC.view.bounds.width, 0)
			}
			}, completion: { (finished) in
				if transitionContext.transitionWasCancelled() {
					// transition was cancelled, not completing the transition
					transitionContext.completeTransition(false)
					// from view is still in presenting
					presentingVCSnapshot.removeFromSuperview()
					screen.from.view.transform = CGAffineTransformIdentity
					UIApplication.sharedApplication().keyWindow?.addSubview(screen.from.view)
					screen.from.view.show()
				} else {
					// transition completed
					transitionContext.completeTransition(true)
					screen.to.view.transform = CGAffineTransformIdentity
					UIApplication.sharedApplication().keyWindow?.addSubview(screen.to.view)
					screen.to.view.show()
				}
		})
		
	}
}