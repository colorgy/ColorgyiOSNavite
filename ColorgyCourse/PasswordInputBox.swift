//
//  PasswordInputBox.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

public protocol PasswordInputBoxDelegate: class {
	func passwordInputBox(passwordUpdated password: String?)
}

final public class PasswordInputBox: InputBox {
	
	public weak var delegate: PasswordInputBoxDelegate?
	
	public init() {
		super.init(imageName: "PasswordIcon", placeholder: "密碼（8個字以上）", isPassword: true, keyboardType: UIKeyboardType.Default)
		self.inputBoxDelegate = self
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Validator
	private func isValidPassword(password: String?) -> Bool {
		if let password = password where password.characters.count >= 8 {
			return true
		}
		return false
	}
	
	private func updateIndicatorWithValidPassword(isValid: Bool) {
		isValid ? showOKIndicator() : showErrorIndicator()
	}
	
	// MARK: - Getter
	public var password: String? {
		return textfield.text
	}
}

extension PasswordInputBox : InputBoxDelegate {
	public func inputBoxEditingChanged(inputbox: InputBox, text: String?) {
		updateIndicatorWithValidPassword(isValidPassword(text))
		delegate?.passwordInputBox(passwordUpdated: text)
	}
}