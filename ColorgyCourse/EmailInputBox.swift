//
//  EmailInputBox.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class EmailInputBox: InputBox {

	public init() {
		super.init(imageName: "EmailIcon", placeholder: "信箱", isPassword: false, keyboardType: UIKeyboardType.EmailAddress)
		self.inputBoxDelegate = self
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Validator
	private func isValidEmail(email: String?) -> Bool {
		if let email = email where email.isValidEmail {
			return true
		}
		return false
	}
	
	private func updateIndicatorWithValidEmail(isValid: Bool) {
		if isValid {
			showOKIndicator()
		} else {
			showErrorIndicator()
		}
	}
}

extension EmailInputBox : InputBoxDelegate {
	public func inputBoxEditingChanged(text: String?) {
		updateIndicatorWithValidEmail(isValidEmail(text))
	}
}