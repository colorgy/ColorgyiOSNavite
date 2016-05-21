//
//  SearchCourseViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class SearchCourseViewController: UIViewController {
	
	private var searchBar: SearchCourseBar!
	private var viewModel: SearchCourseViewModel?

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureSearchCourseBar()
		viewModel = SearchCourseViewModel(delegate: self)
		
		view.backgroundColor = ColorgyColor.BackgroundColor
    }
	
	private func configureSearchCourseBar() {
		searchBar = SearchCourseBar(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 64)), delegate: self)
		view.addSubview(searchBar)
	}
}

extension SearchCourseViewController : SearchCourseBarDelegate {
	
	public func searchCourseBarCancelButtonClicked() {
		
	}
	
	public func searchCourseBar(didUpdateSearchText text: String?) {
		
	}
}

extension SearchCourseViewController : SearchCourseViewModelDelegate {
	
	public func searchCourseViewModelUpdateFilteredCourses(courses: [String]) {
		
	}
}