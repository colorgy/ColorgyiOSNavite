//
//  PhoneValidationView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol PhoneValidationViewDelegate: class {
	func phoneValidationViewRequestResendValidationCode()
	func phoneValidationViewRequestReenterPhoneNumber()
}

final public class PhoneValidationView: UIView {
	
	private var titleLabel: UILabel!
	private var subtitleLabel: UILabel!
	
	private var digit1: UILabel!
	private var digit2: UILabel!
	private var digit3: UILabel!
	private var digit4: UILabel!
	private var digits: [UILabel] = []
	
	private var hiddenDigitTextField: UITextField!
	
	private var resendValidationCodeLabel: UILabel!
	private var reenterPhoneLabel: UILabel!
	private var middleSeperatorSlashLabel: UILabel!
	
	public weak var delegate: PhoneValidationViewDelegate?
	public var validationCode: String? {
		get {
			var code = ""
			digits.forEach({ code += $0.text ?? "" })
			return code
		}
	}
	public var targetPhoneNumber: String? {
		didSet {
			updateTargetPhoneNumber()
		}
	}

	public init(delegate: PhoneValidationViewDelegate?) {
		super.init(frame: CGRect(origin: CGPointZero, size: CGSizeZero))
		frame.size.width = UIScreen.mainScreen().bounds.width
		frame.size.height = 182.0
		backgroundColor = UIColor.whiteColor()
		
		self.delegate = delegate
		
		configureTitle()
		configureSubtitle()
		configureDigits()
		configureHiddenDigitTextField()
		configureResendValidationCodeLabel()
		configureReenterPhoneLabel()
		configureMiddleSeperatorSlashLabel()
		arrangeUnderlinedLabels()
		
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
			digit.frame.origin.y = subtitleLabel.frame.maxY + 20
			
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
	
	private func configureTitle() {
		titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 24), size: CGSize(width: bounds.width, height: 18)))
		titleLabel.font = UIFont.systemFontOfSize(18)
		titleLabel.textColor = ColorgyColor.TextColor
		titleLabel.textAlignment = .Center
		titleLabel.text = "請輸入驗證碼"
		
		addSubview(titleLabel)
	}
	
	private func configureSubtitle() {
		subtitleLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: bounds.width, height: 13)))
		subtitleLabel.frame.origin.y = titleLabel.frame.maxY + 6
		subtitleLabel.font = UIFont.systemFontOfSize(13)
		subtitleLabel.textColor = ColorgyColor.TextColor
		subtitleLabel.textAlignment = .Center
		
		addSubview(subtitleLabel)
	}
	
	private func configureResendValidationCodeLabel() {
		resendValidationCodeLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: 14 * 7, height: 14)))
		resendValidationCodeLabel.font = UIFont.systemFontOfSize(14)
		resendValidationCodeLabel.textColor = ColorgyColor.lightGrayContentTextColor
		resendValidationCodeLabel.textAlignment = .Center
		resendValidationCodeLabel.text = "重新發送驗證碼"
		resendValidationCodeLabel.frame.origin.y = digit1.frame.maxY + 24
		
		let line = digitBottomLine(resendValidationCodeLabel.bounds.width)
		line.backgroundColor = resendValidationCodeLabel.textColor
		line.frame.origin.y = resendValidationCodeLabel.bounds.height - line.bounds.height
		resendValidationCodeLabel.addSubview(line)
		
		resendValidationCodeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PhoneValidationView.resendValidationCodeLabelTapped)))
		
		addSubview(resendValidationCodeLabel)
	}
	
	private func configureReenterPhoneLabel() {
		reenterPhoneLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: 14 * 6, height: 14)))
		reenterPhoneLabel.font = UIFont.systemFontOfSize(14)
		reenterPhoneLabel.textColor = ColorgyColor.lightGrayContentTextColor
		reenterPhoneLabel.textAlignment = .Center
		reenterPhoneLabel.text = "重新輸入手機"
		reenterPhoneLabel.frame.origin.y = digit1.frame.maxY + 24
		
		let line = digitBottomLine(reenterPhoneLabel.bounds.width)
		line.backgroundColor = reenterPhoneLabel.textColor
		line.frame.origin.y = reenterPhoneLabel.bounds.height - line.bounds.height
		reenterPhoneLabel.addSubview(line)
		
		reenterPhoneLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PhoneValidationView.reenterPhoneNumberLabelTapped)))
		
		addSubview(reenterPhoneLabel)
	}
	
	private func configureMiddleSeperatorSlashLabel() {
		middleSeperatorSlashLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: 14, height: 14)))
		middleSeperatorSlashLabel.font = UIFont.systemFontOfSize(14)
		middleSeperatorSlashLabel.textColor = ColorgyColor.lightGrayContentTextColor
		middleSeperatorSlashLabel.textAlignment = .Center
		middleSeperatorSlashLabel.text = "／"
		middleSeperatorSlashLabel.frame.origin.y = digit1.frame.maxY + 24

		addSubview(middleSeperatorSlashLabel)
	}
	
	private func arrangeUnderlinedLabels() {
		let initialX = (bounds.width - (resendValidationCodeLabel.bounds.width + reenterPhoneLabel.bounds.width + middleSeperatorSlashLabel.bounds.width)) / 2
		
		resendValidationCodeLabel.frame.origin.x = initialX
		middleSeperatorSlashLabel.frame.origin.x = resendValidationCodeLabel.frame.maxX
		reenterPhoneLabel.frame.origin.x = middleSeperatorSlashLabel.frame.maxX
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
	
	private func updateTargetPhoneNumber() {
		subtitleLabel.text = "已發送簡訊至 " + (targetPhoneNumber ?? "")
	}
	
	@objc private func resendValidationCodeLabelTapped() {
		delegate?.phoneValidationViewRequestResendValidationCode()
	}
	
	@objc private func reenterPhoneNumberLabelTapped() {
		delegate?.phoneValidationViewRequestReenterPhoneNumber()
	}
}
