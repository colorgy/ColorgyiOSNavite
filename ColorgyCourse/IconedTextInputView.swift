//
//  IconedTextInputView.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol IconedTextInputViewDelegate: class {
	func iconedTextInputViewShouldReturn(textInputView: IconedTextInputView)
}
/// This view is used on register or login view
///
/// Display the text input view
public class IconedTextInputView: UIView {
	
	public var inputTextField: UITextField?
	public weak var delegate: IconedTextInputViewDelegate?
	
	init(imageName: String, placeholder: String?, keyboardType: UIKeyboardType, isPassword: Bool, delegate: IconedTextInputViewDelegate?) {
		
		super.init(frame: CGRectZero)
		
		frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 44)
		// Left icon image view
		let placeholderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
		// text field
		let inputTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 26))
		
		// configure _view
		backgroundColor = UIColor.whiteColor()
		
		// configure placeholder image _view
		placeholderImageView.image = UIImage(named: imageName)
		
		// configure text input _view
		inputTextField.placeholder = placeholder
		
		// No auto correction
		inputTextField.autocorrectionType = .No
		
		// arrange
		placeholderImageView.frame.origin.x = 36
		placeholderImageView.center.y = bounds.midY - 1
		
		let trailingSpace: CGFloat = 8.0
		let imageAndTextFieldGap: CGFloat = 12.0
		inputTextField.frame.size.width = UIScreen.mainScreen().bounds.width - imageAndTextFieldGap - placeholderImageView.frame.maxX - trailingSpace
		inputTextField.center.y = bounds.midY
		inputTextField.frame.origin.x = placeholderImageView.frame.maxX + imageAndTextFieldGap
		
		inputTextField.keyboardType = keyboardType
		inputTextField.secureTextEntry = isPassword
		
		// anchor _view
		inputTextField.anchorViewTo(self)
		placeholderImageView.anchorViewTo(self)
		
		// set public getter
		self.inputTextField = inputTextField
		
		inputTextField.delegate = self
		
		// assigning delegate
		self.delegate = delegate
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension IconedTextInputView : UITextFieldDelegate {
	public func textFieldShouldReturn(textField: UITextField) -> Bool {
		delegate?.iconedTextInputViewShouldReturn(self)
		return true
	}
}
