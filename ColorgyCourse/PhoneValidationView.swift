//
//  PhoneValidationView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class PhoneValidationView: UIView {
	
	private var titleLabel: UILabel!
	private var subtitleLabel: UILabel!
	
	private var digit1: UILabel!
	private var digit2: UILabel!
	private var digit3: UILabel!
	private var digit4: UILabel!
	private var digits: [UILabel]!
	
	private var hiddenDigitTextField: UITextField!

	public init() {
		super.init(frame: CGRect(origin: CGPointZero, size: CGSizeZero))
		frame.size.width = UIScreen.mainScreen().bounds.width
		frame.size.height = 182.0
		
		configureDigits()
		configureHiddenDigitTextField()
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureDigits() {
		digits = [digit1, digit2, digit3, digit4]
		print(digits)
		let digitSize: CGFloat = 40.0
		digit1 = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: digitSize, height: digitSize)))
		digit2 = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: digitSize, height: digitSize)))
		digit3 = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: digitSize, height: digitSize)))
		digit4 = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: digitSize, height: digitSize)))
		print(digits)
		let digitSpacing: CGFloat = 8
		let initialX: CGFloat = (bounds.width - (digitSpacing * 3 + digitSize * 4)) / 2
		for (index, digit) in digits.enumerate() {
			digit.font = UIFont.systemFontOfSize(40)
			digit.textColor = ColorgyColor.waterBlue
			digit.textAlignment = .Center
			digit.frame.origin.x = initialX + index.CGFloatValue * (digitSpacing + digitSize)
			digit.frame.origin.y = 50
			addSubview(digit)
		}
	}
	
	private func configureHiddenDigitTextField() {
		hiddenDigitTextField = UITextField(frame: CGRect(origin: CGPointZero, size: CGSizeZero))
		hiddenDigitTextField.userInteractionEnabled = false
		
		hiddenDigitTextField.addTarget(self, action: #selector(PhoneValidationView.hiddenDigitTextFieldEditingChanged), forControlEvents: UIControlEvents.EditingChanged)
		
		addSubview(hiddenDigitTextField)
	}
	
	// MARK: - Methods
	@objc private func hiddenDigitTextFieldEditingChanged() {
		print(hiddenDigitTextField.text)
	}
}
