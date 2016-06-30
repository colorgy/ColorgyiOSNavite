//
//  NotificationSettingsViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/30.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class NotificationSettingsViewController: UIViewController {
	
	// MARK: - Parameters
	private var navigationBar: ColorgyNavigationBar!
	private var notificationSettingsTableView: UITableView!
	private var notificationSettingsData: [(title: String, selector: Selector)] = []

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureNotificationSettingsData()
		configureNavigationBar()
		configureNotificationSettingsTableView()
		
		view.backgroundColor = ColorgyColor.BackgroundColor
    }
	
	// MARK: - Configuration
	struct Keys {
		static let cellIdentifier = "cell"
	}
	
	private func configureNavigationBar() {
		navigationBar = ColorgyNavigationBar()
		navigationBar.iWantABackButtonAtLeft()
		navigationBar.title = "通知設定"
		view.addSubview(navigationBar)
	}
	
	private func configureNotificationSettingsTableView() {
		let origin = CGPoint(x: 0, y: navigationBar.frame.height)
		let size = CGSize(
			width: UIScreen.mainScreen().bounds.width,
			height: UIScreen.mainScreen().bounds.height - navigationBar.frame.height)
		notificationSettingsTableView = UITableView(frame: CGRect(origin: origin, size: size))
		
		notificationSettingsTableView.backgroundColor = UIColor.clearColor()
		notificationSettingsTableView.separatorStyle = .None
		
		notificationSettingsTableView.registerNib(UINib(nibName: "SettingsSwitchCell", bundle: nil), forCellReuseIdentifier: Keys.cellIdentifier)
		notificationSettingsTableView.delegate = self
		notificationSettingsTableView.dataSource = self
		
		view.addSubview(notificationSettingsTableView)
	}
	
	private func configureNotificationSettingsData() {
		notificationSettingsData.append((title: "上課通知", selector: #selector(NotificationSettingsViewController.courseNotificationSwitch)))
	}
	
	// MARK: - Selectors
	@objc private func courseNotificationSwitch() {
		print(#function, #line)
	}
}

extension NotificationSettingsViewController : UITableViewDelegate, UITableViewDataSource {
	
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notificationSettingsData.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Keys.cellIdentifier, forIndexPath: indexPath) as! SettingsSwitchCell
		return cell
	}
}