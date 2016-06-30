//
//  PrivacySettingsViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/30.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class PrivacySettingsViewController: UIViewController {

	// MARK: - Parameters
	private var navigationBar: ColorgyNavigationBar!
	private var privacySettingsTableView: UITableView!
	private var privacySettingsData: [String] = []
	private var viewModel: PrivacySettingsViewModel?
	
	// MARK: - Life Cycle
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		viewModel = PrivacySettingsViewModel(delegate: self)
		
		configurePrivacySettingsData()
		configureNavigationBar()
		configurePrivacySettingsTableView()
		
		view.backgroundColor = ColorgyColor.BackgroundColor
	}
	
	// MARK: - Configuration
	struct Keys {
		static let cellIdentifier = "cell"
	}
	
	private func configureNavigationBar() {
		navigationBar = ColorgyNavigationBar()
		navigationBar.iWantABackButtonAtLeft()
		navigationBar.title = "隱私設定"
		view.addSubview(navigationBar)
	}
	
	private func configurePrivacySettingsTableView() {
		let origin = CGPoint(x: 0, y: navigationBar.frame.height)
		let size = CGSize(
			width: UIScreen.mainScreen().bounds.width,
			height: UIScreen.mainScreen().bounds.height - navigationBar.frame.height)
		privacySettingsTableView = UITableView(frame: CGRect(origin: origin, size: size))
		
		privacySettingsTableView.backgroundColor = UIColor.clearColor()
		privacySettingsTableView.separatorStyle = .None
		
		privacySettingsTableView.registerNib(UINib(nibName: "SettingsSwitchCell", bundle: nil), forCellReuseIdentifier: Keys.cellIdentifier)
		privacySettingsTableView.delegate = self
		privacySettingsTableView.dataSource = self
		
		view.addSubview(privacySettingsTableView)
	}
	
	private func configurePrivacySettingsData() {
		privacySettingsData.append("公開個人頁面")
		privacySettingsData.append("參與同學牆版面")
	}
	
	// MARK: - Selectors
	private func handleSwitchStateChange(to on: Bool, at indexPath: NSIndexPath) {
		switch indexPath.row {
		case 0:
			viewModel?.turnPublicPersonalPage(on)
		case 1:
			viewModel?.turnPaticipateClassmatesWall(on)
		default:
			print(#function, #line)
			break
		}
	}
}


extension PrivacySettingsViewController : UITableViewDelegate, UITableViewDataSource {

	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return privacySettingsData.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Keys.cellIdentifier, forIndexPath: indexPath) as! SettingsSwitchCell
		cell.titleLabel.text = privacySettingsData[indexPath.row]
		cell.delegate = self
		return cell
	}
}

extension PrivacySettingsViewController : SettingsSwitchCellDelegate {
	public func settingsSwitchCell(switchDidChangedIn cell: SettingsSwitchCell, toState on: Bool) {
		guard let indexPath = privacySettingsTableView.indexPathForCell(cell) else { return }
		handleSwitchStateChange(to: on, at: indexPath)
	}
}

extension PrivacySettingsViewController : PrivacySettingsViewModelDelegate {
	
}