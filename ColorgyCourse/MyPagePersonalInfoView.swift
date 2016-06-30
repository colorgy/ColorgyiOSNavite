//
//  MyPagePersonalInfoView.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class MyPagePersonalInfoView: UIView {
	
	// MARK: - Parameters
	
	public var name: String? {
		didSet {
			updateName()
		}
	}
	
	public var school: String? {
		didSet {
			updateSchool()
		}
	}
	
	private var nameLabel: UILabel!
	private var schoolLabel: UILabel!

	// MARK: - Init
	
	public convenience init(name: String?, school: String?) {
		self.init(frame: UIScreen.mainScreen().bounds)
		frame.size.height = 90.0
		
		backgroundColor = UIColor.whiteColor()
		
		// configure labels
		configureNameLabel()
		configureSchoolLabel()
		
		// set values
		self.name = name
		self.school = school
		updateName()
		updateSchool()
	}
	
	override private init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureNameLabel() {
		let padding: CGFloat = 28
		nameLabel = UILabel(
			frame: CGRect(origin: CGPointZero,
			size: CGSize(width: bounds.width - padding * 2, height: 20)))
		nameLabel.font = UIFont.systemFontOfSize(20)
		nameLabel.textColor = ColorgyColor.TextColor
		
		nameLabel.frame.origin.x = padding
		nameLabel.frame.origin.y = 24
		
		addSubview(nameLabel)
	}
	
	private func configureSchoolLabel() {
		let padding: CGFloat = 28
		schoolLabel = UILabel(
			frame: CGRect(origin: CGPointZero,
				size: CGSize(width: bounds.width - padding * 2, height: 16)))
		schoolLabel.font = UIFont.systemFontOfSize(16)
		schoolLabel.textColor = ColorgyColor.TextColor
		
		schoolLabel.frame.origin.x = padding
		schoolLabel.move(10, pointBelow: nameLabel)
		
		addSubview(schoolLabel)
	}
	
	// MARK: - Update UI
	private func updateName() {
		nameLabel.text = name
	}
	
	private func updateSchool() {
		schoolLabel.text = school
		print("about to configure school label, calculate length...")
		print("frame length is \(schoolLabel.frame.width)")
		print("length after calculate: \()")
		
		schoolLabel.preferredTextWidthConstraintByFontSize(<#T##size: CGFloat##CGFloat#>)
	}
}
