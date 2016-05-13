//
//  SearchEventListViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public final class SearchEventListViewController: UIViewController {
	
	var searchBar: UIView!
	var searchBarTitleLabel: UILabel!
	var searchBarBackButton: UIButton!
	var searchButton: UIButton!
	var searchCancelButton: UIButton!
	var searchField: UITextField!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureSearchBar()
		
		view.backgroundColor = ColorgyColor.BackgroundColor
    }
	
	override public func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	
	}
	
	func delay(time: Double, complete: () -> Void) {
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * time))
		dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
			complete()
		})
	}
	
	// MARK: - configuration
	func configureSearchBar() {
		searchBar = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 64)))
		searchBar.backgroundColor = UIColor.whiteColor()
		
		configureSearchBarTitleLabel()
		configureSearchBarBackButton()
		configureSearchButton()
		configureSearchCancelButton()
		configureSearchField()
		
		searchCancelButton.hide()
		searchField.hide()
		
		view.addSubview(searchBar)
	}
	
	func configureSearchBarTitleLabel() {
		searchBarTitleLabel = UILabel()
		searchBarTitleLabel.text = "事件列表"
		searchBarTitleLabel.font = UIFont.boldSystemFontOfSize(17)
		searchBarTitleLabel.textAlignment = .Center
		searchBarTitleLabel.bounds.size.width = 300
		searchBarTitleLabel.textColor = UIColor.blackColor()
		searchBarTitleLabel.sizeToFit()
		
		searchBar.addSubview(searchBarTitleLabel)
		
		searchBarTitleLabel.center.x = searchBar.bounds.midX
		searchBarTitleLabel.frame.origin.y = 31
	}
	
	func configureSearchBarBackButton() {
		searchBarBackButton = UIButton(type: UIButtonType.System)
		searchBarBackButton.bounds.size.width = 12
		searchBarBackButton.bounds.size.height = 20
		searchBarBackButton.setImage(UIImage(named: "OrangeBackButton"), forState: UIControlState.Normal)
		searchBarBackButton.addTarget(self, action: #selector(SearchEventListViewController.backButtonClicked), forControlEvents: .TouchUpInside)
		searchBarBackButton.tintColor = ColorgyColor.MainOrange
		
		searchBar.addSubview(searchBarBackButton)
		
		searchBarBackButton.center.y = searchBarTitleLabel.center.y
		searchBarBackButton.frame.origin.x = 16
	}
	
	func configureSearchButton() {
		searchButton = UIButton(type: UIButtonType.System)
		searchButton.bounds.size.width = 20
		searchButton.bounds.size.height = 20
		searchButton.setImage(UIImage(named: "OrangeSearchButton"), forState: UIControlState.Normal)
		searchButton.addTarget(self, action: #selector(SearchEventListViewController.searchButtonClicked), forControlEvents: .TouchUpInside)
		searchButton.tintColor = ColorgyColor.MainOrange
		
		searchBar.addSubview(searchButton)
		
		searchButton.center.y = searchBarTitleLabel.center.y
		searchButton.frame.origin.x = searchBar.bounds.width - searchButton.bounds.width - 16
	}
	
	func configureSearchCancelButton() {
		searchCancelButton = UIButton(type: UIButtonType.System)
		searchCancelButton.bounds.size.width = 100
		searchCancelButton.setTitle("取消", forState: UIControlState.Normal)
		searchCancelButton.titleLabel?.font = UIFont.systemFontOfSize(16)
		searchCancelButton.tintColor = ColorgyColor.MainOrange
		searchCancelButton.sizeToFit()
		searchCancelButton.addTarget(self, action: #selector(SearchEventListViewController.searchCancelButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
		
		searchBar.addSubview(searchCancelButton)
		
		searchCancelButton.center.y = searchBarTitleLabel.center.y
		searchCancelButton.frame.origin.x = searchBar.bounds.width - searchCancelButton.bounds.width - 16
	}
	
	func configureSearchField() {
		let width = UIScreen.mainScreen().bounds.width - (searchButton.bounds.width + searchCancelButton.bounds.width + 4 * 16)
		searchField = UITextField(frame: CGRect(x: 0, y: 0, width: width, height: 21))
		searchField.placeholder = "搜尋事件..."
		searchField.tintColor = ColorgyColor.MainOrange
		searchField.autocorrectionType = .No
		searchField.autocapitalizationType = .None
		searchField.keyboardType = .Default
		searchField.addTarget(self, action: #selector(SearchEventListViewController.searchFieldTextChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
		
		searchBar.addSubview(searchField)
		
		searchField.center.y = searchBarTitleLabel.center.y
		searchField.frame.origin.x = searchButton.bounds.width + 2 * 16
	}
	
	// MARK: - Methods
	func backButtonClicked() {
		
	}
	
	func searchButtonClicked() {
		onSearchStage()
	}
	
	func searchCancelButtonClicked() {
		offSearchStage()
	}
	
	func searchFieldTextChanged(textField: UITextField) {
		print(textField.text)
	}
	
	// MARK: - Animation code
	func onSearchStage() {
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
				self.searchBarBackButton.hide()
				self.searchBarTitleLabel.hide()
				self.searchButton.userInteractionEnabled = false
		})
	}
	
	func offSearchStage() {
		self.searchBarBackButton.show()
		self.searchBarTitleLabel.show()
		self.searchField.resignFirstResponder()
		self.searchField.text = ""
		UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [.CurveEaseOut], animations: {
			self.searchButton.frame.origin.x = self.searchBar.bounds.width - self.searchButton.bounds.width - 16
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
		})
	}
}