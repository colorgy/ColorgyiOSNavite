//
//  ColorgyNavigationBar.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

@objc public protocol ColorgyNavigationBarDelegate: class {
	optional func colorgyNavigationBarBackButtonClicked()
	optional func colorgyNavigationBarCrossButtonClicked()
	optional func colorgyNavigationBarCheckButtonClicked()
	optional func colorgyNavigationBarAdjustingButtonClicked()
}

/// This is customized navigation bar for colorgy.
public class ColorgyNavigationBar: UIView {
	
	// MARK: - Parameters
	private var titleLabel: UILabel!
	public var title: String? {
		didSet {
			titleLabel?.text = title
			titleLabel?.sizeToFit()
			centerLabel()
		}
	}
	private var centerY: CGFloat {
		get {
			return (bounds.height - 20) / 2 + 20
		}
	}
	public weak var delegate: ColorgyNavigationBarDelegate?
	
	// MARK: - Buttons
	private var leftButton: UIButton!
	private var rightButton: UIButton!

	// MARK: - Init
	public init() {
		super.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 64)))
		backgroundColor = UIColor.whiteColor()
		configureTitleLabel()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureTitleLabel() {
		titleLabel = UILabel()
		titleLabel.frame.size.height = 21
		titleLabel.font = UIFont.boldSystemFontOfSize(17)
		titleLabel.textAlignment = .Center
		titleLabel.frame.size.width = 0.6 * bounds.width
		titleLabel.sizeToFit()
		
		centerLabel()
		
		addSubview(titleLabel)
	}
	
	private func centerLabel() {
		titleLabel.center.x = bounds.midX
		titleLabel.center.y = centerY
	}

	// MARK: - Configure Buttons
	public func iWantACrossButtonAtLeft() {
		configureLeftButtonWithImage("OrangeCrossButton")
		leftButton.addTarget(self, action: #selector(ColorgyNavigationBar.crossButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	public func iWantABackButtonAtLeft() {
		configureLeftButtonWithImage("OrangeBackButton")
		leftButton.addTarget(self, action: #selector(ColorgyNavigationBar.backButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	public func iWantACheckButtonAtRight() {
		configureRightButtonWithImage("OrangeCheckButton")
		rightButton.addTarget(self, action: #selector(ColorgyNavigationBar.checkButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	public func iWantAAdjusttingButtonAtRight() {
		configureRightButtonWithImage("OrangeAdjustingButton")
		rightButton.addTarget(self, action: #selector(ColorgyNavigationBar.adjustingButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	// MARK: - Configuration
	
	private func configureLeftButtonWithImage(name: String) {
		leftButton = configureBarButton(name)
		
		leftButton.frame.origin.x = 16
		leftButton.center.y = centerY
		
		addSubview(leftButton)
		
		leftButton.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
	}
	
	private func configureRightButtonWithImage(name: String) {
		rightButton = configureBarButton(name)
		
		rightButton.frame.origin.x = bounds.width - rightButton.bounds.width - 16
		rightButton.center.y = centerY
		
		addSubview(rightButton)
		
		rightButton.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
	}
	
	private func configureBarButton(name: String) -> UIButton {
		let button = UIButton(type: UIButtonType.System)
		button.setImage(UIImage(named: name), forState: UIControlState.Normal)
		button.contentMode = .ScaleAspectFill
		button.tintColor = ColorgyColor.MainOrange
		
		button.frame.size.height = 20
		button.frame.size.width = 20
		button.sizeToFit()
		
		return button
	}
	
	// MARK: - Button Methods
	@objc private func crossButtonClicked() {
		delegate?.colorgyNavigationBarCrossButtonClicked?()
	}
	
	@objc private func checkButtonClicked() {
		delegate?.colorgyNavigationBarCheckButtonClicked?()
	}
	
	@objc private func backButtonClicked() {
		delegate?.colorgyNavigationBarBackButtonClicked?()
	}
	
	@objc private func adjustingButtonClicked() {
		delegate?.colorgyNavigationBarAdjustingButtonClicked?()
	}
}
