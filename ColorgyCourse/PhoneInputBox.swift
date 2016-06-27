//
//  PhoneInputBox.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

final public class PhoneInputBox: InputBox {
	
	public init() {
		super.init(imageName: "PhoneIcon", placeholder: "手機（傳送驗證碼）", isPassword: false, keyboardType: UIKeyboardType.NumberPad)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Validator
	private func isValidPhone(phone: String?) -> Bool {
		if let phone = phone where phone.isValidMobileNumber {
			return true
		}
		return false
	}
	
	private func updateIndicatorWithValidPhone(isValid: Bool) {
		isValid ? showOKIndicator() : showErrorIndicator()
	}
	
	// MARK: - Overriding
	override func inputBoxEdtingChanged(text: String?) {
		updateIndicatorWithValidPhone(isValidPhone(text))
	}
}