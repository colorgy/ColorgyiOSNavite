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
	
	private var transitionManager: ColorgyNavigationTransitioningDelegate!

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
		let notificationSettingsVC = StoryboardViewControllerFetchHelper.MyPage.fetchNotificationSettingsViewController()
		transit(to: notificationSettingsVC)
	}
	
	@objc private func gotoPrivacySettings() {
		let privacySettingsVC = StoryboardViewControllerFetchHelper.MyPage.fetchPrivacySettingsViewController()
		transit(to: privacySettingsVC)
	}
	
	@objc private func gotoReport() {
		print(#file, #function, #line)
	}
	
	@objc private func gotoFanPage() {
		print(#function, #line)
		let alert = UIAlertController(title: "你正準備離開 Colorgy", message: "您現在要前往我們的粉絲專頁！如果喜歡我們的 App，歡迎幫我們打氣按讚喔！", preferredStyle: UIAlertControllerStyle.Alert)
		let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
			if UIApplication.sharedApplication().canOpenURL(NSURL(string: "fb://profile/1529686803975150")!) {
				UIApplication.sharedApplication().openURL(NSURL(string: "fb://profile/1529686803975150")!)
			} else {
				UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/1529686803975150")!)
			}
		})
		let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
		alert.addAction(ok)
		alert.addAction(cancel)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	@objc private func logout() {
		print(#file, #function, #line)
	}
	
	private func transit(to viewController: UIViewController) {
		transitionManager = ColorgyNavigationTransitioningDelegate()
		transitionManager.mainViewController = self
		transitionManager.presentingViewController = viewController
		transitionManager.presentingViewController.transitioningDelegate = transitionManager
		dispatch_async(dispatch_get_main_queue()) { 
			self.presentViewController(viewController, animated: true, completion: nil)
		}
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
