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
	private var notificationSettingsData: [String] = []
	private var viewModel: NotificationSettings

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
		notificationSettingsData.append("上課通知")
		notificationSettingsData.append("點名通知")
		notificationSettingsData.append("系統通知")
		notificationSettingsData.append("打招呼通知")
	}
	
	// MARK: - Selectors
	private func handleSwitchStateChange(to on: Bool, at indexPath: NSIndexPath) {
		switch indexPath.row {
		case 0:
			print(#function, #line)
		case 1:
			print(#function, #line)
		case 2:
			print(#function, #line)
		case 3:
			print(#function, #line)
		default:
			print(#function, #line)
			break
		}
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
		cell.titleLabel.text = notificationSettingsData[indexPath.row]
		cell.delegate = self
		return cell
	}
}

extension NotificationSettingsViewController : SettingsSwitchCellDelegate {
	public func settingsSwitchCell(switchDidChangedIn cell: SettingsSwitchCell, toState on: Bool) {
		guard let indexPath = notificationSettingsTableView.indexPathForCell(cell) else { return }
		handleSwitchStateChange(with: on, at: indexPath)
	}
}