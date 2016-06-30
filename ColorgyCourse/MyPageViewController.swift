//
//  MyPageViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class MyPageViewController: UIViewController {
	
	private var myPageContainerView: MyPageContainerView!
	private var transitionManager: ColorgyNavigationTransitioningDelegate!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let size = UIScreen.mainScreen().bounds.size
		myPageContainerView = MyPageContainerView(frame: CGRect(origin: CGPointZero, size: size), moreOptionViewDelegate: self)
		view.addSubview(myPageContainerView)
		
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		transitionManager = ColorgyNavigationTransitioningDelegate()
    }

}

extension MyPageViewController : MyPageMoreOptionViewDelegate {
	
	public func myPageMoreOptionViewSettingsTapped() {
		print(#file, #function, #line)
		let settingsVC = StoryboardViewControllerFetchHelper.MyPage.fetchSettingsViewController()
		print(settingsVC)
//		transitionManager.mainViewController = self
//		transitionManager.presentingViewController = settingsVC
//		transitionManager.presentingViewController.transitioningDelegate = transitionManager
		dispatch_sync(dispatch_get_main_queue()) {
			self.presentViewController(settingsVC, animated: true, completion: nil)
		}
	}
	
	public func myPageMoreOptionViewGreetingsTapped() {
		print(#file, #function, #line)
	}
	
	public func myPageMoreOptionViewMyActivityTapped() {
		print(#file, #function, #line)
	}
}