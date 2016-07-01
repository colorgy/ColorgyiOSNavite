//
//  AccountManagementViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/1.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class AccountManagementViewController: UIViewController {

	// MARK: - Parameters
	private var navigationBar: ColorgyNavigationBar!
	private var accountManagementTableView: UITableView!
	private var accountManagementData: [(title: String, content: String?)] = []
	private var accountManagementSexData: SettingsSexPickerCell.Sex!
	private var needToPickSex: Bool = false {
		didSet {
			reloadSexPickerRegion()
		}
	}
	
	
	// MARK: - Life Cycle
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		configureNavigationBar()
		configureAccountManagementTableView()
		configureAccountManagementData()
		
		view.backgroundColor = ColorgyColor.BackgroundColor
	}
	
	// MARK: - Configuration
	struct Keys {
		static let normalCellIdentifier = "normal cell"
		static let sexCellIdentifier = "sex cell"
		static let sexPickerCellIdentifier = "sex picker cell"
	}
	
	private func configureNavigationBar() {
		navigationBar = ColorgyNavigationBar()
		navigationBar.iWantABackButtonAtLeft()
		navigationBar.title = "帳號管理"
		view.addSubview(navigationBar)
	}
	
	private func configureAccountManagementTableView() {
		let origin = CGPoint(x: 0, y: navigationBar.frame.height)
		let size = CGSize(
			width: UIScreen.mainScreen().bounds.width,
			height: UIScreen.mainScreen().bounds.height - navigationBar.frame.height)
		accountManagementTableView = UITableView(frame: CGRect(origin: origin, size: size))
		
		accountManagementTableView.backgroundColor = UIColor.clearColor()
		accountManagementTableView.separatorStyle = .None
		
		accountManagementTableView.registerNib(UINib(nibName: "SettingsDisplayContentCell", bundle: nil), forCellReuseIdentifier: Keys.normalCellIdentifier)
		accountManagementTableView.registerNib(UINib(nibName: "SettingsSexCell", bundle: nil), forCellReuseIdentifier: Keys.sexCellIdentifier)
		accountManagementTableView.registerNib(UINib(nibName: "SettingsSexPickerCell", bundle: nil), forCellReuseIdentifier: Keys.sexPickerCellIdentifier)
		accountManagementTableView.delegate = self
		accountManagementTableView.dataSource = self
		
		view.addSubview(accountManagementTableView)
	}
	
	private func configureAccountManagementData() {
		accountManagementData.append(("信箱", "hello@mail.com"))
		accountManagementData.append(("密碼", "777"))
		accountManagementData.append(("手機", "0912345678"))
		accountManagementSexData = SettingsSexPickerCell.Sex.Other
	}

	// MARK: - Reload
	private func reloadSexPickerRegion() {
//		accountManagementTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
		let indexPaths = [NSIndexPath(forRow: 4, inSection: 0)]
		if needToPickSex {
			if accountManagementTableView.numberOfRowsInSection(0) == accountManagementData.count + 1 {
				accountManagementTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
			}
		} else {
			if accountManagementTableView.numberOfRowsInSection(0) == accountManagementData.count + 2 {
				accountManagementTableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
			}
		}
	}
	
	// MARK: - Update UI
	private func updateSexText() {
		let cell = accountManagementTableView.cellForRowAtIndexPath(NSIndexPath(forRow: accountManagementData.count, inSection: 0)) as! SettingsSexCell
		cell.contentLabel.text = accountManagementSexData.rawValue
	}
}

extension AccountManagementViewController : UITableViewDelegate, UITableViewDataSource {
	
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return accountManagementData.count + (!needToPickSex ? 1 : 2)
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.row == 3 {
			// sex
			let cell = tableView.dequeueReusableCellWithIdentifier(Keys.sexCellIdentifier, forIndexPath: indexPath) as! SettingsSexCell
			
			cell.titleLabel.text = "性別"
			cell.contentLabel.text = accountManagementSexData.rawValue
			
			return cell
		} else if indexPath.row == 4 {
			// sex picker
			let cell = tableView.dequeueReusableCellWithIdentifier(Keys.sexPickerCellIdentifier, forIndexPath: indexPath) as! SettingsSexPickerCell
			
			cell.delegate = self
			cell.active(selected: accountManagementSexData)
			
			return cell
		} else {
			// normal cell
			let cell = tableView.dequeueReusableCellWithIdentifier(Keys.normalCellIdentifier, forIndexPath: indexPath) as! SettingsDisplayContentCell
			
			cell.titleLabel.text = accountManagementData[indexPath.row].title
			// check if its password slot
			if indexPath.row == 1 {
				cell.contentLabel.text = accountManagementData[indexPath.row].content?.dottedString
			} else {
				cell.contentLabel.text = accountManagementData[indexPath.row].content
			}
			
			return cell
		}
		
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.row == 3 {
			// need to pick sex
			needToPickSex = true
		}
	}
	
}

extension AccountManagementViewController : SettingsSexPickerCellDelegate {
	public func settingsSexPickerCell(didSelect sex: SettingsSexPickerCell.Sex) {
		accountManagementSexData = sex
		updateSexText()
		needToPickSex = false
	}
}