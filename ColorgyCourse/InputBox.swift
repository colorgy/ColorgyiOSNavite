//
//  InputBox.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol InputBoxDelegate: class {
	func inputBoxEditingChanged(text: String?)
}

public class InputBox: UIView {
	
	public private(set) var iconImageView: UIImageView!
	public private(set) var textfield: UITextField!
	public private(set) var indicator: UIImageView!
	
	public weak var inputBoxDelegate: InputBoxDelegate?

	// MARK: - Init
	public init(imageName: String, placeholder: String?, isPassword: Bool, keyboardType: UIKeyboardType) {
		super.init(frame: UIScreen.mainScreen().bounds)
		frame.size.height = 44
		backgroundColor = UIColor.whiteColor()
		configureIconImageView(imageName)
		configureIndicator()
		configureTextField(placeholder, isPassword: isPassword, keyboardType: keyboardType)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureIconImageView(imageName: String) {
		iconImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 18.0, height: 18.0)))
		iconImageView.frame.origin.x = 32
		iconImageView.center.y = bounds.midY
		
		iconImageView.image = UIImage(named: imageName)
		iconImageView.contentMode = .ScaleAspectFit
		
		addSubview(iconImageView)
	}
	
	private func configureTextField(placeholder: String?, isPassword: Bool, keyboardType: UIKeyboardType) {
		textfield = UITextField()
		textfield.frame.size.height = 21
		textfield.font = UIFont.systemFontOfSize(14)
		textfield.center.y = bounds.midY
		textfield.frame.origin.x = iconImageView.frame.maxX + 21
		textfield.frame.size.width = bounds.width - iconImageView.frame.maxX - 21 - iconImageView.bounds.width - 16 - 8
		
		textfield.keyboardType = keyboardType
		textfield.placeholder = placeholder
		textfield.secureTextEntry = isPassword
		
		textfield.autocorrectionType = .No
		textfield.autocapitalizationType = .None
		
		addSubview(textfield)
		
		textfield.addTarget(self, action: #selector(InputBox.textfieldEditingChange), forControlEvents: UIControlEvents.EditingChanged)
	}
	
	private func configureIndicator() {
		indicator = UIImageView()
		indicator.frame.size = CGSize(width: 21, height: 21)
		indicator.frame.origin.x = bounds.width - indicator.bounds.width - 16
		indicator.center.y = bounds.midY
		
		indicator.image = UIImage(named: "EmailIcon")
		
		addSubview(indicator)
	}

	// MARK: - Methods
	@objc private func textfieldEditingChange() {
		inputBoxDelegate?.inputBoxEditingChanged(textfield.text)
	}
}
