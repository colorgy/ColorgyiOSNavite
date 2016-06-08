//
//  ChooseSchoolSearchBar.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/8.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ChooseSchoolSearchBar: UIView {

	private var searchIcon: UIImageView!
	private var searchTextField: UITextField!
	private var cancelButton: UIButton!
	private var centerY: CGFloat {
		get {
			return (bounds.height - 20.0) / 2 + 20
		}
	}
	
	public init() {
		super.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 64)))
		configureSearchIcon()
		configureCancelButton()
		configureSearchTextField()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureSearchIcon() {
		searchIcon = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 20, height: 20)))
		searchIcon.image = UIImage(named: "OrangeSearchButton")
		
		searchIcon.contentMode = .ScaleAspectFit
		
		searchIcon.frame.origin.x = 16
		searchIcon.center.y = centerY
		
		addSubview(searchIcon)
	}
	
	private func configureSearchTextField() {
		searchTextField = UITextField()
		searchTextField.frame.size.width = UIScreen.mainScreen().bounds.width - cancelButton.bounds.width - searchIcon.bounds.width - 4 * 16
		searchTextField.frame.size.height = 25
		searchTextField.font = UIFont.systemFontOfSize(15)
		searchTextField.placeholder = "輸入學校名稱"
		searchTextField.tintColor = ColorgyColor.MainOrange
		
		searchTextField.frame.origin.x = searchIcon.frame.maxX + 20
		searchTextField.center.y = centerY
		
		addSubview(searchTextField)
	}
	
	private func configureCancelButton() {
		cancelButton = UIButton(type: UIButtonType.System)
		cancelButton.tintColor = ColorgyColor.MainOrange
		cancelButton.setTitle("取消", forState: UIControlState.Normal)
		cancelButton.setTitleColor(ColorgyColor.MainOrange, forState: UIControlState.Normal)
		cancelButton.titleLabel?.font = UIFont.systemFontOfSize(16)
		cancelButton.sizeToFit()
		
		cancelButton.frame.origin.x = UIScreen.mainScreen().bounds.width - cancelButton.bounds.width - 16
		cancelButton.center.y = centerY
		
		addSubview(cancelButton)
	}
}
