//
//  SearchEventBar.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/17.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol SearchEventBarDelegate: class {
	func searchEventBar(didUpdateSearchText text: String?)
}

final public class SearchEventBar: UIView {

	private var searchBarTitleLabel: UILabel!
	private var searchBarBackButton: UIButton!
	private var searchButton: UIButton!
	private var searchCancelButton: UIButton!
	private var searchField: UITextField!
	
	public private(set) var isSearching: Bool = false
	
	public weak var delegate: SearchEventBarDelegate?
	
	public init(frame: CGRect, delegate: SearchEventBarDelegate?) {
		super.init(frame: frame)
		
		self.delegate = delegate
		
		backgroundColor = UIColor.whiteColor()
		
		configureSearchBarTitleLabel()
		configureSearchBarBackButton()
		configureSearchButton()
		configureSearchCancelButton()
		configureSearchField()
		
		searchCancelButton.hide()
		searchField.hide()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureSearchBarTitleLabel() {
		searchBarTitleLabel = UILabel()
		searchBarTitleLabel.text = "事件列表"
		searchBarTitleLabel.font = UIFont.boldSystemFontOfSize(17)
		searchBarTitleLabel.textAlignment = .Center
		searchBarTitleLabel.bounds.size.width = 300
		searchBarTitleLabel.textColor = UIColor.blackColor()
		searchBarTitleLabel.sizeToFit()
		
		addSubview(searchBarTitleLabel)
		
		searchBarTitleLabel.center.x = bounds.midX
		searchBarTitleLabel.frame.origin.y = 31
	}
	
	private func configureSearchBarBackButton() {
		searchBarBackButton = UIButton(type: UIButtonType.System)
		searchBarBackButton.bounds.size.width = 12
		searchBarBackButton.bounds.size.height = 20
		searchBarBackButton.setImage(UIImage(named: "OrangeBackButton"), forState: UIControlState.Normal)
		searchBarBackButton.addTarget(self, action: #selector(SearchEventBar.backButtonClicked), forControlEvents: .TouchUpInside)
		searchBarBackButton.tintColor = ColorgyColor.MainOrange
		
		addSubview(searchBarBackButton)
		
		searchBarBackButton.center.y = searchBarTitleLabel.center.y
		searchBarBackButton.frame.origin.x = 16
	}
	
	private func configureSearchButton() {
		searchButton = UIButton(type: UIButtonType.System)
		searchButton.bounds.size.width = 20
		searchButton.bounds.size.height = 20
		searchButton.setImage(UIImage(named: "OrangeSearchButton"), forState: UIControlState.Normal)
		searchButton.addTarget(self, action: #selector(SearchEventBar.searchButtonClicked), forControlEvents: .TouchUpInside)
		searchButton.tintColor = ColorgyColor.MainOrange
		
		addSubview(searchButton)
		
		searchButton.center.y = searchBarTitleLabel.center.y
		searchButton.frame.origin.x = bounds.width - searchButton.bounds.width - 16
	}
	
	private func configureSearchCancelButton() {
		searchCancelButton = UIButton(type: UIButtonType.System)
		searchCancelButton.bounds.size.width = 100
		searchCancelButton.setTitle("取消", forState: UIControlState.Normal)
		searchCancelButton.titleLabel?.font = UIFont.systemFontOfSize(16)
		searchCancelButton.tintColor = ColorgyColor.MainOrange
		searchCancelButton.sizeToFit()
		searchCancelButton.addTarget(self, action: #selector(SearchEventBar.searchCancelButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
		
		addSubview(searchCancelButton)
		
		searchCancelButton.center.y = searchBarTitleLabel.center.y
		searchCancelButton.frame.origin.x = bounds.width - searchCancelButton.bounds.width - 16
	}
	
	private func configureSearchField() {
		let width = UIScreen.mainScreen().bounds.width - (searchButton.bounds.width + searchCancelButton.bounds.width + 4 * 16)
		searchField = UITextField(frame: CGRect(x: 0, y: 0, width: width, height: 21))
		searchField.placeholder = "搜尋事件..."
		searchField.tintColor = ColorgyColor.MainOrange
		searchField.autocorrectionType = .No
		searchField.autocapitalizationType = .None
		searchField.keyboardType = .Default
		searchField.addTarget(self, action: #selector(SearchEventBar.searchFieldTextChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
		
		addSubview(searchField)
		
		searchField.center.y = searchBarTitleLabel.center.y
		searchField.frame.origin.x = searchButton.bounds.width + 2 * 16
	}
	
	// MARK: - Methods
	@objc private func backButtonClicked() {
		
	}
	
	@objc private func searchButtonClicked() {
		onSearchStage()
	}
	
	@objc private func searchCancelButtonClicked() {
		offSearchStage()
	}
	
	@objc private func searchFieldTextChanged(textField: UITextField) {
		print(textField.text)
		delegate?.searchEventBar(didUpdateSearchText: textField.text)
	}
	
	// MARK: - Animation code
	private func onSearchStage() {
		// search button to left
		// hide back button
		// hide title
		// show cancel
		// show field
		searchCancelButton.show()
		searchField.show()
		UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [.CurveEaseOut], animations: {
			self.searchButton.frame.origin.x = 16
			self.searchBarBackButton.alpha = 0.0
			self.searchBarBackButton.transform = CGAffineTransformMakeTranslation(-200, 0)
			self.searchBarTitleLabel.alpha = 0.0
			self.searchBarTitleLabel.transform = CGAffineTransformMakeTranslation(-200, 0)
			self.searchCancelButton.alpha = 1.0
			self.searchField.alpha = 1.0
			self.searchField.transform = CGAffineTransformIdentity
			}, completion: { (finished) in
				self.isSearching = true
				self.searchBarBackButton.hide()
				self.searchBarTitleLabel.hide()
				self.searchButton.userInteractionEnabled = false
				self.searchField.becomeFirstResponder()
		})
	}
	
	private func offSearchStage() {
		self.isSearching = false
		self.searchBarBackButton.show()
		self.searchBarTitleLabel.show()
		self.searchField.text = ""
		UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [.CurveEaseOut], animations: {
			self.searchButton.frame.origin.x = self.bounds.width - self.searchButton.bounds.width - 16
			self.searchBarBackButton.alpha = 1.0
			self.searchBarBackButton.transform = CGAffineTransformIdentity
			self.searchBarTitleLabel.alpha = 1.0
			self.searchBarTitleLabel.transform = CGAffineTransformIdentity
			self.searchCancelButton.alpha = 0.0
			self.searchField.alpha = 0.0
			self.searchField.transform = CGAffineTransformMakeTranslation(200, 0)
			}, completion: { (finished) in
				self.searchCancelButton.hide()
				self.searchField.hide()
				self.searchButton.userInteractionEnabled = true
				self.searchField.resignFirstResponder()
		})
	}
}
