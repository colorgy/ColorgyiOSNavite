//
//  ConfirmPasswordInputBox.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

final public class ConfirmPasswordInputBox: InputBox {
	
	private var passwordInputBox: PasswordInputBox? {
		didSet {
			setDelegate()
		}
	}
	
	public init() {
		super.init(imageName: "PasswordIcon", placeholder: "確認密碼", isPassword: true, keyboardType: UIKeyboardType.Default)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Validator
	private func isValidPassword(password: String?) -> Bool {
		if let password = password where password.characters.count >= 8 {
			return confirmTwoPassword()
		}
		return false
	}
	
	private func confirmTwoPassword() -> Bool {
		if passwordInputBox?.password == password {
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
	
	// MARK: - Handle password delegate
	private func setDelegate() {
		passwordInputBox?.delegate = self
	}
	
	public func bindPasswordInputBox(inputbox: PasswordInputBox) {
		passwordInputBox = inputbox
	}
	
	// MARK: - Overriding
	override func inputBoxEdtingChanged(text: String?) {
		updateIndicatorWithValidPassword(isValidPassword(text))
	}
}

extension ConfirmPasswordInputBox : PasswordInputBoxDelegate {
	public func passwordInputBox(passwordUpdated password: String?) {
		updateIndicatorWithValidPassword(isValidPassword(password))
	}
}