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

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureSearchCourseBar()
    }
	
	private func configureSearchCourseBar() {
		searchBar = SearchCourseBar(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 64)))
		view.addSubview(searchBar)
	}
}
