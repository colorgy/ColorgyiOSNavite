//
//  PhoneDigitValidationField.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class PhoneDigitValidationField: UITextField {

	override public func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
		if gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer.self) {
			gestureRecognizer.enabled = false
		}
		super.addGestureRecognizer(gestureRecognizer)
		return
	}
	
	override public func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
		switch action {
		case #selector(UITextField.paste(_:)), #selector(UITextField.copy(_:)), #selector(UITextField.select(_:)), #selector(UITextField.selectAll(_:)):
			return false
		default:
			return true
		}
	}
	
	override public func caretRectForPosition(position: UITextPosition) -> CGRect {
		return CGRectZero
	}

}
