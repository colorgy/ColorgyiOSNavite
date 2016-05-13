//
//  SearchEventListViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class SearchEventListViewController: UIViewController {
	
	var searchBar: UIView!
	var searchBarTitleLabel: UILabel!
	var searchBarBackButton: UIButton!
	var searchButton: UIButton!
	var searchCancelButton: UIButton!
	var searchField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureSearchBar()
    }
	
	// MARK: - configuration
	func configureSearchBar() {
		searchBar = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 64)))
		searchBar.backgroundColor = UIColor.whiteColor()
		
		configureSearchBarTitleLabel()
		configureSearchBarBackButton()
		
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
		
		searchBar.addSubview(searchBarBackButton)
		
		searchBarBackButton.center.y = searchBarTitleLabel.center.y
		searchBarBackButton.frame.origin.x = 16
	}
	
	func configureSearchButton() {
		
	}
	
	func configureSearchCancelButton() {
		
	}
	
	func configureSearchField() {
		
	}
	
	// MARK: - Methods
	func backButtonClicked() {
		
	}
}
