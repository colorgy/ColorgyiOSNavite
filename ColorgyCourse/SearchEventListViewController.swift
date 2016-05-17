//
//  SearchEventListViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public final class SearchEventListViewController: UIViewController {
	
	var searchBar: SearchEventBar!
	
	var viewModel: SearchEventListViewModel?

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureSearchBar()
		
		// view model
		viewModel = SearchEventListViewModel(delegate: self)
		
		view.backgroundColor = ColorgyColor.BackgroundColor
    }
	
	// MARK: - configuration
	func configureSearchBar() {
		searchBar = SearchEventBar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 64), delegate: self)
		
		view.addSubview(searchBar)
	}
	
}

extension SearchEventListViewController : SearchEventListViewModelDelegate {
	
	public func searchEventListViewModelUpdateFilteredEvents(events: [String]) {
		print(events.count)
	}
}

extension SearchEventListViewController : SearchEventBarDelegate {
	
	public func searchEventBar(didUpdateSearchText text: String?) {
		viewModel?.searchEventWithText(text)
	}
}