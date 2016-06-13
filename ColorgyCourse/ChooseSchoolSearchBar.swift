//
//  ChooseSchoolSearchBar.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/8.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol ChooseSchoolSearchBarDelegate: class {
	func chooseSchoolSearchBarUpdateSearchText(text: String?)
	func chooseSchoolSearchBarCancelSearching()
}

final public class ChooseSchoolSearchBar: UIView {

	private var searchIcon: UIImageView!
	private var searchTextField: UITextField!
	private var cancelButton: UIButton!
	private var centerY: CGFloat {
		get {
			return (bounds.height - 20.0) / 2 + 20
		}
	}
	public private(set) var isSearching: Bool = false
	public weak var delegate: ChooseSchoolSearchBarDelegate?
	
	public init(delegate: ChooseSchoolSearchBarDelegate?) {
		super.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 64)))
		configureSearchIcon()
		configureCancelButton()
		configureSearchTextField()
		offSearchStage()
		self.delegate = delegate
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
		
		searchIcon.userInteractionEnabled = true
		searchIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChooseSchoolSearchBar.searchIconTapped)))
		
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
		
		searchTextField.addTarget(self, action: #selector(ChooseSchoolSearchBar.searchTextFieldEditingChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
		
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
		
		cancelButton.addTarget(self, action: #selector(ChooseSchoolSearchBar.cancelButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
		
		addSubview(cancelButton)
	}
	
	// MARK: - Searching state
	private func onSearchStage() {
		isSearching = true
		self.cancelButton.show()
		self.searchTextField.show()
		self.cancelButton.alpha = 0
		self.searchTextField.alpha = 0
		UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
			self.backgroundColor = UIColor.whiteColor()
			self.cancelButton.alpha = 1
			self.searchTextField.alpha = 1
			}, completion: { (finished) in
				self.searchTextField.becomeFirstResponder()
		})
	}
	
	private func offSearchStage() {
		isSearching = false
		self.cancelButton.alpha = 1
		self.searchTextField.alpha = 1
		self.searchTextField.resignFirstResponder()
		UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
			self.backgroundColor = UIColor.clearColor()
			self.cancelButton.alpha = 0
			self.searchTextField.alpha = 0
			}, completion: { (finished) in
				self.cancelButton.hide()
				self.searchTextField.hide()
		})
	}
	
	// MARK: - Gesture
	@objc private func searchIconTapped() {
		if !isSearching {
			onSearchStage()
		}
	}
	
	// MARK: - TextField Editing Changed
	@objc private func searchTextFieldEditingChanged(textField: UITextField) {
		delegate?.chooseSchoolSearchBarUpdateSearchText(textField.text)
	}
	
	// MARK: - Methods
	public func cancelSearching() {
		offSearchStage()
	}
	
	@objc private func cancelButtonClicked() {
		delegate?.chooseSchoolSearchBarCancelSearching()
		offSearchStage()
	}
}
