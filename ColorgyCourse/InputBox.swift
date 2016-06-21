//
//  InputBox.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol InputBoxDelegate: class {
	func inputBoxEditingChanged(inputbox: InputBox, text: String?)
}

public protocol InputBoxUpdatingDelegate: class {
	func inputBoxUpdated(inputbox: InputBox, text: String?)
}

public class InputBox: UIView {
	
	public private(set) var iconImageView: UIImageView!
	public private(set) var textfield: UITextField!
	public private(set) var indicator: UIImageView!
	private var okIndicatorImage: UIImage?
	private var errorIndicatorImage: UIImage?
	
	public weak var inputBoxDelegate: InputBoxDelegate?
	public weak var inputBoxUpdatingDelegate: InputBoxUpdatingDelegate?

	// MARK: - Init
	public init(imageName: String, placeholder: String?, isPassword: Bool, keyboardType: UIKeyboardType) {
		super.init(frame: UIScreen.mainScreen().bounds)
		frame.size.height = 44
		backgroundColor = UIColor.whiteColor()
		configureIndicatorImages()
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
		
		textfield.tintColor = ColorgyColor.MainOrange
		
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
		indicator.contentMode = .ScaleAspectFit
		
		addSubview(indicator)
	}
	
	private func configureIndicatorImages() {
		okIndicatorImage = UIImage(named: "OKIndicator")
		errorIndicatorImage = UIImage(named: "ErrorIndicator")
	}

	// MARK: - Methods
	@objc private func textfieldEditingChange() {
		inputBoxDelegate?.inputBoxEditingChanged(self, text: textfield.text)
		inputBoxUpdatingDelegate?.inputBoxUpdated(self, text: textfield.text)
	}
	
	public func showOKIndicator() {
		changeIndicatorImage(okIndicatorImage)
	}
	
	public func showErrorIndicator() {
		changeIndicatorImage(errorIndicatorImage)
	}
	
	private func changeIndicatorImage(image: UIImage?) {
		if indicator.image != image {
			UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [], animations: {
				self.indicator.image = image
				self.indicator.transform = CGAffineTransformMakeScale(1.2, 1.2)
				}, completion: { _ in
					UIView.animateWithDuration(0.1, animations: {
						self.indicator.transform = CGAffineTransformIdentity
					})
			})
		}
	}
	
	public func invalidateIndicator() {
		indicator.hide()
	}
	
	public func validateIndicator() {
		indicator.show()
	}
}
