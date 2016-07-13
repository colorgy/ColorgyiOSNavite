//
//  MyPagePersonalInfoView.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

@objc public protocol MyPagePersonalInfoViewDelegate: class {
	optional func myPagePersonalInfoViewEditPersonalInforButtonClicked()
}

final public class MyPagePersonalInfoView: UIView {
	
	// MARK: - Parameters
	
	public var name: String? {
		didSet {
			updateName()
		}
	}
	
	/// Set this will update school.
	public var school: String? {
		didSet {
			updateSchool()
		}
	}
	
	/// Set this will automatically update greetings' count.
	public var greetings: Int? {
		didSet {
			updateGreetings()
		}
	}
	
	private var nameLabel: UILabel!
	private var schoolLabel: UILabel!
	private var greetingsIcon: UIImageView!
	private var greetingsCountLabel: UILabel!
	
	private var editPersonalInfoButton: UIButton!
	
	public weak var delegate: MyPagePersonalInfoViewDelegate?

	// MARK: - Init
	
	public convenience init(name: String?, school: String?, greetings: Int?) {
		self.init(frame: UIScreen.mainScreen().bounds)
		frame.size.height = 118.0
		
		backgroundColor = UIColor.whiteColor()
		
		// configure labels
		configureNameLabel()
		configureSchoolLabel()
		configureEditPersonalInfoButton()
		configureGreetings()
		
		// set values
		self.name = name
		self.school = school
		self.greetings = greetings
		updateName()
		updateSchool()
		updateGreetings()
	}
	
	override private init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureNameLabel() {
		let padding: CGFloat = 24
		nameLabel = UILabel(
			frame: CGRect(origin: CGPointZero,
			size: CGSize(width: bounds.width - padding * 2, height: 24)))
		nameLabel.font = UIFont.systemFontOfSize(24)
		nameLabel.textColor = ColorgyColor.TextColor
		
		nameLabel.frame.origin.x = padding
		nameLabel.frame.origin.y = 24
		
		addSubview(nameLabel)
	}
	
	private func configureSchoolLabel() {
		let padding: CGFloat = 24
		schoolLabel = UILabel(
			frame: CGRect(origin: CGPointZero,
				size: CGSize(width: bounds.width - padding * 2, height: 16)))
		schoolLabel.font = UIFont.systemFontOfSize(16)
		schoolLabel.textColor = ColorgyColor.TextColor
		
		schoolLabel.frame.origin.x = padding
		schoolLabel.move(12, pointBelow: nameLabel)
		
		addSubview(schoolLabel)
	}
	
	private func configureGreetings() {
		greetingsIcon = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 13, height: 13)))
		greetingsIcon.image = UIImage(named: "PersonalInfoGreetingsIcon")
		greetingsIcon.contentMode = .ScaleAspectFill
		
		greetingsIcon.frame.origin.x = 24
		greetingsIcon.move(12, pointBelow: schoolLabel)
		
		addSubview(greetingsIcon)
		
		greetingsCountLabel = UILabel()
		greetingsCountLabel.frame.size.height = 12
		greetingsCountLabel.font = UIFont.systemFontOfSize(12)
		greetingsCountLabel.textColor = ColorgyColor.MainOrange
		
		greetingsCountLabel.move(8, pointsRightTo: greetingsIcon)
		greetingsCountLabel.centerHorizontally(to: greetingsIcon)
		
		addSubview(greetingsCountLabel)
	}
	
	private func configureEditPersonalInfoButton() {
		editPersonalInfoButton = UIButton(type: UIButtonType.System)
		editPersonalInfoButton.frame.size = CGSize(width: 12, height: 12)
		editPersonalInfoButton.tintColor = ColorgyColor.TextColor
		editPersonalInfoButton.setImage(UIImage(named: "EditPersonalInfoButton"), forState: UIControlState.Normal)
		editPersonalInfoButton.contentMode = .ScaleAspectFill
		
		editPersonalInfoButton.frame.origin.y = 24
		editPersonalInfoButton.move(24, pointsTrailingToAndInside: self)
		
		editPersonalInfoButton.addTarget(self, action: #selector(MyPagePersonalInfoView.editPersonalInfoButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
		
		addSubview(editPersonalInfoButton)
	}
	
	// MARK: - Update UI
	private func updateName() {
		nameLabel.text = name
	}
	
	private func updateSchool() {
		schoolLabel.text = school
		schoolLabel.updateWidthToPreferredSizeByFontSize()
	}
	
	private func updateGreetings() {
		// Check if greetings is nil, if nil, set to 0
		// Then if its negative, set to 0
		let greetingsCount = max(greetings ?? 0, 0)
		let greetingsText = "\(greetingsCount)個招呼"
		greetingsCountLabel.text = greetingsText
		greetingsCountLabel.updateWidthToPreferredSizeByFontSize()
	}
	
	// MARK: - Selector
	@objc private func editPersonalInfoButtonClicked() {
		print(#file, #function, #line)
		delegate?.myPagePersonalInfoViewEditPersonalInforButtonClicked?()
	}
}
