//
//  SettingsViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/29.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class SettingsViewController: UIViewController {
	
	private var navigationBar: ColorgyNavigationBar!
	private var settingsTableView: UITableView!
	private var settingsData: [(title: String, selector: Selector)] = []

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureSettingsData()
		configureNavigationBar()
		configureSettingsTableView()
		
		view.backgroundColor = ColorgyColor.BackgroundColor
    }
	
	// MARK: - Configuration
	private func configureNavigationBar() {
		navigationBar = ColorgyNavigationBar()
		navigationBar.title = "設定"
		navigationBar.iWantABackButtonAtLeft()
		view.addSubview(navigationBar)
	}
	
	private func configureSettingsTableView() {
		let size = CGSize(
			width: UIScreen.mainScreen().bounds.width,
			height: UIScreen.mainScreen().bounds.height - navigationBar.frame.height)
		settingsTableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: navigationBar.frame.height), size: size))
		
		settingsTableView.separatorStyle = .None
		settingsTableView.backgroundColor = UIColor.clearColor()
		
		view.addSubview(settingsTableView)
		
		settingsTableView.registerNib(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: Keys.cellIdentifier)
		settingsTableView.delegate = self
		settingsTableView.dataSource = self
	}
	
	private func configureSettingsData() {
		settingsData.append((title: "帳號管理", selector: #selector(SettingsViewController.gotoAccountManagement)))
		settingsData.append((title: "通知設定", selector: #selector(SettingsViewController.gotoNotificationSettings)))
		settingsData.append((title: "隱私設定", selector: #selector(SettingsViewController.gotoPrivacySettings)))
		settingsData.append((title: "問題回報", selector: #selector(SettingsViewController.gotoReport)))
		settingsData.append((title: "前往 Colorgy 粉絲專頁", selector: #selector(SettingsViewController.gotoFanPage)))
		settingsData.append((title: "登出", selector: #selector(SettingsViewController.logout)))
	}
	
	// MARK: - Keys
	struct Keys {
		static let cellIdentifier = "cell"
	}

	// MARK: - Selectors
	@objc private func gotoAccountManagement() {
		print(#file, #function, #line)
	}
	
	@objc private func gotoNotificationSettings() {
		print(#file, #function, #line)
	}
	
	@objc private func gotoPrivacySettings() {
		print(#file, #function, #line)
	}
	
	@objc private func gotoReport() {
		print(#file, #function, #line)
	}
	
	@objc private func gotoFanPage() {
		print(#file, #function, #line)
	}
	
	@objc private func logout() {
		print(#file, #function, #line)
	}
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
	
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return settingsData.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Keys.cellIdentifier, forIndexPath: indexPath) as! SettingsCell
		
		cell.titleLabel.text = settingsData[indexPath.row].title
		
		return cell
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		performSelector(settingsData[indexPath.row].selector)
	}
}
