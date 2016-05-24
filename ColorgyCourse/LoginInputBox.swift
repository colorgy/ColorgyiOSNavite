//
//  LoginInputBox.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class LoginInputBox: InputBox {

	public init() {
		super.init(imageName: "EmailIcon", placeholder: "信箱", isPassword: false, keyboardType: UIKeyboardType.Default)
		self.inputBoxDelegate = self
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


extension LoginInputBox : InputBoxDelegate {
	public func inputBoxEditingChanged(text: String?) {
		print(text)
	}
}