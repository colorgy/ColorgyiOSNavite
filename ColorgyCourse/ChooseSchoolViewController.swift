//
//  ChooseSchoolViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/8.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ChooseSchoolViewController: UIViewController {
	
	private var viewModel: ChooseSchoolViewModel?
	private var billboard: ColorgyBillboardView!
	private var schoolTableView: UITableView!
	private var searchBar: ChooseSchoolSearchBar!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		viewModel = ChooseSchoolViewModel(delegate: self)
		configureBillboard()
		configureSearchBar()
		configureSchoolTableView()
    }

	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		viewModel?.fetchSchoolData()
	}
	
	// MARK: - Configuration
	private func configureBillboard() {
		billboard = ColorgyBillboardView(initialImageName: "ChooseSchoolBillboard", errorImageName: "")
		view.addSubview(billboard)
	}
	
	private func configureSchoolTableView() {
		// configure
		let schoolTableViewHeight = UIScreen.mainScreen().bounds.height - billboard.bounds.height
		let schoolTableViewWidth = UIScreen.mainScreen().bounds.width
		schoolTableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: billboard.bounds.height), size: CGSize(width: schoolTableViewWidth, height: schoolTableViewHeight)))
		
		schoolTableView.separatorStyle = .None
		
		view.addSubview(schoolTableView)
		
		// register nib
		schoolTableView.registerNib(UINib(nibName: "ChooseSchoolTableViewCell", bundle: nil), forCellReuseIdentifier: Key.cellIdentifier)
		
		// delegate and datesource
		schoolTableView.dataSource = self
		schoolTableView.delegate = self
	}
	
	private func configureSearchBar() {
		searchBar = ChooseSchoolSearchBar(delegate: self)
		
		view.addSubview(searchBar)
	}
	
	// MARK: - Key
	struct Key {
		static let cellIdentifier = "School Table View Cell Identifier"
	}
}

extension ChooseSchoolViewController : ChooseSchoolViewModelDelegate {
	
	// update filtered school
	public func chooseSchoolViewModel(updateSchool schools: [Organization]) {
		print("yoyo")
		schoolTableView.reloadData()
	}
	
	public func chooseSchoolViewModel(updateFilteredSchool schools: [Organization]) {
		print(schools)
		schoolTableView.reloadData()
	}
	
	public func chooseSchoolViewModel(failToFetchSchoolWith error: APIError, and afError: AFError?) {
		
	}
	
	// Handle organization.
	
	public func chooseSchoolViewModel(updateOrganizationTo organization: Organization) {
		
	}
	
	public func chooseSchoolViewModel(failToUpdateOrganizationWith error: APIError, and afError: AFError?) {
		
	}
}

extension ChooseSchoolViewController : UITableViewDelegate, UITableViewDataSource {
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchBar.isSearching {
			return viewModel?.filteredSchools.count ?? 0
		} else {
			return viewModel?.schools.count ?? 0
		}
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Key.cellIdentifier, forIndexPath: indexPath) as! ChooseSchoolTableViewCell
		cell.school = searchBar.isSearching ? viewModel?.filteredSchools[indexPath.row] : viewModel?.schools[indexPath.row]
		return cell
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if searchBar.isSearching {
			print(viewModel?.filteredSchools[indexPath.row])
		} else {
			print(viewModel?.schools[indexPath.row])
		}
		
	}
}

extension ChooseSchoolViewController : ChooseSchoolSearchBarDelegate {
	public func chooseSchoolSearchBarUpdateSearchText(text: String?) {
		print(text)
		viewModel?.filterSchoolWithText(text)
	}
	
	public func chooseSchoolSearchBarCancelSearching() {
		schoolTableView.reloadData()
	}
}