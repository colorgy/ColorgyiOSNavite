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
}