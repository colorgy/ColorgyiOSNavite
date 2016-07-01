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
	
	// MARK: - Life Cycle
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	// MARK: - Configuration
	struct Keys {
		static let cellIdentifier = "cell"
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
		
		accountManagementTableView.registerNib(UINib(nibName: "SettingsSwitchCell", bundle: nil), forCellReuseIdentifier: Keys.cellIdentifier)
		accountManagementTableView.delegate = self
		accountManagementTableView.dataSource = self
		
		view.addSubview(accountManagementTableView)
	}
	
	private func configureAccountManagementData() {
		accountManagementData.append(("信箱", "hello@mail.com"))
		accountManagementData.append(("密碼", "77777777"))
		accountManagementData.append(("手機", "0912345678"))
	}

}

extension AccountManagementViewController : UITableViewDelegate, UITableViewDataSource {
	
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return accountManagementData.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
	}
	
}
