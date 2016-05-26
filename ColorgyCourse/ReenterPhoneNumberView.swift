//
//  ReenterPhoneNumberView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/26.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ReenterPhoneNumberView: UIView {

	private var titleLabel: UILabel!
	private var subtitleLabel: UILabel!
	private var phoneNumberTextField: PhoneNumberTextField!
	private var cancelButton: UIButton!
	private var confirmButton: UIButton!
	
	private var horizontalSeperatorLine: UIView!
	private var verticalSeperatorLine: UIView!
	
	private let titleFontSize: CGFloat = 18
	private let subtitleFontSize: CGFloat = 12
	
	public convenience init(title: String?, subtitle: String?) {
		self.init()
		configureViewSize()
		configureTitleLabel(title)
		configureSubtitleLabel(subtitle)
		configurePhoneNumberTextField()
		configureSeperatorLine()
	}
	
	// MARK: - Configration
	private func configureViewSize() {
		frame.size = CGSize(width: 272, height: 185)
		
		backgroundColor = UIColor.whiteColor()
		layer.cornerRadius = 13.0
	}
	
	private func configureTitleLabel(title: String?) {
		titleLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: bounds.width, height: titleFontSize + 2)))
		titleLabel.textAlignment = .Center
		titleLabel.font = UIFont.boldSystemFontOfSize(titleFontSize)
		titleLabel.textColor = ColorgyColor.TextColor
		titleLabel.clipsToBounds = false
		
		titleLabel.text = title
		titleLabel.center.y = 24 + titleFontSize / 2
		
		addSubview(titleLabel)
	}
	
	private func configureSubtitleLabel(subtitle: String?) {
		subtitleLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: bounds.width, height: subtitleFontSize + 2)))
		subtitleLabel.textAlignment = .Center
		subtitleLabel.font = UIFont.systemFontOfSize(subtitleFontSize)
		subtitleLabel.textColor = ColorgyColor.TextColor
		subtitleLabel.clipsToBounds = false
		
		subtitleLabel.text = subtitle
		subtitleLabel.center.y = titleLabel.frame.midY + titleFontSize / 2 + subtitleFontSize + subtitleFontSize / 2
		
		addSubview(subtitleLabel)
	}
	
	private func configurePhoneNumberTextField() {
		phoneNumberTextField = PhoneNumberTextField()
		phoneNumberTextField.frame.size = CGSize(width: bounds.width - 24 * 2, height: 38)
		phoneNumberTextField.frame.origin.x = 24
		phoneNumberTextField.frame.origin.y = subtitleLabel.frame.midY + subtitleFontSize + 10
		phoneNumberTextField.font = UIFont.systemFontOfSize(14)
		phoneNumberTextField.layer.cornerRadius = 3
		phoneNumberTextField.layer.borderColor = ColorgyColor.lightGrayContentTextColor.CGColor
		phoneNumberTextField.layer.borderWidth = 1.0
		phoneNumberTextField.placeholder = "輸入手機號碼"
		phoneNumberTextField.tintColor = ColorgyColor.MainOrange
		phoneNumberTextField.autocorrectionType = .No
		phoneNumberTextField.autocapitalizationType = .None
		phoneNumberTextField.keyboardType = .NumberPad
		
		addSubview(phoneNumberTextField)
	}
	
	private func configureSeperatorLine() {
		horizontalSeperatorLine = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: bounds.width, height: 1)))
		horizontalSeperatorLine.backgroundColor = ColorgyColor.TextColor
		horizontalSeperatorLine.frame.origin.y = phoneNumberTextField.frame.maxY + 24
		
		addSubview(horizontalSeperatorLine)
		
		verticalSeperatorLine = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 0.5, height: 40)))
		verticalSeperatorLine.backgroundColor = ColorgyColor.lightGrayContentTextColor
		verticalSeperatorLine.frame.origin.y = horizontalSeperatorLine.frame.maxY + 1
		verticalSeperatorLine.center.x = bounds.midX
		
		addSubview(verticalSeperatorLine)
	}
	
	private func configureCancelButton() {
		
	}
	
	private func configureConfirmButton() {
		
	}
}
