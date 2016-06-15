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
	private var searchCourseTableView: UITableView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureSearchCourseBar()
		configureSearchCourseTableView()
		viewModel = SearchCourseViewModel(delegate: self)
		
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		
		
		
		
    }
	
	// MARK: - Key
	struct Keys {
		static let cellIdentifer = "cellIdentifer"
	}
	
	// MARK: - Configuration
	private func configureSearchCourseBar() {
		searchBar = SearchCourseBar(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 64)), delegate: self)
		view.addSubview(searchBar)
	}
	
	private func configureSearchCourseTableView() {
		let origin = CGPoint(x: 0, y: searchBar.bounds.height)
		let size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - searchBar.bounds.height)
		searchCourseTableView = UITableView(frame: CGRect(origin: origin, size: size))
		searchCourseTableView.separatorStyle = .None
		searchCourseTableView.backgroundColor = UIColor.clearColor()
		
		searchCourseTableView.delegate = self
		searchCourseTableView.dataSource = self
		searchCourseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Keys.cellIdentifer)
		
		view.addSubview(searchCourseTableView)
	}
}

extension SearchCourseViewController : SearchCourseBarDelegate {
	public func searchCourseBarCancelButtonClicked() {
		
	}
	
	public func searchCourseBar(didUpdateSearchText text: String?) {
		viewModel?.searchCourseWithText(text)
	}
}

extension SearchCourseViewController : SearchCourseViewModelDelegate {
	public func searchCourseViewModelUpdateFilteredCourses(courses: [String]) {
		
	}
}

extension SearchCourseViewController : UITableViewDelegate, UITableViewDataSource {
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.courses.count ?? 0
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Keys.cellIdentifer, forIndexPath: indexPath)
		cell.textLabel?.text = viewModel?.courses[indexPath.row]
		return cell
	}
}