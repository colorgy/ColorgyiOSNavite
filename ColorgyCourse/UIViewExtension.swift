//
//  UIViewExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

extension UIView {
	
	/// Can anchor self to a view
	///
	/// A reverse thought of adding a subview
	func anchorViewTo(view: UIView?) {
		view?.addSubview(self)
	}
	
	/// Hide view
	func hide() {
		self.hidden = true
	}
	
	/// Show view
	func show() {
		self.hidden = false
	}
	
	/// Show border 
	func showBorder() {
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor.greenColor().CGColor
	}
	
	/// To check if cgpoint is inside the view
	func containsPoint(point: CGPoint) -> Bool {
		return CGRectContainsPoint(self.bounds, point)
	}
	
	/// Make a view center horizontally to superview.
	///
	/// Only works if the view has a superview
	func centerHorizontallyToSuperview() {
		if let superview = self.superview {
			self.center.x = superview.bounds.midX
		}
	}
	
	/// Get bounds' center x.
	/// Its different from center.x, because center.x is according to frame
	var centerXOfBounds: CGFloat {
		return bounds.midX
	}
	
	/// Move below given point and view
	func move(point: CGFloat, pointBelow view: UIView) {
		self.frame.origin.y = point.point(below: view)
	}
	
	/// Center x to given view
	func centerX(to view: UIView) {
		self.center.x = view.bounds.midX
	}
	
	/// Move view in view to its right
	/// This is used when you want to arrange a view to the right side inside the view.
	func move(point: CGFloat, pointsTrailingToAndInside view: UIView) {
		self.frame.origin.x = view.bounds.width - self.bounds.width - point
	}
	
	/// Move view in view's right
	/// This is used to move to a view's right, not inside the view.
	func move(point: CGFloat, pointsRightTo view: UIView) {
		self.frame.origin.x = view.frame.maxX + point
	}
	
	/// Center horizontally to a view
	func centerHorizontally(to view: UIView) {
		self.center.y = view.center.y
	}
}