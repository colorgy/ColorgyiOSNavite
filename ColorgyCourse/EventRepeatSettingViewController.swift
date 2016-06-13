//
//  EventRepeatSettingViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class EventRepeatSettingViewController: UIViewController {
	
	private var viewModel: EventRepeatSettingViewModel?
	private var repeatSettingTableView: UITableView!
	private var navigationBar: ColorgyNavigationBar!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel = EventRepeatSettingViewModel(delegate: self)
		configureNavigationBar()
		configurRrepeatSettingTableView()
		view.backgroundColor = ColorgyColor.BackgroundColor
    }
	
	struct Keys {
		static let cellIdentifier: String = "cellIdentifier"
	}
	
	private func configureNavigationBar() {
		navigationBar = ColorgyNavigationBar()
		navigationBar.title = "重複"
		view.addSubview(navigationBar)
	}
	
	private func configurRrepeatSettingTableView() {
		let origin: CGPoint = CGPoint(x: 0, y: navigationBar.bounds.height)
		let size: CGSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - navigationBar.bounds.height)
		repeatSettingTableView = UITableView(frame: CGRect(origin: origin, size: size))
		repeatSettingTableView.backgroundColor = UIColor.clearColor()
		repeatSettingTableView.separatorStyle = .None
		
		repeatSettingTableView.delegate = self
		repeatSettingTableView.dataSource = self
		repeatSettingTableView.registerNib(UINib(nibName: "EventRepeatSettingTableViewCell", bundle: nil), forCellReuseIdentifier: Keys.cellIdentifier)
		
		view.addSubview(repeatSettingTableView)
	}

}

extension EventRepeatSettingViewController : UITableViewDelegate, UITableViewDataSource {
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.repeatOptions.count ?? 0
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Keys.cellIdentifier, forIndexPath: indexPath) as! EventRepeatSettingTableViewCell
		cell.titleLabel.text = viewModel?.repeatOptions[indexPath.row].title
		return cell
	}
}


extension EventRepeatSettingViewController : EventRepeatSettingViewModelDelegate {
	
}