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
	private var digits: [UILabel] = []
	
	private var hiddenDigitTextField: UITextField!

	public init() {
		super.init(frame: CGRect(origin: CGPointZero, size: CGSizeZero))
		frame.size.width = UIScreen.mainScreen().bounds.width
		frame.size.height = 182.0
		
		configureDigits()
		configureHiddenDigitTextField()
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PhoneValidationView.validationViewTapped)))
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureDigits() {
		
		let digitSize: CGFloat = 40.0
		digit1 = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: digitSize, height: digitSize)))
		digit2 = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: digitSize, height: digitSize)))
		digit3 = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: digitSize, height: digitSize)))
		digit4 = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: digitSize, height: digitSize)))
		digits = [digit1, digit2, digit3, digit4]
		
		let digitSpacing: CGFloat = 8
		let initialX: CGFloat = (bounds.width - (digitSpacing * 3 + digitSize * 4)) / 2
		for (index, digit) in digits.enumerate() {
			digit.font = UIFont.systemFontOfSize(40)
			digit.textColor = ColorgyColor.waterBlue
			digit.textAlignment = .Center
			digit.frame.origin.x = initialX + index.CGFloatValue * (digitSpacing + digitSize)
			digit.frame.origin.y = 50
			
			let line = digitBottomLine(digit.bounds.width)
			line.frame.origin.y = digit.bounds.maxY - line.bounds.height
			digit.addSubview(line)
			
			addSubview(digit)
		}
	}
	
	private func digitBottomLine(width: CGFloat) -> UIView {
		let line = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: width, height: 1)))
		line.backgroundColor = ColorgyColor.TextColor
		return line
	}
	
	private func configureHiddenDigitTextField() {
		hiddenDigitTextField = UITextField(frame: CGRect(origin: CGPointZero, size: CGSizeZero))

		hiddenDigitTextField.autocorrectionType = .No
		hiddenDigitTextField.autocapitalizationType = .None
		hiddenDigitTextField.keyboardType = .NumberPad
		
		hiddenDigitTextField.addTarget(self, action: #selector(PhoneValidationView.hiddenDigitTextFieldEditingChanged), forControlEvents: UIControlEvents.EditingChanged)
		
		addSubview(hiddenDigitTextField)
	}
	
	// MARK: - Methods
	@objc private func hiddenDigitTextFieldEditingChanged() {
		updateDigits(hiddenDigitTextField.text)
	}

	@objc private func validationViewTapped(gesture: UITapGestureRecognizer) {
		let digitsRect = CGRect(origin: digit1.frame.origin, size: CGSize(width: digit4.frame.maxX - digit1.frame.minX, height: digit1.bounds.height))
		let location = gesture.locationInView(self)
		CGRectContainsPoint(digitsRect, location) ? showKeyboard() : hideKeyboard()
	}
	
	private func showKeyboard() {
		hiddenDigitTextField.becomeFirstResponder()
	}
	
	private func hideKeyboard() {
		hiddenDigitTextField.resignFirstResponder()
		syncDigitLabelText()
	}
	
	private func updateDigits(text: String?) {
		guard let digitText = text else { return }
		4.times({ self.digits[$0].text = digitText.charaterAtIndex($0) ?? "" })
		if digitText.characters.count >= 4 {
			hideKeyboard()
		}
	}
	
	private func syncDigitLabelText() {
		var text = ""
		digits.forEach({ text += $0.text ?? "" })
		hiddenDigitTextField.text = text
	}
}
